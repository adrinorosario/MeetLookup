//
//  Person.swift
//  MeetLookup
//
//  Created by Adrino Rosario on 04/12/24.
//

import Foundation
import MapKit
import SwiftData

@Model
class Person {
    var id = UUID()
    var name: String
    var phoneNumber: String
    @Attribute(.externalStorage) var imageData: Data
    
    var latitude: Double?
    var longitude: Double?
    
    init(id: UUID = UUID(), name: String, phoneNumber: String, imageData: Data, latitude: Double = 0.00, longitude: Double = 0.00) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.imageData = imageData
        self.latitude = latitude
        self.longitude = longitude
    }
}
