//
//  QueryTag.swift
//  VideoPlay
//
//  Created by Andrei Simedre on 23.05.2025.
//

import SwiftUI

enum Query: String, CaseIterable {
    case sport, nature, food, people, ocean, city, mountains, woods
}

struct QueryTag: View {
    var query: String
    var isSelected: Bool = false

    var body: some View {
        Text(query.capitalized)
            .font(.caption)
            .bold()
            .foregroundStyle(isSelected ? .black : .gray)
            .padding(10)
            .background(.thinMaterial)
            .cornerRadius(10)

    }
    
}

#Preview {
    QueryTag(query: "sport", isSelected: true)
}
