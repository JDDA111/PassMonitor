import SwiftUI

struct PassDetailView: View {
    @EnvironmentObject var weatherVM: WeatherViewModel
    let pass: AlpinePass
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Status section
            VStack(alignment: .leading, spacing: 6) {
                Text("STATUS")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .tracking(2)
                    .foregroundStyle(Theme.dim)
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Theme.statusColor(pass.status))
                        .frame(width: 9, height: 9)
                        .shadow(color: Theme.statusColor(pass.status).opacity(0.6), radius: 4)
                    
                    Text(pass.status == .open ? "Open" : "Closed")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundStyle(Theme.statusColor(pass.status))
                }
                
                if let openDate = pass.openDate {
                    Label("Opens: \(openDate)", systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(Theme.green)
                }
                
                Text(pass.note)
                    .font(.caption)
                    .foregroundStyle(Theme.dim)
                    .lineSpacing(3)
            }
            
            // Historical window
            if !pass.yearRound, let h = pass.history {
                VStack(alignment: .leading, spacing: 6) {
                    Text("HISTORICAL WINDOW")
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .tracking(2)
                        .foregroundStyle(Theme.dim)
                    
                    Group {
                        historyRow("Earliest open", DateHelper.dayToString(h.earliestOpen), Theme.green)
                        historyRow("Typical open", "\(DateHelper.dayToString(h.typOpenStart)) – \(DateHelper.dayToString(h.typOpenEnd))", Theme.green)
                        historyRow("Typical close", "\(DateHelper.dayToString(h.typCloseStart)) – \(DateHelper.dayToString(h.typCloseEnd))", Theme.red)
                        historyRow("Latest close", DateHelper.dayToString(h.latestClose), Theme.red)
                    }
                }
            } else if pass.yearRound {
                HStack(spacing: 6) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Theme.green)
                    Text("Open year-round")
                        .foregroundStyle(Theme.green)
                        .fontWeight(.medium)
                }
                .font(.subheadline)
            }
            
            // Weather
            VStack(alignment: .leading, spacing: 8) {
                Text("WEEKEND FORECAST")
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .tracking(2)
                    .foregroundStyle(Theme.dim)
                
                HStack(spacing: 8) {
                    WeatherBadge(
                        label: weatherVM.weekendDates.label1,
                        forecast: weatherVM.forecasts[pass.id]?.wx1 ?? pass.wx1
                    )
                    WeatherBadge(
                        label: weatherVM.weekendDates.label2,
                        forecast: weatherVM.forecasts[pass.id]?.wx2 ?? pass.wx2
                    )
                }
            }
            
            // Source link
            Link(destination: URL(string: pass.sourceURL)!) {
                Label(sourceDomain(pass.sourceURL), systemImage: "arrow.up.right.square")
                    .font(.caption)
                    .foregroundStyle(Theme.blue)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Theme.blue.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Theme.blue.opacity(0.22), lineWidth: 1)
                    )
            }
        }
        .padding(16)
        .background(Theme.bg.opacity(0.9))
    }
    
    private func historyRow(_ label: String, _ value: String, _ color: Color) -> some View {
        HStack {
            Text(label)
                .font(.caption)
                .foregroundStyle(Theme.dim)
            Spacer()
            Text(value)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(color)
        }
    }
    
    private func sourceDomain(_ url: String) -> String {
        url.replacingOccurrences(of: "https://", with: "")
           .replacingOccurrences(of: "http://", with: "")
           .components(separatedBy: "/").first ?? url
    }
}
