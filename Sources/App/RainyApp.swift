import SwiftUI

@main
struct RainyApp: App {
    @StateObject private var weatherViewModel = WeatherViewModel()
    @StateObject private var personaViewModel = PersonaViewModel()
    
    var body: some Scene {
        WindowGroup {
            MainWeatherView()
                .environmentObject(weatherViewModel)
                .environmentObject(personaViewModel)
        }
    }
}
