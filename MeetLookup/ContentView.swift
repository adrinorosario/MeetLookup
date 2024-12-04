//
//  ContentView.swift
//  MeetLookup
//
//  Created by Adrino Rosario on 04/12/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var persons: [Person]
    
    @State private var showingAddPerson = false
    
    var body: some View {
        NavigationStack {
            if persons.isEmpty {
                Button {
                    showingAddPerson.toggle()
                } label: {
                    ContentUnavailableView("No person found.", systemImage: "exclamationmark.magnifyingglass", description: Text("Add a person"))
                }
                .sheet(isPresented: $showingAddPerson) {
                    AddNewPersonView()
                }
                .navigationTitle("Meet Lookup")
                .toolbar {
                    Button("Add person") {
                        showingAddPerson.toggle()
                    }
                }
            } else {
                List(persons) { person in
                    HStack(spacing: 20) {
                        // a round image of the person followed by their name and the location where they met them
                        fetchPersonsImage(for: person.imageData)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(.circle)
                        
                        Text(person.name)
                            .font(.title3)
                    }
                    .frame(height: 50)
                }
                .sheet(isPresented: $showingAddPerson) {
                    AddNewPersonView()
                }
                .navigationTitle("Meet Lookup")
                .toolbar {
                    Button("Add person") {
                        showingAddPerson.toggle()
                    }
                }
            }
        }
    }
    
    func fetchPersonsImage(for imageData: Data) -> Image {
        guard let uiImage = UIImage(data: imageData) else {
            return Image(systemName: "person.crop.circle.fill")
        }
        let personImage = Image(uiImage: uiImage)
        return personImage
    }
    
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Person.self, configurations: config)
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Error: \(error.localizedDescription)")
    }
}
