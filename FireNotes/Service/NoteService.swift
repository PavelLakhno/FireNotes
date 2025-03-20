//
//  NoteService.swift
//  FirebaseRealm
//
//  Created by Pavel Lakhno on 05.03.2025.
//

import Foundation
import FirebaseFirestore
import RealmSwift

class NoteService {
    static let shared = NoteService()
    private let db = Firestore.firestore()

    private init() {}

    // Сохранение заметки в Firestore
    func saveNoteToFirestore(note: Note) {
        guard let userId = AuthService.shared.currentUserId() else { return }
        db.collection("users").document(userId).collection("notes").document(note.id).setData([
            "text": note.text,
            "userId": userId
        ])
    }

    // Сохранение заметки в Realm
    func saveNoteToRealm(note: Note) {
        let realm = try! Realm()
        try! realm.write {
            realm.add(note)
        }
    }

    // Загрузка заметок из Firestore
    func loadNotesFromFirestore(completion: @escaping ([Note]) -> Void) {
        guard let userId = AuthService.shared.currentUserId() else { return }
        db.collection("users").document(userId).collection("notes").getDocuments { snapshot, error in
            if let documents = snapshot?.documents {
                let notes = documents.map { doc -> Note in
                    let data = doc.data()
                    return Note(text: data["text"] as? String ?? "", userId: userId)
                }
                completion(notes)
            }
        }
    }

    // Загрузка заметок из Realm
    func loadNotesFromRealm() -> [Note] {
        let realm = try! Realm()
        return Array(realm.objects(Note.self))
    }
    
    func deleteAllDataFromRealm() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
}
