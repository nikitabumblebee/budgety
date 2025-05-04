//
//  GoalCreationView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct GoalCreationView: View {
    @Bindable var store: StoreOf<GoalCreationReducer>

    var body: some View {
        VStack {
            HStack {
                Text("Goal name")
                    .font(.headline)
                Spacer()
            }

            TextField("Title", text: $store.title)
                .textFieldStyle(.roundedBorder)

            Spacer()

            Button(action: {
                store.send(.save)
            }) {
                Text("Save")
                    .frame(height: 50)
            }
        }
        .padding()
        .navigationTitle("\(store.state.isNew ? "Create Goal" : "Edit Goal")")
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

#Preview {
    GoalCreationView(store: Store(
        initialState: GoalCreationReducer.State(goalInfo: GoalInfo(id: UUID(), title: "Abc", color: "#1D4ED8", saved: 50, target: 100)),
        reducer: { GoalCreationReducer() }
    ))
}
