//
//  FinancialOperationView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import ComposableArchitecture
import SwiftUI

struct FinancialOperationView: View {
    private enum Constants {
        static let textWidth: CGFloat = 90
    }

    @Bindable var store: StoreOf<FinancialOperationFeature>

    @FocusState private var isFocused: Bool

    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private func buttonBackgroundColor(_ operationType: OperationType) -> Color {
        switch operationType {
        case .income:
            Color.green
        case .spending:
            Color.red
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Amount:")
                    .frame(width: Constants.textWidth, alignment: .leading)
                TextField(
                    "0",
                    value: $store.moneyDeposit,
                    formatter: formatter
                )
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .focused($isFocused)
            }

            HStack {
                Text("Category:")
                    .frame(width: Constants.textWidth, alignment: .leading)
                Picker("Category", selection: $store.categoryOperation) {
                    ForEach(store.categories, id: \.self) {
                        Text($0.name)
                    }
                }
                .pickerStyle(.menu)
                Spacer()
            }

            HStack {
                Text("Date:")
                    .frame(width: Constants.textWidth, alignment: .leading)
                DatePicker("Date:", selection: $store.dateOperation, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                Spacer()
            }

            Spacer()

            Button {
                store.send(.save)
            } label: {
                Text("Save")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(buttonBackgroundColor(store.operationType))
                    .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .onTapGesture {
            isFocused = false
        }
        .navigationTitle("Add \(store.state.operationType)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarVisibility(.hidden, for: .tabBar)
    }
}

#Preview {
    FinancialOperationView(
        store: Store(
            initialState: FinancialOperationFeature.State(operationType: .income),
            reducer: { FinancialOperationFeature() }
        )
    )
}
