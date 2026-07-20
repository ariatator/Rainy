import SwiftUI
import AVFoundation

class PersonaViewModel: NSObject, ObservableObject, AVSpeechSynthesizerDelegate {
    @Published var currentPersona: PersonaType = .snarky
    @Published var currentQuote: String = ""
    @Published var swearIntensity: Double = 50.0 // 0 to 100
    @Published var speakAutomatically: Bool = true
    
    private let synthesizer = AVSpeechSynthesizer()
    
    override init() {
        super.init()
        synthesizer.delegate = self
    }
    
    func updateQuote(temp: Int, condition: String) {
        currentQuote = PersonaQuote.getQuote(for: currentPersona, temp: temp, condition: condition, intensity: swearIntensity)
        if speakAutomatically {
            speak(text: currentQuote)
        }
    }
    
    func speak(text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.5
        utterance.pitchMultiplier = 1.0
        
        switch currentPersona {
        case .snarky:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        case .rpg:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        case .hype:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        case .passiveAggressive:
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        }
        
        synthesizer.speak(utterance)
    }
}
