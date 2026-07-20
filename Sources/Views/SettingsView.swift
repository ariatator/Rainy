import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var personaVM: PersonaViewModel
    
    // List of alternate icons and their internal Info.plist names
    let alternateIcons: [(name: String, iconValue: String?)] = [
        ("Default (Glass)", nil),
        ("Neon Droplet", "AppIconNeon"),
        ("Dark Mode", "AppIconDark"),
        ("Retro 8-bit", "AppIconRetro"),
        ("Golden Hour", "AppIconGold")
    ]
    
    @State private var activeAppIcon: String = "Default (Glass)"
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("AI Persona & Voice").foregroundColor(.gray)) {
                    Picker("Personality Mode", selection: $personaVM.currentPersona) {
                        ForEach(PersonaType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .listRowBackground(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Hostility & Swear Level: \(Int(personaVM.swearIntensity))%")
                            .foregroundColor(.white)
                        Slider(value: $personaVM.swearIntensity, in: 0...100, step: 1)
                            .tint(personaVM.swearIntensity > 80 ? .red : .blue)
                        Text(personaVM.swearIntensity > 80 ? "Warning: Explicit Language" : "Family Friendly")
                            .font(.caption)
                            .foregroundColor(personaVM.swearIntensity > 80 ? .red : .gray)
                    }
                    .padding(.vertical, 5)
                    .listRowBackground(Color.gray.opacity(0.2))
                    
                    Toggle("Speak Automatically", isOn: $personaVM.speakAutomatically)
                        .listRowBackground(Color.gray.opacity(0.2))
                        .foregroundColor(.white)
                }
                
                Section(header: Text("App Icon").foregroundColor(.gray), footer: Text("Changing the app icon will animate to the home screen.").foregroundColor(.gray.opacity(0.6))) {
                    Picker("Select Icon", selection: $activeAppIcon) {
                        ForEach(alternateIcons, id: \.name) { icon in
                            Text(icon.name).tag(icon.name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .listRowBackground(Color.gray.opacity(0.2))
                    .foregroundColor(.white)
                    .onChange(of: activeAppIcon) { newValue in
                        if let selected = alternateIcons.first(where: { $0.name == newValue }) {
                            UIApplication.shared.setAlternateIconName(selected.iconValue) { error in
                                if let error = error {
                                    print("Failed to change app icon: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
                
                Section(header: Text("About").foregroundColor(.gray)) {
                    Text("Rainy v2.0")
                        .foregroundColor(.white)
                        .listRowBackground(Color.gray.opacity(0.2))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Settings")
            .onAppear {
                if let currentIcon = UIApplication.shared.alternateIconName {
                    activeAppIcon = alternateIcons.first(where: { $0.iconValue == currentIcon })?.name ?? "Default (Glass)"
                }
            }
        }
    }
}
