//
//  Profile.swift
//  JournalApp-1.0
//
//  Created by csuftitan on 12/15/21.
//

import Foundation

struct Profile: Codable {
    var name: String
    var goal1: String
    var goal2: String
    var goal3: String
            
    static var archiveURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL =
            documentsDirectory.appendingPathComponent("profiles")
            .appendingPathExtension("plist")
        return archiveURL
    }

    static func saveToFile(profiles: [Profile]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedProfile = try? propertyListEncoder.encode(profiles)

        try? encodedProfile?.write(to: archiveURL, options: .noFileProtection)
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

var userProfile: Profile = Profile(name: "", goal1: "", goal2: "", goal3: "")

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
