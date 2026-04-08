import SwiftUI

struct WeatherBadge: View {
    let label: String
    let forecast: WeatherForecast
    
    var body: some View {
        HStack(spacing: 8) {
            Text(forecast.icon)
                .font(.title2)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundStyle(Theme.blue)
                
                HStack(spacing: 2) {
                    Text("\(forecast.hi)°")
                        .foregroundStyle(Theme.gold)
                        .fontWeight(.bold)
                    Text("/")
                        .foregroundStyle(Theme.dim)
                    Text("\(forecast.lo)°")
                        .foregroundStyle(Theme.blue)
                }
                .font(.subheadline)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 8)
        .background(Theme.surface.opacity(0.8))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
