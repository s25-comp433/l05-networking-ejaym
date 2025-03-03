//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var isHomeGame: Bool
    var team: String
    var date: String
    var id: Int
    var opponent: String
    var score: Score
}

struct Score: Codable {
    var unc: Int
    var opponent: Int
}

struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        NavigationView {
            List(results, id: \ .id) { item in
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading) {
                        Text("\(item.team) vs. \(item.opponent)")
                            .font(.headline)
                        Text("Date: \(item.date)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    VStack {
                        Text("\(item.score.unc) - \(item.score.opponent)")
                            .font(.body)
                            .bold()
                        Text("\(item.isHomeGame ? "Home" : "Away")")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 4)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("UNC Basketball Games")
        }
        .task {
            await loadData()
        }
    }

    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("invalid url")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            results = try JSONDecoder().decode([Result].self, from: data)
        } catch {
            print("invalid data \(error)")
        }
    }
}

#Preview {
    ContentView()
}
