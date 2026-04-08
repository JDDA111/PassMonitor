import SwiftUI
import MapKit

struct MapTabView: View {
    @State private var position: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 46.2, longitude: 9.0),
            span: MKCoordinateSpan(latitudeDelta: 4.0, longitudeDelta: 4.0)
        )
    )
    @State private var selectedPass: AlpinePass?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Map(position: $position) {
                ForEach(alpinePasses) { pass in
                    Annotation(
                        pass.name,
                        coordinate: CLLocationCoordinate2D(latitude: pass.lat, longitude: pass.lon)
                    ) {
                        Button {
                            selectedPass = pass
                            withAnimation(.easeInOut(duration: 0.3)) {
                                position = .region(
                                    MKCoordinateRegion(
                                        center: CLLocationCoordinate2D(latitude: pass.lat, longitude: pass.lon),
                                        span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                                    )
                                )
                            }
                        } label: {
                            Circle()
                                .fill(Theme.statusColor(pass.status))
                                .frame(width: 14, height: 14)
                                .shadow(color: Theme.statusColor(pass.status).opacity(0.6), radius: 4)
                                .overlay(Circle().stroke(Theme.bg, lineWidth: 2.5))
                        }
                    }
                }
            }
            .mapStyle(.standard(elevation: .realistic))
            .ignoresSafeArea(edges: .bottom)
            
            // Selected pass card
            if let pass = selectedPass {
                VStack(spacing: 0) {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation { selectedPass = nil }
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundStyle(Theme.dim)
                        }
                    }
                    .padding(.bottom, 4)
                    
                    HStack(alignment: .top, spacing: 12) {
                        // Status dot
                        Circle()
                            .fill(Theme.statusColor(pass.status))
                            .frame(width: 10, height: 10)
                            .shadow(color: Theme.statusColor(pass.status).opacity(0.6), radius: 4)
                            .padding(.top, 4)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pass.name)
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.text)
                            
                            HStack(spacing: 6) {
                                Text(pass.country.flag)
                                Text("\(pass.elevation)m")
                                    .foregroundStyle(Theme.blue)
                                    .fontWeight(.medium)
                            }
                            .font(.subheadline)
                            
                            Text(pass.status == .open ? "✅ OPEN" : "🔴 CLOSED")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .foregroundStyle(Theme.statusColor(pass.status))
                            
                            if let openDate = pass.openDate {
                                Text("🗓 Opens: \(openDate)")
                                    .font(.caption)
                                    .foregroundStyle(Theme.blue)
                            }
                            
                            Text(pass.note)
                                .font(.caption)
                                .foregroundStyle(Theme.dim)
                                .lineLimit(3)
                                .padding(.top, 2)
                            
                            // Weather
                            HStack(spacing: 8) {
                                WeatherBadge(label: "Wknd 1", forecast: pass.wx1)
                                WeatherBadge(label: "Wknd 2", forecast: pass.wx2)
                            }
                            .padding(.top, 4)
                        }
                        
                        Spacer()
                    }
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ultraThinMaterial)
                        .shadow(color: .black.opacity(0.4), radius: 20)
                )
                .padding(.horizontal, 12)
                .padding(.bottom, 8)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
    }
}
