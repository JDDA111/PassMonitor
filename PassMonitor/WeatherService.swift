import Foundation
import Combine

// MARK: - Weekend Dates

struct WeekendDates {
    let sat1: Date
    let sun1: Date
    let sat2: Date
    let sun2: Date

    var label1: String { rangeLabel(sat1, sun1) }
    var label2: String { rangeLabel(sat2, sun2) }

    private func rangeLabel(_ sat: Date, _ sun: Date) -> String {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US")
        df.dateFormat = "MMM d"
        let cal = Calendar.current
        if cal.component(.month, from: sat) == cal.component(.month, from: sun) {
            return "\(df.string(from: sat))–\(cal.component(.day, from: sun))"
        } else {
            return "\(df.string(from: sat))–\(df.string(from: sun))"
        }
    }

    /// Returns the next two weekends (Sat–Sun) from today.
    /// If today is Saturday, weekend 1 = today.
    static func nextTwo() -> WeekendDates {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        // Calendar.weekday: 1 = Sunday … 7 = Saturday
        let weekday = cal.component(.weekday, from: today)
        let daysToSat = (7 - weekday) % 7
        let sat1 = cal.date(byAdding: .day, value: daysToSat, to: today)!
        let sun1 = cal.date(byAdding: .day, value: 1, to: sat1)!
        let sat2 = cal.date(byAdding: .day, value: 7, to: sat1)!
        let sun2 = cal.date(byAdding: .day, value: 1, to: sat2)!
        return WeekendDates(sat1: sat1, sun1: sun1, sat2: sat2, sun2: sun2)
    }
}

// MARK: - Open-Meteo Response

private struct MeteoResponse: Decodable {
    struct Daily: Decodable {
        let temperature_2m_max: [Double?]
        let temperature_2m_min: [Double?]
        let weathercode: [Int?]
    }
    let daily: Daily
}

// MARK: - Weather Service

enum WeatherService {

    /// Fetches a 4-day forecast (sat1…sun2) from Open-Meteo and returns
    /// two `WeatherForecast` values — one per weekend.
    static func fetch(lat: Double, lon: Double, dates: WeekendDates) async throws -> (WeatherForecast, WeatherForecast) {
        let df = DateFormatter()
        df.locale = Locale(identifier: "en_US_POSIX")
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = TimeZone(identifier: "UTC")

        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        comps.queryItems = [
            .init(name: "latitude",   value: String(format: "%.4f", lat)),
            .init(name: "longitude",  value: String(format: "%.4f", lon)),
            .init(name: "daily",      value: "temperature_2m_max,temperature_2m_min,weathercode"),
            .init(name: "timezone",   value: "auto"),
            .init(name: "start_date", value: df.string(from: dates.sat1)),
            .init(name: "end_date",   value: df.string(from: dates.sun2)),
        ]

        let (data, _) = try await URLSession.shared.data(from: comps.url!)
        let resp = try JSONDecoder().decode(MeteoResponse.self, from: data)
        let d = resp.daily

        guard d.temperature_2m_max.count >= 4 else { throw URLError(.badServerResponse) }

        return (forecast(d, range: 0...1), forecast(d, range: 2...3))
    }

    // Build a single WeatherForecast by averaging two days and picking the worst icon.
    private static func forecast(_ d: MeteoResponse.Daily, range: ClosedRange<Int>) -> WeatherForecast {
        let maxT  = range.compactMap { d.temperature_2m_max[$0] }
        let minT  = range.compactMap { d.temperature_2m_min[$0] }
        let codes = range.compactMap { d.weathercode[$0] }

        let hi = maxT.isEmpty ? 0 : Int((maxT.reduce(0, +) / Double(maxT.count)).rounded())
        let lo = minT.isEmpty ? 0 : Int((minT.reduce(0, +) / Double(minT.count)).rounded())
        let icon = wmoIcon(codes.max(by: { severity($0) < severity($1) }) ?? 0)
        return WeatherForecast(icon: icon, hi: hi, lo: lo)
    }

    // WMO severity order (higher = worse) for choosing the representative icon.
    private static func severity(_ code: Int) -> Int {
        switch code {
        case 0:        return 0
        case 1, 2:     return 1
        case 3:        return 2
        case 45, 48:   return 3
        case 51...57:  return 4
        case 61...67:  return 5
        case 71...77:  return 6
        case 80...82:  return 5
        case 85, 86:   return 6
        case 95...99:  return 7
        default:       return 0
        }
    }

    // Map a WMO weather code to an emoji icon.
    private static func wmoIcon(_ code: Int) -> String {
        switch code {
        case 0:        return "☀️"
        case 1, 2:     return "🌤"
        case 3:        return "⛅"
        case 45, 48:   return "🌫"
        case 51...57:  return "🌦"
        case 61...67:  return "🌧"
        case 71, 73:   return "🌨"
        case 75, 77:   return "❄️"
        case 80...82:  return "🌦"
        case 85, 86:   return "🌨"
        case 95...99:  return "⛈"
        default:       return "🌤"
        }
    }
}

// MARK: - Weather View Model

@MainActor
final class WeatherViewModel: ObservableObject {

    struct PassWeather {
        let wx1: WeatherForecast
        let wx2: WeatherForecast
    }

    @Published var forecasts: [String: PassWeather] = [:]
    @Published var weekendDates = WeekendDates.nextTwo()
    @Published var isLoading = false

    private var fetched = false

    func fetchAll(passes: [AlpinePass]) async {
        guard !fetched else { return }
        fetched = true
        isLoading = true
        let dates = weekendDates

        var results: [String: PassWeather] = [:]
        await withTaskGroup(of: (String, PassWeather?).self) { group in
            for pass in passes {
                let id  = pass.id
                let lat = pass.lat
                let lon = pass.lon
                group.addTask {
                    guard let (wx1, wx2) = try? await WeatherService.fetch(lat: lat, lon: lon, dates: dates)
                    else { return (id, nil) }
                    return (id, PassWeather(wx1: wx1, wx2: wx2))
                }
            }
            for await (id, weather) in group {
                if let weather { results[id] = weather }
            }
        }

        forecasts = results
        isLoading = false
    }
}
