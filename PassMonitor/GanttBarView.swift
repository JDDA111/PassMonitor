import SwiftUI

struct GanttBarView: View {
    let pass: AlpinePass
    var compact: Bool = false
    
    private let barHeight: CGFloat = 10
    private let rangeHeight: CGFloat = 4
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let todayX = w * DateHelper.dayToPercent(DateHelper.todayDOY) / 100
            
            ZStack(alignment: .leading) {
                // Month grid lines
                ForEach(0..<12, id: \.self) { i in
                    let x = w * DateHelper.dayToPercent(DateHelper.monthStarts[i]) / 100
                    Rectangle()
                        .fill(Color.white.opacity(0.03))
                        .frame(width: 1)
                        .offset(x: x)
                }
                
                if pass.yearRound {
                    // Year-round bar
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [Theme.green.opacity(0.25), Theme.green.opacity(0.45), Theme.green.opacity(0.25)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(height: barHeight * 0.7)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 3)
                                .stroke(Theme.green.opacity(0.22), lineWidth: 1)
                        )
                        .position(x: w / 2, y: geo.size.height / 2)
                    
                } else if let h = pass.history {
                    let earlyX = w * DateHelper.dayToPercent(h.earliestOpen) / 100
                    let lateX = w * DateHelper.dayToPercent(h.latestClose) / 100
                    let openStartX = w * DateHelper.dayToPercent(h.typOpenStart) / 100
                    let openEndX = w * DateHelper.dayToPercent(h.typOpenEnd) / 100
                    let closeStartX = w * DateHelper.dayToPercent(h.typCloseStart) / 100
                    let closeEndX = w * DateHelper.dayToPercent(h.typCloseEnd) / 100
                    
                    // Full range (faint)
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Theme.blue.opacity(0.08))
                        .overlay(RoundedRectangle(cornerRadius: 2).stroke(Theme.blue.opacity(0.14), lineWidth: 1))
                        .frame(width: lateX - earlyX, height: rangeHeight)
                        .offset(x: earlyX)
                        .position(x: earlyX + (lateX - earlyX) / 2, y: geo.size.height / 2)
                    
                    // Typical opening window (green → blue)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [Theme.green.opacity(0.55), Theme.blue.opacity(0.5)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: max(4, openEndX - openStartX), height: barHeight)
                        .position(x: openStartX + (openEndX - openStartX) / 2, y: geo.size.height / 2)
                    
                    // Typical closing window (blue → red)
                    RoundedRectangle(cornerRadius: 3)
                        .fill(
                            LinearGradient(
                                colors: [Theme.blue.opacity(0.45), Theme.red.opacity(0.5)],
                                startPoint: .leading, endPoint: .trailing
                            )
                        )
                        .frame(width: max(4, closeEndX - closeStartX), height: barHeight)
                        .position(x: closeStartX + (closeEndX - closeStartX) / 2, y: geo.size.height / 2)
                }
                
                // Today line
                Rectangle()
                    .fill(Theme.gold.opacity(0.85))
                    .frame(width: 2)
                    .shadow(color: Theme.gold.opacity(0.5), radius: 3)
                    .offset(x: todayX)
                
                // Status dot on today
                Circle()
                    .fill(Theme.statusColor(pass.status))
                    .frame(width: compact ? 8 : 10, height: compact ? 8 : 10)
                    .shadow(color: Theme.statusColor(pass.status).opacity(0.6), radius: 4)
                    .overlay(Circle().stroke(Theme.bg, lineWidth: 2))
                    .position(x: todayX, y: geo.size.height / 2)
            }
        }
        .frame(height: compact ? 22 : 28)
    }
}
