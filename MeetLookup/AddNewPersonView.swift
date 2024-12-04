//
//  AddNewPersonView.swift
//  MeetLookup
//
//  Created by Adrino Rosario on 04/12/24.
//

import MapKit
import PhotosUI
import SwiftData
import SwiftUI

struct AddNewPersonView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var dialCode: String = ""
    
    @State private var selectedImage: PhotosPickerItem?
    @State private var finalImage: Image?
    @State private var userImageData: Data?
    
    @State private var isProcessedImage = false
    @State private var disableForm = true
    
    @State private var disableSave = true
    
    let locationFetcher = LocationFetcher()
    @State private var locationCoordinate = CLLocationCoordinate2D(latitude: 51.50998, longitude: -0.1337)
    @State private var showMap = false
    
    var body: some View {
        NavigationStack {
            Form {
                PhotosPicker(selection: $selectedImage) {
                    if let finalImage {
                        finalImage
                            .resizable()
                            .scaledToFit()
                            .task {
                                disableForm = false
                            }
                    } else {
                        ContentUnavailableView("No picture", systemImage: "photo.badge.plus", description: Text("No image selected. Add an image."))
                    }
                }
                .onChange(of: selectedImage, loadImage)
                

//                if let finalImage {
                    TextField("Name of the person", text: $name)
                    Picker("Dial code", selection: $dialCode) {
                        ForEach(dialCodes, id: \.self) { code in
                            Text(code)
                        }
                    }
                    .pickerStyle(.menu)
                    TextField("Phone number", text: $phoneNumber)
                    
                    Section {
                        Button("Record Location") {
                            locationFetcher.start()
                            
                            if let location = locationFetcher.lastKnownLocation {
                                print("Your location is \(location)")
                                locationCoordinate = location
                                showMap = true
                                
                            } else {
                                print("Location not known")
                            }
                        }
                        
                        if showMap {
                            Map(initialPosition: getStartPosition(for: locationCoordinate), interactionModes: [.zoom]) {
                                Annotation("", coordinate: locationCoordinate) {
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
//                }

                
                Section {
                    Button("Save") {
                        // add a new person
                        let newPerson = Person(name: name, phoneNumber: dialCode + " " + phoneNumber, imageData: userImageData!, latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
                        modelContext.insert(newPerson)
                        
                        dismiss()
                    }
                    .disabled(disableForm)
                }
            }
            .navigationTitle("Add Person Details")
            .toolbar {
                Button("Cancel") {
                    dismiss()
                }
            }
        }
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedImage?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            finalImage = Image(uiImage: inputImage)
            
            userImageData = imageData
            isProcessedImage.toggle()
        }
    }
    
    func getStartPosition(for coordinates: CLLocationCoordinate2D) -> MapCameraPosition {
        let startPosition = MapCameraPosition.region(
            MKCoordinateRegion(
                center: coordinates,
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        )
        return startPosition
    }
}

#Preview {
    AddNewPersonView()
}
