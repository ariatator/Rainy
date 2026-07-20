import SwiftUI

struct LiquidSlider: View {
    @Binding var value: Double
    var range: ClosedRange<Double>
    var step: Double
    var tint: Color
    
    var body: some View {
        GeometryReader { geometry in
            let trackWidth = geometry.size.width
            let knobWidth: CGFloat = 36
            let usableWidth = trackWidth - knobWidth
            
            let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
            let currentX = usableWidth * CGFloat(percentage)
            
            ZStack(alignment: .leading) {
                // Background Track
                Capsule()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .dark)
                    .frame(height: 24)
                    .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                    .overlay(
                        Capsule()
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
                
                // Fill Track
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [tint.opacity(0.5), tint],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: currentX + knobWidth, height: 24)
                    .mask(Capsule())
                
                // Knob
                Circle()
                    .fill(.ultraThinMaterial)
                    .environment(\.colorScheme, .light)
                    .frame(width: knobWidth, height: knobWidth)
                    .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 3)
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.8), lineWidth: 1)
                            .padding(1)
                    )
                    .offset(x: currentX)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { gestureValue in
                                let deltaX = gestureValue.location.x - (knobWidth / 2)
                                let clampedX = min(max(deltaX, 0), usableWidth)
                                let newPercentage = clampedX / usableWidth
                                let newValue = range.lowerBound + Double(newPercentage) * (range.upperBound - range.lowerBound)
                                
                                // Snap to step
                                let steppedValue = round(newValue / step) * step
                                self.value = min(max(steppedValue, range.lowerBound), range.upperBound)
                            }
                    )
            }
            .frame(height: knobWidth)
        }
        .frame(height: 36)
    }
}

enum Tab: String, CaseIterable {
    case weather = "cloud.sun.fill"
    case radar = "map.fill"
    case settings = "gearshape.fill"
}

struct LiquidTabBar: View {
    @Binding var selectedTab: Tab
    @Namespace private var animation
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases, id: \.self) { tab in
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        selectedTab = tab
                    }
                }) {
                    ZStack {
                        if selectedTab == tab {
                            Capsule()
                                .fill(.ultraThinMaterial)
                                .environment(\.colorScheme, .light)
                                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                                .matchedGeometryEffect(id: "activeTab", in: animation)
                                .frame(height: 44)
                        }
                        
                        Image(systemName: tab.rawValue)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(selectedTab == tab ? .black : .white)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(8)
        .background(.ultraThinMaterial)
        .environment(\.colorScheme, .dark)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.4), radius: 20, x: 0, y: 10)
        .overlay(
            Capsule()
                .stroke(
                    LinearGradient(
                        colors: [.white.opacity(0.5), .clear, .white.opacity(0.2)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .padding(.horizontal, 40)
        .padding(.bottom, 20)
    }
}
