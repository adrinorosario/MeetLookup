//
//  MeetLookupApp.swift
//  MeetLookup
//
//  Created by Adrino Rosario on 04/12/24.
//

import SwiftData
import SwiftUI

@main
struct MeetLookupApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Person.self)
    }
}
