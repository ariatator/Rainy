import SwiftUI

@main
struct RainyApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var personaViewModel = PersonaViewModel()
    @StateObject private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MainWeatherView()
                    .tabItem {
                        Label("Weather", systemImage: "cloud.sun.fill")
                    }
                
                Text("Radar Map Coming Soon")
                    .foregroundColor(.white)
                    .font(.headline)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.ignoresSafeArea())
                    .tabItem {
                        Label("Radar", systemImage: "map.fill")
                    }
                
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }
            }
            .tint(.white)
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
