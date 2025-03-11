//
//  DetailView.swift
//  Rick and Morty Explorer
//
//  Created by Илья Волощик on 11.03.25.
//

import SwiftUI
import Kingfisher
import rick_morty_swift_api

struct DetailView: View {
    let character: CharacterModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                KFImage(URL(string: character.image))
                    .resizable()
                    .scaledToFit()
                    .frame(height: 300)
                    .cornerRadius(12)
                
                DetailRow(title: "Name", value: character.name)
                DetailRow(title: "Status", value: character.status)
                DetailRow(title: "Species", value: character.species)
                if !character.type.isEmpty {
                    DetailRow(title: "Type", value: character.type)
                }
                DetailRow(title: "Gender", value: character.gender)
                DetailRow(title: "Location", value: character.location.name)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(character.name)
    }
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}
