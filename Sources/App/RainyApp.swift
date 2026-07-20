import SwiftUI

@main
struct RainyApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var personaViewModel = PersonaViewModel()
    @StateObject private var locationManager = LocationManager()
    
    @State private var selectedTab: Tab = .weather
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .bottom) {
                // Main Content
                Group {
                    switch selectedTab {
                    case .weather:
                        MainWeatherView()
                    case .radar:
                        Text("Radar Map Coming Soon")
                            .foregroundColor(.white)
                            .font(.headline)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.black.ignoresSafeArea())
                    case .settings:
                        SettingsView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // Floating Tab Bar
                LiquidTabBar(selectedTab: $selectedTab)
            }
            .environmentObject(weatherViewModel)
            .environmentObject(personaViewModel)
            .environmentObject(locationManager)
            .preferredColorScheme(.dark)
            .onAppear {
                locationManager.requestLocation()
            }
        }
    }
}
