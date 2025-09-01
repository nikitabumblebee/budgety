//
//  AllMonthsHistoryView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 01.09.2025.
//

import ComposableArchitecture
import SwiftUI

struct AllMonthsHistoryView: View {
    @Bindable var store: StoreOf<AllMonthsHistoryFeature>

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    AllMonthsHistoryView(
        store: Store(
            initialState: AllMonthsHistoryFeature.State(),
            reducer: { AllMonthsHistoryFeature() }
        )
    )
}
