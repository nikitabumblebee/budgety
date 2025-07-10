//
//  GoalsView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct GoalsView: View {
    @Bindable var store: StoreOf<GoalsFeature>

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(viewStore.goals, id: \.id) { goal in
                            Button {
                                viewStore.send(.updateGoal(goal))
                            } label: {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(goal.title)
                                            .fontWeight(.semibold)
                                            .tint(.black)
                                            .font(.title2)
                                        Spacer()
                                        Text(goal.formattedProgress)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 4)
                                    LinearProgressView(
                                        value: goal.progress,
                                        shape: Capsule(),
                                        progressColor: Color(hex: goal.color)
                                    )
                                }
                                .padding(.vertical, 6)
                            }
                        }

                        Spacer()
                    }
                    .padding()
                }
                Button(action: {
                    viewStore.send(.addGoal)
                }) {
                    Text("Add New Goal")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                }
                .padding()
            }
            .navigationTitle("Goals")
        } destination: { store in
            switch store.state {
            case .addGoal:
                if let goalStore = store.scope(state: \.addGoal, action: \.addGoal) {
                    GoalCreationView(store: goalStore)
                }
            case .updateGoal:
                if let goalStore = store.scope(state: \.updateGoal, action: \.updateGoal) {
                    GoalCreationView(store: goalStore)
                }
            }
        }
    }
}

#Preview {
    GoalsView(store: Store(
        initialState: mockGoals,
        reducer: { GoalsFeature() }
    ))
}

struct LinearProgressView<Shape: SwiftUI.Shape>: View {
    var value: Double
    var shape: Shape
    var progressColor: Color
    
    var body: some View {
        shape.fill(Color.gray.opacity(0.3))
            .frame(height: 15)
            .overlay(alignment: .leading) {
                GeometryReader { proxy in
                    shape
                        .fill(progressColor)
                        .frame(width: proxy.size.width * value)
                }
            }
            .clipShape(shape)
    }
}
