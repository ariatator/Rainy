import SwiftUI

struct LiquidGlassCard<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial)
            .environment(\.colorScheme, .dark) // Forces the deep frosty blur
            .cornerRadius(24)
            .shadow(color: Color.black.opacity(0.4), radius: 20, x: 0, y: 10)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        LinearGradient(
                            colors: [.white.opacity(0.7), .white.opacity(0.1), .clear, .white.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1.5
                    )
            )
            .overlay(
                // Inner specular highlight
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    .blur(radius: 1)
                    .offset(x: -1, y: -1)
                    .mask(RoundedRectangle(cornerRadius: 24))
            )
    }
}

struct LiquidBackgroundView: View {
    var weatherCondition: String
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            let colors: [Color] = {
                let lower = weatherCondition.lowercased()
                if lower.contains("sun") || lower.contains("clear") {
                    return [Color.orange, Color.yellow, Color.pink.opacity(0.8)]
                } else if lower.contains("rain") || lower.contains("drizzle") {
                    return [Color.blue.opacity(0.9), Color.gray, Color.purple.opacity(0.7)]
                } else if lower.contains("storm") {
                    return [Color.indigo, Color.black, Color.purple]
                } else {
                    return [Color.blue.opacity(0.7), Color.cyan, Color.indigo]
                }
            }()
            
            LinearGradient(colors: colors, startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 8.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            
            // Add a subtle mesh noise overlay if desired, here just another blur layer
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.15)
                .ignoresSafeArea()
        }
    }
}
