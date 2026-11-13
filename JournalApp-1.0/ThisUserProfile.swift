//
//  Profile.swift
//  JournalApp-1.0
//
//  Created by csuftitan on 12/15/21.
//

import Foundation

struct Profile: Codable {
    var name: String
    var goals: [String]
    var habits: [String]

    init(name: String, goals: [String] = [], habits: [String] = []) {
        self.name = name
        self.goals = goals
        self.habits = habits
    }

    // These properties keep the existing Add Entry goal check-in working
    // while the profile stores a flexible list of goals.
    var goal1: String {
        get { legacyGoal(at: 0) }
        set { setLegacyGoal(newValue, at: 0) }
    }

    var goal2: String {
        get { legacyGoal(at: 1) }
        set { setLegacyGoal(newValue, at: 1) }
    }

    var goal3: String {
        get { legacyGoal(at: 2) }
        set { setLegacyGoal(newValue, at: 2) }
    }

    private enum CodingKeys: String, CodingKey {
        case name, goals, habits, goal1, goal2, goal3
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        habits = try container.decodeIfPresent([String].self, forKey: .habits) ?? []

        if let savedGoals = try container.decodeIfPresent([String].self, forKey: .goals) {
            goals = savedGoals
        } else {
            goals = [
                try container.decodeIfPresent(String.self, forKey: .goal1) ?? "",
                try container.decodeIfPresent(String.self, forKey: .goal2) ?? "",
                try container.decodeIfPresent(String.self, forKey: .goal3) ?? ""
            ].filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(goals, forKey: .goals)
        try container.encode(habits, forKey: .habits)
    }

    private func legacyGoal(at index: Int) -> String {
        goals.indices.contains(index) ? goals[index] : ""
    }

    private mutating func setLegacyGoal(_ value: String, at index: Int) {
        while goals.count <= index {
            goals.append("")
        }
        goals[index] = value
    }
            
    static var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("profiles")
            .appendingPathExtension("plist")
        return archiveURL
    }

    @discardableResult
    static func saveToFile(profiles: [Profile]) -> Bool {
        let propertyListEncoder = PropertyListEncoder()
        guard let encodedProfile = try? propertyListEncoder.encode(profiles) else { return false }

        do {
            try encodedProfile.write(to: archiveURL, options: .atomic)
            return true
        } catch {
            return false
        }
    }

    static func loadFromFile() -> [Profile]? {
        let propertyListDecoder = PropertyListDecoder()
        guard let retrievedProfile = try? Data(contentsOf: archiveURL) else {
            return nil
        }
        let decodedProfile = try? propertyListDecoder.decode(Array<Profile>.self, from: retrievedProfile)
        return decodedProfile
    }
    
}

var userProfile: Profile = Profile.loadFromFile()?.last ?? Profile(name: "")

//var profiles: [Profile] = [] {
//    didSet {
//        Profile.saveToFile(profiles: profiles)
//    }
//}

//func loadSavedProfiles() {
//    if let savedProfiles = Profile.loadFromFile() {
//        profiles = savedProfiles
//    }
//}
