import SwiftUI

class PersonaViewModel: ObservableObject {
    @Published var currentPersona: PersonaType = .snarky
    @Published var currentQuote: String = ""
    
    func updateQuote(temp: Int, condition: String) {
        currentQuote = PersonaQuote.getQuote(for: currentPersona, temp: temp, condition: condition)
    }
}
