//
//  ViewController.swift
//  FireNotes
//
//  Created by Pavel Lakhno on 06.03.2025.
//

import UIKit
import RealmSwift

class NotesViewController: UIViewController {
    private var notes: [Note] = []
    private let tableView = UITableView()
    private let textField = UITextField()
    
    private let logoutButton: UIBarButtonItem = {
        return UIBarButtonItem(title: "Logout", style: .plain, target: nil, action: nil)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        loadNotes()
        checkAuth()
    }
    
    private func setupActions() {
        logoutButton.target = self
        logoutButton.action = #selector(logoutButtonTapped)
    }
    
    @objc private func logoutButtonTapped() {
        if AuthService.shared.signOut() {
            NoteService.shared.deleteAllDataFromRealm()
            let authVC = AuthViewController()
            present(authVC, animated: true)
//            navigationController?.popViewController(animated: true)
        }
        
        
//        do {
//            try AuthService.shared.signOut()
//            let authVC = AuthViewController()
//            navigationController?.setViewControllers([authVC], animated: true)
//        } catch {
//            showAlert(message: error.localizedDescription)
//        }
    }
    
    private func checkAuth() {
        if AuthService.shared.currentUserId() == nil {
            // Пользователь не авторизован, перенаправляем на экран авторизации
            let authVC = AuthViewController()
            present(authVC, animated: true)
        }
    }

    private func setupUI() {
        view.backgroundColor = .white
        title = "Заметки"
        navigationItem.rightBarButtonItem = logoutButton

        // Настройка текстового поля
        textField.placeholder = "Введите заметку"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)

        // Настройка кнопки добавления
        let addButton = UIButton(type: .system)
        addButton.setTitle("Добавить", for: .normal)
        addButton.addTarget(self, action: #selector(addNoteButtonTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)

        // Настройка таблицы
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "NoteCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Констрейнты
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8),

            addButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func loadNotes() {
        // Загружаем заметки из Realm
//        notes = NoteService.shared.loadNotesFromRealm()

        // Загружаем заметки из Firestore
        NoteService.shared.loadNotesFromFirestore { [weak self] firestoreNotes in
            
            DispatchQueue.global().async {
                self?.notes = firestoreNotes
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
            
        }
    }

    @objc private func addNoteButtonTapped() {
        guard let text = textField.text, !text.isEmpty else { return }
        guard let userId = AuthService.shared.currentUserId() else { return }

        let note = Note(text: text, userId: userId)

        // Сохраняем заметку в Realm и Firestore
        NoteService.shared.saveNoteToRealm(note: note)
        NoteService.shared.saveNoteToFirestore(note: note)

        // Обновляем таблицу
        notes.append(note)
        tableView.reloadData()
        textField.text = ""
    }
}

extension NotesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].text
        return cell
    }
}
