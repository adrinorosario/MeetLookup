//
//  DetailView.swift
//  MeetLookup
//
//  Created by Adrino Rosario on 05/12/24.
//

import MapKit
import SwiftUI

struct DetailView: View {
    var person: Person
    var body: some View {
        NavigationStack {
            VStack {
                getImage(for: person.imageData)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 300, maxHeight: 300)
                
                Text("Name: \(person.name)")
                    .font(.headline)
                Text("Phone number: \(person.phoneNumber)")
                    .font(.headline)
                
                if let latitude = person.latitude, let longitude = person.longitude {
                    Map(initialPosition: getStartPosition(latitude: latitude, longitude: longitude)) {
                        Annotation("", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                            Image(systemName: "mappin")
                                .resizable()
                                .frame(width: 20, height: 54)
                                .foregroundStyle(.red)
                        }
                    }
                    .mapStyle(.hybrid(elevation: .realistic))
                    .frame(height: 250)
                }
            }
            .navigationTitle(person.name)
        }
    }
    
    func getImage(for imageData: Data) -> Image {
        guard let uiImage = UIImage(data: imageData) else {
            return Image(systemName: "person.crop.fill")
        }
        let image = Image(uiImage: uiImage)
        return image
    }
    
    func getStartPosition(latitude: Double, longitude: Double) -> MapCameraPosition {
        let startPosition = MapCameraPosition.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)))
        return startPosition
    }
}

#Preview {
    DetailView(person: Person(name: "Adrino", phoneNumber: "12345241", imageData: Data(), latitude: 19.0176147, longitude: 19.0176147))
}
