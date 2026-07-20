import SwiftUI

struct DropletShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: width/2, y: 0))
        path.addCurve(to: CGPoint(x: width, y: height * 0.7),
                      control1: CGPoint(x: width/2 + width*0.1, y: height*0.3),
                      control2: CGPoint(x: width, y: height*0.5))
        path.addArc(center: CGPoint(x: width/2, y: height * 0.7),
                    radius: width/2,
                    startAngle: Angle(degrees: 0),
                    endAngle: Angle(degrees: 180),
                    clockwise: false)
        path.addCurve(to: CGPoint(x: width/2, y: 0),
                      control1: CGPoint(x: 0, y: height*0.5),
                      control2: CGPoint(x: width/2 - width*0.1, y: height*0.3))
        
        return path
    }
}

struct RainyMascotView: View {
    var isAngry: Bool
    @State private var blink = false
    @State private var floatOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Refractive droplet background
            DropletShape()
                .fill(.ultraThinMaterial)
                .background(
                    DropletShape()
                        .fill(isAngry ? Color.red.opacity(0.3) : Color.blue.opacity(0.3))
                        .blur(radius: 10)
                )
                .overlay(
                    DropletShape()
                        .stroke(Color.white.opacity(0.5), lineWidth: 2)
                        .blur(radius: 1)
                )
                .shadow(color: isAngry ? .red.opacity(0.5) : .blue.opacity(0.5), radius: 20)
            
            // Highlight reflection
            DropletShape()
                .fill(LinearGradient(colors: [.white.opacity(0.8), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                .padding(5)
                .scaleEffect(0.9)
                .offset(x: -5, y: -5)
                .blendMode(.overlay)
            
            // Eyes
            HStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 10, height: blink ? 2 : 25)
                    .shadow(color: .white, radius: 5)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(width: 10, height: blink ? 2 : 25)
                    .shadow(color: .white, radius: 5)
            }
            .offset(y: 20)
        }
        .frame(width: 100, height: 120)
        .offset(y: floatOffset)
        .onAppear {
            startBlinking()
            withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                floatOffset = -10
            }
        }
    }
    
    private func startBlinking() {
        Timer.scheduledTimer(withTimeInterval: Double.random(in: 2...5), repeats: true) { _ in
            withAnimation(.linear(duration: 0.1)) { blink = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.linear(duration: 0.1)) { blink = false }
            }
        }
    }
}
