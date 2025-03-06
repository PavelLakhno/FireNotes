//
//  AuthService.swift
//  FireNotes
//
//  Created by Pavel Lakhno on 05.03.2025.
//

import Foundation
import FirebaseAuth

class AuthService {
    static let shared = AuthService()

    private init() {}

    // Регистрация нового пользователя
    func signUp(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    // Вход пользователя
    func signIn(email: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }

    // Проверка, авторизован ли пользователь
    func currentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }

    // Выход пользователя
    func signOut() -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            print("Ошибка при выходе: \(error.localizedDescription)")
            return false
        }
    }
}
