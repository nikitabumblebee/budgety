//
//  IncomeAndSpendingsView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.05.2025.
//

import ComposableArchitecture
import SwiftUI

struct IncomeAndSpendingsView: View {
    enum Constants {
        static let maxWidthRatio: CGFloat = 0.7
    }

    @Bindable var store: StoreOf<IncomeAndSpendingsFeature>

    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 8) {
                            HStack {
                                Button {
                                    viewStore.send(.addIncome)
                                } label: {
                                    Text("Income")
                                        .font(.system(size: 26, weight: .semibold))
                                }

                                Spacer()

                                Button {
                                    viewStore.send(.addIncome)
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .padding(4)
                                .background(Color.green.opacity(0.2))
                                .clipShape(Circle())
                            }
                            .foregroundStyle(Color(red: 0.086, green: 0.503, blue: 0.242))
                            .padding(.vertical)

                            CardShortDescription(
                                totalValue: viewStore.income,
                                percentageChange: 15,
                                monthLabel: "This month",
                                mainColor: .green
                            )

                            ScrollView(.horizontal) {
                                HStack(spacing: 8) {
                                    ForEach(viewStore.currentIncomeTypes, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 6)
                                            .background(Color.green.opacity(0.15))
                                            .foregroundColor(.green)
                                            .cornerRadius(10)
                                    }
                                }
                                .padding(.bottom)
                            }

                            HStack {
                                Button {
                                    viewStore.send(.addSpending)
                                } label: {
                                    Text("Spendings")
                                        .font(.system(size: 26, weight: .semibold))
                                }

                                Spacer()

                                Button {
                                    viewStore.send(.addSpending)
                                } label: {
                                    Image(systemName: "plus")
                                }
                                .padding(4)
                                .background(Color.red.opacity(0.2))
                                .clipShape(Circle())
                            }
                            .foregroundStyle(Color.red)
                            .padding(.vertical)

                            CardShortDescription(
                                totalValue: viewStore.spendings,
                                percentageChange: 10,
                                monthLabel: "This month",
                                mainColor: .red
                            )

                            SpendingCategoriesView(spendingCategories: viewStore.spendingCategories)

                            if !viewStore.monthHistory.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("History by Month")
                                        .font(.system(size: 26, weight: .semibold))

                                    ForEach(viewStore.monthHistory.prefix(3), id: \.month) { item in
                                        HistoryRow(monthHistory: item) {
                                            
                                        }
                                    }
                                }
                                .padding(.vertical)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
            }
            .navigationTitle("Main")
        } destination: { store in
            switch store.state {
            case .addIncome:
                if let incomeStore = store.scope(state: \.addIncome, action: \.addIncome) {
                    FinancialOperationView(store: incomeStore)
                }
            case .addSpendings:
                if let spendingStore = store.scope(state: \.addSpendings, action: \.addSpendings) {
                    FinancialOperationView(store: spendingStore)
                }
            }
        }
    }
}

struct CardShortDescription: View {
    let totalValue: Double
    let percentageChange: Double
    let monthLabel: String
    let mainColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("$\(totalValue.decimalRepresentation)")
                    .font(.title.bold())
                    .foregroundColor(mainColor)
                Text(monthLabel)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            if percentageChange > 0 {
                Text("+\(percentageChange.decimalRepresentation)%")
                    .font(.subheadline.bold())
                    .foregroundColor(mainColor)
                    .padding(8)
                    .background(mainColor.opacity(0.1))
                    .clipShape(.capsule)
            }
        }
        .padding()
        .background(mainColor.opacity(0.1))
        .cornerRadius(12)
    }
}

struct SpendingCard: View {
    let amount: Double
    let label: String
    let color: Color
    let textColor: Color

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("$\(amount.decimalRepresentation)")
                    .font(.headline)
                    .foregroundColor(textColor)
                Text(label)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding()

            Spacer()
        }
        .background(color)
        .cornerRadius(12)
    }
}

struct HistoryRow: View {
    let monthHistory: MonthHistory
    var onTap: (() -> Void)?

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack {
                Text(monthHistory.month.createMonthAndYearPresentation())
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.black)

                Spacer()

                Text("+$\(monthHistory.income.decimalRepresentation)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.green)

                Spacer()

                Text("-\(monthHistory.spendings.decimalRepresentation)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
}

struct SpendingCategoriesView: View {
    let spendingCategories: [SpendingCategory]

    private let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(spendingCategories.uniques(by: \.type), id: \.self) { tag in
                SpendingCard(amount: tag.amount, label: tag.name, color: Color(hex: tag.color), textColor: Color(hex: tag.textColor))
            }
        }
    }
}

#Preview {
    IncomeAndSpendingsView(store: Store(
        initialState: mockHomeFeatureState,
        reducer: { IncomeAndSpendingsFeature() }
    ))
}
