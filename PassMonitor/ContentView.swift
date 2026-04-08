import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var sortOption: SortOption = .earliestOpen
    @State private var sortAscending = true
    @State private var expandedPassID: String?
    
    private var sortedPasses: [AlpinePass] {
        let passes = alpinePasses
        return passes.sorted { a, b in
            if sortOption == .name {
                return sortAscending
                    ? a.name < b.name
                    : a.name > b.name
            }
            let va = a.sortValue(for: sortOption)
            let vb = b.sortValue(for: sortOption)
            return sortAscending ? va < vb : va > vb
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            // Tab content
            TabView(selection: $selectedTab) {
                ganttTab
                    .tag(0)
                
                MapTabView()
                    .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .background(Theme.bg)
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Header
    private var header: some View {
        VStack(spacing: 0) {
            // Title row
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Pass Monitor \(Text(" Alps").font(.system(size: 18, weight: .bold, design: .serif)).foregroundStyle(Theme.blue))")
                        .font(.system(size: 28, weight: .black, design: .serif))
                        .foregroundStyle(Theme.text)
                    
                    Text("\(alpinePasses.count) passes")
                        .font(.caption)
                        .foregroundStyle(Theme.dim)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 12)
            
            // Tab switcher
            HStack(spacing: 2) {
                tabButton("▦ Gantt", tag: 0)
                tabButton("◎ Map", tag: 1)
                Spacer()
            }
            .padding(.horizontal, 16)
            
            Divider()
                .background(Theme.border)
        }
        .background(Theme.bg.opacity(0.97))
    }
    
    private func tabButton(_ title: String, tag: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tag
            }
        } label: {
            Text(title)
                .font(.system(size: 13, weight: .medium, design: .monospaced))
                .tracking(1)
                .textCase(.uppercase)
                .foregroundStyle(selectedTab == tag ? Theme.blue : Theme.dim)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(selectedTab == tag ? Theme.blue.opacity(0.12) : .clear)
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 6, topTrailingRadius: 6))
                .overlay(alignment: .bottom) {
                    if selectedTab == tag {
                        Rectangle()
                            .fill(Theme.blue)
                            .frame(height: 2)
                    }
                }
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Gantt Tab
    private var ganttTab: some View {
        ScrollView {
            VStack(spacing: 10) {
                // Sort bar
                sortBar
                
                // Pass cards
                ForEach(sortedPasses) { pass in
                    PassCardView(
                        pass: pass,
                        isExpanded: expandedPassID == pass.id,
                        onTap: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                expandedPassID = expandedPassID == pass.id ? nil : pass.id
                            }
                        }
                    )
                }
                
                // Legend
                legendView
            }
            .padding(.horizontal, 14)
            .padding(.top, 12)
            .padding(.bottom, 48)
        }
    }
    
    // MARK: - Sort Bar
    private var sortBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                Text("SORT")
                    .font(.system(size: 11, design: .monospaced))
                    .tracking(2)
                    .foregroundStyle(Theme.dim)
                
                ForEach(SortOption.allCases, id: \.self) { option in
                    sortButton(option)
                }
            }
        }
        .padding(.bottom, 6)
    }
    
    private func sortButton(_ option: SortOption) -> some View {
        let isActive = sortOption == option
        return Button {
            if sortOption == option {
                sortAscending.toggle()
            } else {
                sortOption = option
                sortAscending = true
            }
        } label: {
            HStack(spacing: 4) {
                Text(option.rawValue)
                if isActive {
                    Text(sortAscending ? "▲" : "▼")
                        .font(.caption2)
                }
            }
            .font(.system(size: 13))
            .foregroundStyle(isActive ? Theme.blue : Theme.dim)
            .padding(.horizontal, 12)
            .padding(.vertical, 7)
            .background(isActive ? Theme.blue.opacity(0.15) : Theme.surface.opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? Theme.blue.opacity(0.4) : Theme.border.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Legend
    private var legendView: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 14) {
                legendItem(color: Theme.green, label: "Open")
                legendItem(color: Theme.red, label: "Closed")
                
                HStack(spacing: 4) {
                    Rectangle()
                        .fill(Theme.gold.opacity(0.85))
                        .frame(width: 2, height: 13)
                    Text("Today")
                }
            }
            .font(.caption)
            .foregroundStyle(Theme.dim)
            
            Text("Sources: alpen-paesse.ch · Wikipedia")
                .font(.caption2)
                .foregroundStyle(Theme.dim.opacity(0.5))
        }
        .padding(.top, 12)
    }
    
    private func legendItem(color: Color, label: String) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            Text(label)
        }
    }
}

#Preview {
    ContentView()
}
