//
//  GoalCreationView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 08.06.2025.
//

import ComposableArchitecture
import SwiftUI

struct GoalCreationView: View {
    @Bindable var store: StoreOf<GoalCreationFeature>

    @FocusState private var isFocused: Bool
    @State private var bgColor = Color.red

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private func convertColorToHex(color: Color) -> String {
        let components = color.cgColor?.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b: CGFloat = components?[2] ?? 0.0

        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading) {
                Text("Goal name")

                TextField("Title", text: $store.goalInfo.title)
                    .textFieldStyle(.roundedBorder)
            }

            HStack {
                VStack(alignment: .leading) {
                    Text("Current")
                    TextField(
                        "0",
                        value: $store.goalInfo.current,
                        formatter: formatter
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                }

                VStack(alignment: .leading) {
                    Text("Target")
                    TextField(
                        "0",
                        value: $store.goalInfo.target,
                        formatter: formatter
                    )
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                    .focused($isFocused)
                }
            }

            ColorPicker(
                "Set the background color",
                selection: Binding(
                    get: { Color(hex: store.goalInfo.color) },
                    set: { store.goalInfo.color = $0.toHex() }),
                supportsOpacity: false
            )

            Spacer()

            Button(action: {
                store.send(.save)
            }) {
                Text("Save Changes")
                    .frame(height: 50)
            }
            .font(.system(size: 18, weight: .bold, design: .default))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(.blue)
            .cornerRadius(12)
        }
        .padding()
        .background(Color.white)
        .onTapGesture {
            isFocused = false
        }
        .navigationTitle("\(store.state.isNew ? "Create Goal" : "Edit Goal")")
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

#Preview {
    GoalCreationView(store: Store(
        initialState: GoalCreationFeature.State(goalInfo: GoalInfo(id: UUID(), title: "Abc", color: "#1D4ED8", current: 50, target: 100)),
        reducer: { GoalCreationFeature() }
    ))
}
