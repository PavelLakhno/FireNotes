//
//  Note.swift
//  FireNotes
//
//  Created by Pavel Lakhno on 06.03.2025.
//

import Foundation
import RealmSwift
import FirebaseFirestore

class Note: Object {
    @Persisted var id: String = UUID().uuidString
    @Persisted var text: String = ""
    @Persisted var userId: String = ""

    convenience init(text: String, userId: String) {
        self.init()
        self.text = text
        self.userId = userId
    }
}
