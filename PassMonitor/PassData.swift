import Foundation

// MARK: - Weather Data
struct WeatherForecast {
    let icon: String
    let hi: Int
    let lo: Int
}

// MARK: - Pass Status
enum PassStatus: String, CaseIterable {
    case open = "open"
    case closed = "closed"
    
    var color: String {
        switch self {
        case .open: return "passOpen"
        case .closed: return "passClosed"
        }
    }
}

// MARK: - Country
enum Country: String, CaseIterable {
    case CH, IT, FR, AT
    
    var flag: String {
        switch self {
        case .CH: return "🇨🇭"
        case .IT: return "🇮🇹"
        case .FR: return "🇫🇷"
        case .AT: return "🇦🇹"
        }
    }
}

// MARK: - Historical Season Data
/// [earliestOpen, typOpenStart, typOpenEnd, typCloseStart, typCloseEnd, latestClose]
/// Values are day-of-year (1-365)
struct SeasonHistory {
    let earliestOpen: Int
    let typOpenStart: Int
    let typOpenEnd: Int
    let typCloseStart: Int
    let typCloseEnd: Int
    let latestClose: Int
}

// MARK: - Alpine Pass Model
struct AlpinePass: Identifiable {
    let id: String
    let name: String
    let country: Country
    let elevation: Int
    let lat: Double
    let lon: Double
    let yearRound: Bool
    let history: SeasonHistory?
    let sourceURL: String
    let status: PassStatus
    let note: String
    let openDate: String?
    let wx1: WeatherForecast  // Weekend 1
    let wx2: WeatherForecast  // Weekend 2
}

// MARK: - Date Helpers
struct DateHelper {
    static let monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    static let monthStarts = [1, 32, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335]
    static let monthLabels = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
    static let monthLetters = ["J","F","M","A","M","J","J","A","S","O","N","D"]
    
    /// Current day of year
    static var todayDOY: Int {
        Calendar.current.ordinality(of: .day, in: .year, for: Date()) ?? 1
    }
    
    /// Convert day-of-year to percentage of year (0-100)
    static func dayToPercent(_ day: Int) -> Double {
        max(0, min(100, Double(day - 1) / 364.0 * 100.0))
    }
    
    /// Convert day-of-year to string like "May 15"
    static func dayToString(_ doy: Int) -> String {
        var remaining = doy
        for (index, days) in monthDays.enumerated() {
            if remaining <= days {
                return "\(monthLabels[index]) \(remaining)"
            }
            remaining -= days
        }
        return "Dec 31"
    }
}

// MARK: - Data: All Alpine Passes
let alpinePasses: [AlpinePass] = [
    
    // ── Year-round CH ──
    AlpinePass(id: "bernina", name: "Bernina Pass", country: .CH, elevation: 2328,
               lat: 46.412, lon: 9.899, yearRound: true, history: nil,
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/berninapass/",
               status: .open, note: "Open, snow covered. Winter tyres obligatory.",
               openDate: nil,
               wx1: WeatherForecast(icon: "❄️", hi: -2, lo: -8),
               wx2: WeatherForecast(icon: "⛅", hi: 2, lo: -5)),
    
    AlpinePass(id: "julier", name: "Julier Pass", country: .CH, elevation: 2284,
               lat: 46.470, lon: 9.732, yearRound: true, history: nil,
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/julierpass/",
               status: .open, note: "Snow chains obligatory excl. 4WD.",
               openDate: nil,
               wx1: WeatherForecast(icon: "❄️", hi: -1, lo: -7),
               wx2: WeatherForecast(icon: "⛅", hi: 3, lo: -4)),
    
    AlpinePass(id: "maloja", name: "Maloja Pass", country: .CH, elevation: 1815,
               lat: 46.401, lon: 9.697, yearRound: true, history: nil,
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/malojapass/",
               status: .open, note: "Open, no restrictions.",
               openDate: nil,
               wx1: WeatherForecast(icon: "⛅", hi: 2, lo: -4),
               wx2: WeatherForecast(icon: "🌤", hi: 7, lo: 0)),
    
    AlpinePass(id: "ofen", name: "Fuorn / Ofen Pass", country: .CH, elevation: 2149,
               lat: 46.633, lon: 10.290, yearRound: true, history: nil,
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/ofenpass/",
               status: .open, note: "Open, snow covered. Winter tyres obligatory.",
               openDate: nil,
               wx1: WeatherForecast(icon: "❄️", hi: -3, lo: -9),
               wx2: WeatherForecast(icon: "⛅", hi: 1, lo: -5)),
    
    AlpinePass(id: "simplon", name: "Simplon Pass", country: .CH, elevation: 2009,
               lat: 46.251, lon: 8.033, yearRound: true, history: nil,
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/simplonpass/",
               status: .open, note: "Open. Snow covered, closed for truck-trailers.",
               openDate: nil,
               wx1: WeatherForecast(icon: "🌨", hi: -1, lo: -7),
               wx2: WeatherForecast(icon: "⛅", hi: 3, lo: -3)),
    
    // ── Year-round FR ──
    AlpinePass(id: "lautaret", name: "Col du Lautaret", country: .FR, elevation: 2058,
               lat: 45.034, lon: 6.407, yearRound: true, history: nil,
               sourceURL: "https://www.hautesvallees.com/",
               status: .open, note: "Open all year. May close temporarily in severe weather.",
               openDate: nil,
               wx1: WeatherForecast(icon: "🌨", hi: -2, lo: -7),
               wx2: WeatherForecast(icon: "⛅", hi: 2, lo: -3)),
    
    // ── Seasonal CH ──
    AlpinePass(id: "fluela", name: "Flüela Pass", country: .CH, elevation: 2383,
               lat: 46.754, lon: 9.942, yearRound: false,
               history: SeasonHistory(earliestOpen: 96, typOpenStart: 105, typOpenEnd: 120, typCloseStart: 300, typCloseEnd: 320, latestClose: 368),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/flueelapass/",
               status: .closed, note: "Winter closure Jan–May. Car train Vereina available.",
               openDate: "Late Apr 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -10),
               wx2: WeatherForecast(icon: "🌨", hi: -1, lo: -7)),
    
    AlpinePass(id: "gotthard", name: "Gotthard Pass", country: .CH, elevation: 2106,
               lat: 46.549, lon: 8.565, yearRound: false,
               history: SeasonHistory(earliestOpen: 120, typOpenStart: 130, typOpenEnd: 158, typCloseStart: 295, typCloseEnd: 315, latestClose: 341),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/gotthardpass/",
               status: .closed, note: "Winter closure Oct–May. Tunnel always open.",
               openDate: "Mid-May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -3, lo: -9),
               wx2: WeatherForecast(icon: "🌨", hi: 0, lo: -6)),
    
    AlpinePass(id: "grimsel", name: "Grimsel Pass", country: .CH, elevation: 2165,
               lat: 46.562, lon: 8.333, yearRound: false,
               history: SeasonHistory(earliestOpen: 127, typOpenStart: 148, typOpenEnd: 175, typCloseStart: 285, typCloseEnd: 305, latestClose: 325),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/grimselpass/",
               status: .closed, note: "Winter closure Oct–May.",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -10),
               wx2: WeatherForecast(icon: "🌨", hi: -1, lo: -7)),
    
    AlpinePass(id: "furka", name: "Furka Pass", country: .CH, elevation: 2429,
               lat: 46.573, lon: 8.415, yearRound: false,
               history: SeasonHistory(earliestOpen: 127, typOpenStart: 148, typOpenEnd: 178, typCloseStart: 273, typCloseEnd: 300, latestClose: 341),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/furkapass/",
               status: .closed, note: "Winter closure Oct–May. Car train available.",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -6, lo: -12),
               wx2: WeatherForecast(icon: "❄️", hi: -3, lo: -9)),
    
    AlpinePass(id: "susten", name: "Susten Pass", country: .CH, elevation: 2224,
               lat: 46.718, lon: 8.448, yearRound: false,
               history: SeasonHistory(earliestOpen: 144, typOpenStart: 158, typOpenEnd: 192, typCloseStart: 282, typCloseEnd: 309, latestClose: 325),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/sustenpass/",
               status: .closed, note: "Closed. Avalanche danger Meien–Färnigen.",
               openDate: "Early Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -11),
               wx2: WeatherForecast(icon: "🌨", hi: -2, lo: -8)),
    
    AlpinePass(id: "nufenen", name: "Nufenen Pass", country: .CH, elevation: 2478,
               lat: 46.477, lon: 8.381, yearRound: false,
               history: SeasonHistory(earliestOpen: 127, typOpenStart: 148, typOpenEnd: 178, typCloseStart: 273, typCloseEnd: 300, latestClose: 318),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/nufenenpass/",
               status: .closed, note: "Winter closure Oct–May.",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -6, lo: -12),
               wx2: WeatherForecast(icon: "❄️", hi: -3, lo: -9)),
    
    AlpinePass(id: "oberalp", name: "Oberalp Pass", country: .CH, elevation: 2044,
               lat: 46.659, lon: 8.671, yearRound: false,
               history: SeasonHistory(earliestOpen: 103, typOpenStart: 115, typOpenEnd: 138, typCloseStart: 298, typCloseEnd: 315, latestClose: 341),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/oberalppass/",
               status: .closed, note: "Provisional opening 24 Apr 2026.",
               openDate: "24 Apr 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -10),
               wx2: WeatherForecast(icon: "🌨", hi: -1, lo: -7)),
    
    AlpinePass(id: "greatstbernard", name: "Great St Bernard", country: .CH, elevation: 2469,
               lat: 45.869, lon: 7.170, yearRound: false,
               history: SeasonHistory(earliestOpen: 148, typOpenStart: 158, typOpenEnd: 175, typCloseStart: 273, typCloseEnd: 295, latestClose: 318),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/grosser-sankt-bernhard/",
               status: .closed, note: "Expected opening 14 May 2026.",
               openDate: "14 May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -10),
               wx2: WeatherForecast(icon: "⛅", hi: 0, lo: -6)),
    
    AlpinePass(id: "albula", name: "Albula Pass", country: .CH, elevation: 2312,
               lat: 46.582, lon: 9.864, yearRound: false,
               history: SeasonHistory(earliestOpen: 119, typOpenStart: 130, typOpenEnd: 170, typCloseStart: 295, typCloseEnd: 335, latestClose: 353),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/albulapass/",
               status: .closed, note: "Clearance work begins mid-April 2026.",
               openDate: "Mid-May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -3, lo: -9),
               wx2: WeatherForecast(icon: "🌨", hi: 0, lo: -6)),
    
    AlpinePass(id: "splugen", name: "Splügen Pass", country: .CH, elevation: 2113,
               lat: 46.504, lon: 9.322, yearRound: false,
               history: SeasonHistory(earliestOpen: 111, typOpenStart: 120, typOpenEnd: 155, typCloseStart: 285, typCloseEnd: 335, latestClose: 365),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/spluegenpass/",
               status: .closed, note: "Expected opening 1 May 2026.",
               openDate: "1 May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -2, lo: -8),
               wx2: WeatherForecast(icon: "⛅", hi: 2, lo: -4)),
    
    AlpinePass(id: "klausen", name: "Klausen Pass", country: .CH, elevation: 1948,
               lat: 46.878, lon: 8.858, yearRound: false,
               history: SeasonHistory(earliestOpen: 122, typOpenStart: 135, typOpenEnd: 158, typCloseStart: 282, typCloseEnd: 305, latestClose: 335),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/klausenpass/",
               status: .closed, note: "Winter closure Oct–May.",
               openDate: "Early May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -1, lo: -7),
               wx2: WeatherForecast(icon: "⛅", hi: 3, lo: -3)),
    
    AlpinePass(id: "grossscheidegg", name: "Grosse Scheidegg", country: .CH, elevation: 1962,
               lat: 46.654, lon: 8.117, yearRound: false,
               history: SeasonHistory(earliestOpen: 127, typOpenStart: 130, typOpenEnd: 152, typCloseStart: 288, typCloseEnd: 300, latestClose: 318),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/grosse-scheidegg/",
               status: .closed, note: "Opens 14 May 2026. No motor vehicles Schwarzwaldalp–Grindelwald.",
               openDate: "14 May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -2, lo: -8),
               wx2: WeatherForecast(icon: "🌨", hi: 1, lo: -5)),
    
    AlpinePass(id: "sanbernardino", name: "San Bernardino", country: .CH, elevation: 2065,
               lat: 46.494, lon: 9.178, yearRound: false,
               history: SeasonHistory(earliestOpen: 118, typOpenStart: 138, typOpenEnd: 158, typCloseStart: 282, typCloseEnd: 309, latestClose: 335),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/san-bernardinopass/",
               status: .closed, note: "Winter closure Oct–May.",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -2, lo: -8),
               wx2: WeatherForecast(icon: "⛅", hi: 2, lo: -5)),
    
    AlpinePass(id: "croixdecoeur", name: "Croix de Cœur", country: .CH, elevation: 2174,
               lat: 46.082, lon: 7.328, yearRound: false,
               history: SeasonHistory(earliestOpen: 127, typOpenStart: 140, typOpenEnd: 162, typCloseStart: 282, typCloseEnd: 300, latestClose: 318),
               sourceURL: "https://www.myswitzerland.com/",
               status: .closed, note: "Winter closure. Similar Valais cols open mid-May.",
               openDate: "Mid-May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -3, lo: -9),
               wx2: WeatherForecast(icon: "⛅", hi: 1, lo: -5)),
    
    AlpinePass(id: "moiry", name: "Col de Moiry", country: .CH, elevation: 2480,
               lat: 46.074, lon: 7.583, yearRound: false,
               history: SeasonHistory(earliestOpen: 148, typOpenStart: 155, typOpenEnd: 173, typCloseStart: 265, typCloseEnd: 296, latestClose: 315),
               sourceURL: "https://www.valdanniviers.ch/",
               status: .closed, note: "Officially closed until June 2026.",
               openDate: "Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -11),
               wx2: WeatherForecast(icon: "❄️", hi: -2, lo: -8)),
    
    AlpinePass(id: "naret", name: "Lago del Narèt", country: .CH, elevation: 2310,
               lat: 46.432, lon: 8.618, yearRound: false,
               history: SeasonHistory(earliestOpen: 155, typOpenStart: 175, typOpenEnd: 195, typCloseStart: 265, typCloseEnd: 290, latestClose: 320),
               sourceURL: "https://www.ascona-locarno.com/",
               status: .closed, note: "Road controlled by barriers at Fusio. Open summer only.",
               openDate: "Late Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -10),
               wx2: WeatherForecast(icon: "❄️", hi: -2, lo: -7)),
    
    AlpinePass(id: "umbrail", name: "Umbrail Pass", country: .CH, elevation: 2501,
               lat: 46.539, lon: 10.440, yearRound: false,
               history: SeasonHistory(earliestOpen: 140, typOpenStart: 148, typOpenEnd: 168, typCloseStart: 270, typCloseEnd: 292, latestClose: 325),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/umbrailpass/",
               status: .closed, note: "Winter closure Nov–May. Stelvio also closed.",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -6, lo: -12),
               wx2: WeatherForecast(icon: "❄️", hi: -3, lo: -9)),
    
    AlpinePass(id: "livigno", name: "Livigno Pass", country: .CH, elevation: 2315,
               lat: 46.535, lon: 10.292, yearRound: false,
               history: SeasonHistory(earliestOpen: 152, typOpenStart: 165, typOpenEnd: 175, typCloseStart: 268, typCloseEnd: 295, latestClose: 341),
               sourceURL: "https://www.alpen-paesse.ch/en/alpenpaesse/forcola-di-livigno/",
               status: .closed, note: "Expected opening 1 Jun 2026.",
               openDate: "1 Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -11),
               wx2: WeatherForecast(icon: "❄️", hi: -2, lo: -8)),
    
    // ── Seasonal IT ──
    AlpinePass(id: "stelvio", name: "Stelvio Pass", country: .IT, elevation: 2758,
               lat: 46.527, lon: 10.454, yearRound: false,
               history: SeasonHistory(earliestOpen: 143, typOpenStart: 151, typOpenEnd: 163, typCloseStart: 278, typCloseEnd: 308, latestClose: 321),
               sourceURL: "https://www.passodelstelvio.it/en/",
               status: .closed, note: "Scheduled opening 30 May 2026.",
               openDate: "30 May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -7, lo: -12),
               wx2: WeatherForecast(icon: "❄️", hi: -4, lo: -10)),
    
    AlpinePass(id: "gavia", name: "Passo di Gavia", country: .IT, elevation: 2621,
               lat: 46.347, lon: 10.503, yearRound: false,
               history: SeasonHistory(earliestOpen: 155, typOpenStart: 163, typOpenEnd: 183, typCloseStart: 268, typCloseEnd: 295, latestClose: 320),
               sourceURL: "https://www.valcamonica.eu/it/passo-gavia",
               status: .closed, note: "Typically opens mid-June, closes late Oct.",
               openDate: "Mid-Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -6, lo: -12),
               wx2: WeatherForecast(icon: "❄️", hi: -3, lo: -9)),
    
    AlpinePass(id: "foscagno", name: "Passo del Foscagno", country: .IT, elevation: 2291,
               lat: 46.546, lon: 10.370, yearRound: false,
               history: SeasonHistory(earliestOpen: 130, typOpenStart: 143, typOpenEnd: 158, typCloseStart: 278, typCloseEnd: 308, latestClose: 320),
               sourceURL: "https://www.provincia.so.it/",
               status: .closed, note: "Winter closure Oct–May.",
               openDate: "Early May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -11),
               wx2: WeatherForecast(icon: "❄️", hi: -2, lo: -8)),
    
    // ── Seasonal FR ──
    AlpinePass(id: "galibier", name: "Col du Galibier", country: .FR, elevation: 2642,
               lat: 45.064, lon: 6.406, yearRound: false,
               history: SeasonHistory(earliestOpen: 148, typOpenStart: 155, typOpenEnd: 178, typCloseStart: 270, typCloseEnd: 298, latestClose: 320),
               sourceURL: "https://www.hautesvallees.com/",
               status: .closed, note: "Opens end of May (tunnel) / early Jun (summit).",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -11),
               wx2: WeatherForecast(icon: "⛅", hi: -1, lo: -7)),
    
    AlpinePass(id: "iseran", name: "Col de l'Iseran", country: .FR, elevation: 2764,
               lat: 45.417, lon: 7.031, yearRound: false,
               history: SeasonHistory(earliestOpen: 155, typOpenStart: 162, typOpenEnd: 185, typCloseStart: 285, typCloseEnd: 309, latestClose: 325),
               sourceURL: "https://www.bonneval-sur-arc.com/",
               status: .closed, note: "Highest paved road in Alps. Opens early June 2026.",
               openDate: "Early Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -7, lo: -13),
               wx2: WeatherForecast(icon: "❄️", hi: -4, lo: -10)),
    
    AlpinePass(id: "bonette", name: "Col de la Bonette", country: .FR, elevation: 2715,
               lat: 44.327, lon: 6.807, yearRound: false,
               history: SeasonHistory(earliestOpen: 127, typOpenStart: 134, typOpenEnd: 162, typCloseStart: 273, typCloseEnd: 295, latestClose: 318),
               sourceURL: "https://www.mercantour-parcnational.fr/",
               status: .closed, note: "Highest road in France. Opens mid-May to early Jun.",
               openDate: "Mid-Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -5, lo: -10),
               wx2: WeatherForecast(icon: "⛅", hi: -1, lo: -6)),
    
    AlpinePass(id: "montcenis", name: "Col du Mont Cenis", country: .FR, elevation: 2084,
               lat: 45.252, lon: 6.902, yearRound: false,
               history: SeasonHistory(earliestOpen: 120, typOpenStart: 129, typOpenEnd: 145, typCloseStart: 273, typCloseEnd: 305, latestClose: 318),
               sourceURL: "https://www.haute-maurienne-vanoise.com/",
               status: .closed, note: "Opens 2nd Friday of May (8 May 2026). Closes early Nov.",
               openDate: "8 May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -3, lo: -9),
               wx2: WeatherForecast(icon: "⛅", hi: 1, lo: -5)),
    
    AlpinePass(id: "agnel", name: "Col Agnel", country: .FR, elevation: 2744,
               lat: 44.681, lon: 6.980, yearRound: false,
               history: SeasonHistory(earliestOpen: 152, typOpenStart: 162, typOpenEnd: 183, typCloseStart: 265, typCloseEnd: 280, latestClose: 305),
               sourceURL: "https://www.queyras-montagne.com/",
               status: .closed, note: "One of the last cols to open. Typically mid-June.",
               openDate: "Mid-Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -6, lo: -11),
               wx2: WeatherForecast(icon: "⛅", hi: -2, lo: -7)),
    
    AlpinePass(id: "lombarde", name: "Col de la Lombarde", country: .FR, elevation: 2350,
               lat: 44.234, lon: 7.262, yearRound: false,
               history: SeasonHistory(earliestOpen: 143, typOpenStart: 152, typOpenEnd: 175, typCloseStart: 272, typCloseEnd: 295, latestClose: 315),
               sourceURL: "https://www.isola2000.com/",
               status: .closed, note: "Typically opens early June, closes late Oct.",
               openDate: "Mid-May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -9),
               wx2: WeatherForecast(icon: "⛅", hi: 0, lo: -5)),
    
    AlpinePass(id: "littlestbernard", name: "Little St Bernard", country: .FR, elevation: 2188,
               lat: 45.680, lon: 6.882, yearRound: false,
               history: SeasonHistory(earliestOpen: 135, typOpenStart: 143, typOpenEnd: 162, typCloseStart: 278, typCloseEnd: 300, latestClose: 325),
               sourceURL: "https://www.larosiere.net/",
               status: .closed, note: "Typically opens late May / early June. Closes end of October.",
               openDate: "Jun 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -10),
               wx2: WeatherForecast(icon: "⛅", hi: 0, lo: -6)),
    
    // ── Seasonal AT ──
    AlpinePass(id: "grossglockner", name: "Grossglockner", country: .AT, elevation: 2504,
               lat: 47.074, lon: 12.838, yearRound: false,
               history: SeasonHistory(earliestOpen: 101, typOpenStart: 109, typOpenEnd: 130, typCloseStart: 288, typCloseEnd: 305, latestClose: 321),
               sourceURL: "https://www.grossglockner.at/gg/en/erlebnis/hochalpenstrasse",
               status: .closed, note: "Toll road. Expected opening early May 2026.",
               openDate: "Early May 2026",
               wx1: WeatherForecast(icon: "🌨", hi: -2, lo: -7),
               wx2: WeatherForecast(icon: "⛅", hi: 2, lo: -3)),
    
    AlpinePass(id: "timmelsjoch", name: "Timmelsjoch", country: .AT, elevation: 2491,
               lat: 46.902, lon: 11.037, yearRound: false,
               history: SeasonHistory(earliestOpen: 112, typOpenStart: 141, typOpenEnd: 168, typCloseStart: 273, typCloseEnd: 300, latestClose: 321),
               sourceURL: "https://www.timmelsjoch.com/en/",
               status: .closed, note: "Seasonal toll road. AT–IT border.",
               openDate: "Late May 2026",
               wx1: WeatherForecast(icon: "❄️", hi: -4, lo: -9),
               wx2: WeatherForecast(icon: "⛅", hi: 0, lo: -5)),
]
