import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
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
                Section(header: Text("AI Persona").foregroundColor(.gray)) {
                    Picker("Personality Mode", selection: $personaVM.currentPersona) {
                        ForEach(PersonaType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
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
                    Text("Rainy v1.0")
                        .foregroundColor(.white)
                        .listRowBackground(Color.gray.opacity(0.2))
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.blue)
                }
            }
            .onAppear {
                if let currentIcon = UIApplication.shared.alternateIconName {
                    activeAppIcon = alternateIcons.first(where: { $0.iconValue == currentIcon })?.name ?? "Default (Glass)"
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
