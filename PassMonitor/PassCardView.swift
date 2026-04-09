import SwiftUI

struct PassCardView: View {
    let pass: AlpinePass
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Main card
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 10) {
                    
                    // Top row: name + status badge
                    HStack(alignment: .top) {
                        // Status dot + name
                        HStack(alignment: .top, spacing: 10) {
                            Circle()
                                .fill(Theme.statusColor(pass.status))
                                .frame(width: 10, height: 10)
                                .shadow(color: Theme.statusColor(pass.status).opacity(0.6), radius: 4)
                                .padding(.top, 5)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(pass.name)
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Theme.text)
                                    .lineLimit(1)
                                
                                HStack(spacing: 4) {
                                    Text(pass.country.flag)
                                    Text("\(pass.elevation)m")
                                        .foregroundStyle(Theme.blue.opacity(0.7))
                                        .fontWeight(.medium)
                                    if pass.yearRound {
                                        Text("year-round")
                                            .font(.caption2)
                                            .foregroundStyle(Theme.green.opacity(0.5))
                                    }
                                }
                                .font(.subheadline)
                            }
                        }
                        
                        Spacer()
                        
                        // Status badge
                        Text(pass.status == .open ? "Open" : "Closed")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tracking(1)
                            .textCase(.uppercase)
                            .foregroundStyle(Theme.statusColor(pass.status))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(Theme.statusColor(pass.status).opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Theme.statusColor(pass.status).opacity(0.3), lineWidth: 1)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    
                    // Season bar
                    VStack(spacing: 3) {
                        // Month labels
                        HStack(spacing: 0) {
                            ForEach(0..<12, id: \.self) { i in
                                Text(DateHelper.monthLetters[i])
                                    .font(.system(size: 9, design: .monospaced))
                                    .foregroundStyle(Theme.dim.opacity(0.6))
                                    .frame(maxWidth: .infinity)
                            }
                        }
                        
                        GanttBarView(pass: pass, compact: true)
                    }
                    
                    // Weather row
                    HStack(spacing: 8) {
                        WeatherBadge(label: "Apr 11–12", forecast: pass.wx1)
                        WeatherBadge(label: "Apr 18–19", forecast: pass.wx2)
                        
                        if let openDate = pass.openDate {
                            Spacer()
                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Opens")
                                    .font(.caption2)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Theme.blue)
                                Text(openDate)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundStyle(Theme.green)
                            }
                            .padding(.horizontal, 10)
                            .padding(.vertical, 6)
                            .background(Theme.green.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Theme.surface.opacity(0.6))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isExpanded ? Theme.blue.opacity(0.35) : Theme.border.opacity(0.5),
                                    lineWidth: 1
                                )
                        )
                )
            }
            .buttonStyle(.plain)
            
            // Expanded detail
            if isExpanded {
                PassDetailView(pass: pass)
                    .clipShape(
                        UnevenRoundedRectangle(
                            bottomLeadingRadius: 12,
                            bottomTrailingRadius: 12
                        )
                    )
                    .overlay(
                        UnevenRoundedRectangle(
                            bottomLeadingRadius: 12,
                            bottomTrailingRadius: 12
                        )
                        .stroke(Theme.blue.opacity(0.2), lineWidth: 1)
                    )
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}
