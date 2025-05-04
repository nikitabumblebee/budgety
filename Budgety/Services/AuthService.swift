//
//  AuthService.swift
//  Budgety
//
//  Created by Nikita Shmelev on 04.07.2025.
//

import Foundation
import Combine
import Dependencies

final class AuthService {
    static let shared = AuthService()

    let isAuthenticated = CurrentValueSubject<Bool, Never>(false)
    
    func signIn() {
        isAuthenticated.send(true)
    }
    
    func signOut() {
        isAuthenticated.send(false)
    }
}

struct AuthClient {
    var isAuthenticated: () -> AnyPublisher<Bool, Never>
}

private enum AuthClientKey: DependencyKey {
    static let liveValue: AuthClient = AuthClient(
        isAuthenticated: {
            AuthService.shared.isAuthenticated.eraseToAnyPublisher()
        }
    )
}

extension DependencyValues {
    var authClient: AuthClient {
        get { self[AuthClientKey.self] }
        set { self[AuthClientKey.self] = newValue }
    }
}
