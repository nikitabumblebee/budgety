//
//  SignInView.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.07.2025.
//

import AuthenticationServices
import ComposableArchitecture
import SwiftUI

struct SignInView: View {
    let store: StoreOf<SignInFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack {
                    Image("splash-screen")

                    VStack(spacing: 22) {
                        Text("Save smart\nSpend wisely")
                            .multilineTextAlignment(.center)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        Text("Balance today’s needs with tomorrow’s goals")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                    .padding()

                    Spacer()

                    SignInWithAppleButton { request in
                        request.requestedScopes = [.fullName, .email]
                    } onCompletion: { result in
                        switch result {
                        case .success(let authResults):
                            viewStore.send(.login)
                            guard let credential = authResults.credential as? ASAuthorizationAppleIDCredential else { return }
                            // Handle successful login with credential

                        case .failure(let error):
                            // Handle error
                            viewStore.send(.login)
                        }
                    }
                    .frame(height: 50)
                    .clipShape(.capsule)
                }
                .padding()
                .background(Color(hex: "#59E15C"))
            }
        }
    }
}

#Preview {
    SignInView(store: Store(initialState: SignInFeature.State(), reducer: { SignInFeature() }))
}
