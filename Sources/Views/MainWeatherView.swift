import SwiftUI

struct MainWeatherView: View {
    @EnvironmentObject var weatherVM: WeatherViewModel
    @EnvironmentObject var personaVM: PersonaViewModel
    @State private var showTrackerSettings = false
    @State private var showSettings = false
    @State private var selectedTracker: TrackingType = .rain
    
    var body: some View {
        NavigationView {
            ZStack {
                LiquidBackgroundView(weatherCondition: weatherVM.currentCondition.condition)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        
                        // Header & Mascot
                        HStack {
                            VStack(alignment: .leading) {
                                Text("New York, NY")
                                    .font(.system(size: 32, weight: .bold, design: .rounded))
                                    .foregroundColor(.white)
                                Text("\(weatherVM.currentCondition.temperature)°")
                                    .font(.system(size: 72, weight: .heavy, design: .rounded))
                                    .foregroundColor(.white)
                                Text(weatherVM.currentCondition.condition)
                                    .font(.title2)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                            RainyMascotView(isAngry: personaVM.currentPersona == .snarky && weatherVM.currentCondition.temperature > 80)
                                .onTapGesture {
                                    personaVM.updateQuote(temp: weatherVM.currentCondition.temperature, condition: weatherVM.currentCondition.condition)
                                }
                        }
                        .padding(.horizontal)
                        .padding(.top, 40)
                        
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
                        
                        // Survival Index & Quote
                        LiquidGlassCard {
                            VStack(spacing: 10) {
                                HStack {
                                    Text("Touch Grass Index")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(weatherVM.survivalIndex)/100")
                                        .font(.title3.bold())
                                        .foregroundColor(weatherVM.survivalIndex > 50 ? .green : .red)
                                }
                                
                                Divider().background(Color.white.opacity(0.5))
                                
                                Text(personaVM.currentQuote.isEmpty ? "Tap Rainy to see a quote..." : personaVM.currentQuote)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .italic()
                                    .multilineTextAlignment(.leading)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(
                Button(action: { showSettings.toggle() }) {
                    Image(systemName: "gearshape.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                }
                .padding(),
                alignment: .topTrailing
            )
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .onAppear {
                personaVM.updateQuote(temp: weatherVM.currentCondition.temperature, condition: weatherVM.currentCondition.condition)
            }
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
