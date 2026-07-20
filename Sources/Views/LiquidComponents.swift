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
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            )
    }
}

struct LiquidBackgroundView: View {
    var weatherCondition: String
    @State private var animateGradient = false
    
    var body: some View {
        ZStack {
            let colors: [Color] = {
                if weatherCondition.lowercased().contains("sun") || weatherCondition.lowercased().contains("clear") {
                    return [Color.orange, Color.yellow, Color.pink.opacity(0.5)]
                } else if weatherCondition.lowercased().contains("rain") {
                    return [Color.blue.opacity(0.8), Color.gray, Color.purple.opacity(0.6)]
                } else {
                    return [Color.blue, Color.cyan, Color.indigo]
                }
            }()
            
            LinearGradient(colors: colors, startPoint: animateGradient ? .topLeading : .bottomLeading, endPoint: animateGradient ? .bottomTrailing : .topTrailing)
                .ignoresSafeArea()
                .onAppear {
                    withAnimation(.easeInOut(duration: 5.0).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
            
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.2)
                .ignoresSafeArea()
        }
    }
}
