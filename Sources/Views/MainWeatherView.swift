import SwiftUI
import CoreLocation

struct MainWeatherView: View {
    @EnvironmentObject var weatherVM: WeatherViewModel
    @EnvironmentObject var personaVM: PersonaViewModel
    @EnvironmentObject var locationManager: LocationManager
    
    @State private var showTrackerSettings = false
    @State private var selectedTracker: TrackingType = .rain
    @State private var locationName: String = "Locating..."
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidBackgroundView(weatherCondition: weatherVM.currentCondition.condition)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Header & Mascot
                        HStack {
                            VStack(alignment: .leading) {
                                Text(locationName)
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                
                                if weatherVM.isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("\(weatherVM.currentCondition.temperature)°")
                                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                                        .foregroundColor(.white)
                                    Text(weatherVM.currentCondition.condition)
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            Spacer()
                            RainyMascotView(isAngry: personaVM.currentPersona == .snarky && weatherVM.currentCondition.temperature > 80)
                                .onTapGesture {
                                    personaVM.updateQuote(temp: weatherVM.currentCondition.temperature, condition: weatherVM.currentCondition.condition)
                                }
                        }
                        .padding(.horizontal)
                        .padding(.top, 40)
                        
                        // AI Quote Card
                        LiquidGlassCard {
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    Image(systemName: "sparkles")
                                    Text(personaVM.currentPersona.rawValue)
                                        .font(.headline)
                                    Spacer()
                                    if personaVM.swearIntensity > 80 {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                    }
                                }
                                .foregroundColor(.white.opacity(0.8))
                                
                                Text(personaVM.currentQuote.isEmpty ? "Tap Rainy to wake me up." : personaVM.currentQuote)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .italic()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                        
                        // Weather Data Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 15) {
                            DataCard(icon: "sun.max.fill", title: "UV Index", value: "\(weatherVM.currentCondition.uvIndex)", color: .yellow)
                            DataCard(icon: "wind", title: "Wind", value: "\(weatherVM.currentCondition.windSpeed) mph", color: .teal)
                            DataCard(icon: "aqi.high", title: "Air Quality", value: "\(weatherVM.currentCondition.airQuality)", color: weatherVM.currentCondition.airQuality > 50 ? .orange : .green)
                            DataCard(icon: "drop.fill", title: "Humidity", value: "\(weatherVM.currentCondition.humidity)%", color: .blue)
                        }
                        .padding(.horizontal)
                        
                        // Live Activity Launcher
                        Button(action: { showTrackerSettings.toggle() }) {
                            LiquidGlassCard {
                                HStack {
                                    Image(systemName: "livephoto.play")
                                    Text("Start Custom Live Tracker")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                }
                                .foregroundColor(.white)
                                .font(.headline)
                            }
                        }
                        .padding(.horizontal)
                        .sheet(isPresented: $showTrackerSettings) {
                            TrackerConfigView(selectedTracker: $selectedTracker)
                        }
                        
                        // Survival Index
                        LiquidGlassCard {
                            HStack {
                                Text("Touch Grass Index")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Text("\(weatherVM.survivalIndex)/100")
                                    .font(.title3.bold())
                                    .foregroundColor(weatherVM.survivalIndex > 50 ? .green : .red)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
            }
            .ignoresSafeArea(.all)
            .navigationBarHidden(true)
            .onChange(of: locationManager.location) { newLocation in
                if let loc = newLocation {
                    Task {
                        await weatherVM.fetchLiveWeather(lat: loc.coordinate.latitude, lon: loc.coordinate.longitude)
                        personaVM.updateQuote(temp: weatherVM.currentCondition.temperature, condition: weatherVM.currentCondition.condition)
                    }
                    reverseGeocode(location: loc)
                }
            }
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                DispatchQueue.main.async {
                    if let city = placemark.locality {
                        self.locationName = city
                    } else if let name = placemark.name {
                        self.locationName = name
                    } else {
                        self.locationName = "Unknown Location"
                    }
                }
            }
        }
    }
}

struct DataCard: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        LiquidGlassCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                    Text(title)
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                Text(value)
                    .font(.title2.bold())
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Subview for Tracker Configuration
struct TrackerConfigView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var weatherVM: WeatherViewModel
    @EnvironmentObject var personaVM: PersonaViewModel
    @Binding var selectedTracker: TrackingType
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Tracker").foregroundColor(.gray)) {
                    Picker("Tracker Type", selection: $selectedTracker) {
                        ForEach(TrackingType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .listRowBackground(Color.clear)
                }
                
                Section {
                    Button(action: {
                        weatherVM.startCustomLiveActivity(type: selectedTracker, persona: personaVM.currentPersona)
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Start Tracking")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.blue)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                    
                    Button(action: {
                        weatherVM.endLiveActivity()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Stop Active Tracker")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.red)
                    }
                    .listRowBackground(Color.gray.opacity(0.2))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Configure Tracker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { presentationMode.wrappedValue.dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
