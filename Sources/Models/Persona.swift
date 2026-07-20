import Foundation

enum PersonaType: String, CaseIterable {
    case snarky = "Snarky Bot"
    case rpg = "Fantasy Narrator"
    case hype = "Hype Beast"
    case passiveAggressive = "Passive Aggressive"
}

struct PersonaQuote {
    static func getQuote(for type: PersonaType, temp: Int, condition: String) -> String {
        switch type {
        case .snarky:
            if condition.lowercased().contains("rain") { return "It's raining. Perfect excuse for you not to go to the gym, right?" }
            if temp > 85 { return "It's \(temp)°. Why are you outside? Go back to your air-conditioned cave." }
            else if temp < 40 { return "It's freezing out there. I hope you brought a jacket, but knowing you, probably not." }
            else { return "It's \(temp)°. Tolerable, but I still wouldn't go outside if I were you." }
        case .rpg:
            if condition.lowercased().contains("rain") { return "The sky weeps. Equip your Water Resistance gear." }
            if temp > 85 { return "The Sun Orb blazes with fury! Equip your Cloak of Shade." }
            else if temp < 40 { return "Frost giants roam the lands. Drinkable Elixirs of Warmth are required." }
            else { return "The realm is peaceful. A fine day for a quest." }
        case .hype:
            if condition.lowercased().contains("rain") { return "Rainy day vibes. Stay cozy fam." }
            if temp > 85 { return "Fr fr it's boiling rn. Absolute drip check mandatory today 🔥." }
            else if temp < 40 { return "Ice cold outside 🥶. Layer up fam." }
            else { return "Vibes are immaculate today. 💯" }
        case .passiveAggressive:
            if condition.lowercased().contains("rain") { return "Oh, raining. Let me guess, your whole day is ruined now." }
            if temp > 85 { return "Oh, you're going out in this heat? Brave choice." }
            else if temp < 40 { return "Sure, wear shorts today. See if I care." }
            else { return "It's fine. Not like you'll notice anyway while staring at your phone." }
        }
    }
}
