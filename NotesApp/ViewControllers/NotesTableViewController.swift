//
//  NotesTableViewController.swift
//  NotesApp
//
//  Created by Сергей Поляков on 27.02.2023.
//

import UIKit

class NotesTableViewController: UITableViewController {
    
    // MARK: - Private Properties
    private let cellID = "note"
    private var notes: [Note] = []

    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setupView()
    }

    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Notes"
        navigationController?.navigationBar.prefersLargeTitles = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewNote)
        )
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewNote() {
        let noteVC = NoteViewController()
        noteVC.completion = { [unowned self] title, subtitle in
            if title != "" || subtitle != "" {
                StorageManager.shared.create(title, subtitle) { _ in }
                fetchData()
                tableView.reloadData()
            }
        }
        present(noteVC, animated: true)
    }
    
    private func fetchData() {
        StorageManager.shared.fetchData { [unowned self] result in
            switch result {
            case .success(let notes):
                self.notes = notes
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}



// MARK: - UITableViewDataSource
extension NotesTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let note = notes[indexPath.row]
        content.text = note.title
        content.secondaryText = note.subtitle
        cell.contentConfiguration = content
        return cell
    }
}


// MARK: - UITableViewDelegate
extension NotesTableViewController {
    // Edit note
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let note = notes[indexPath.row]
        let noteVC = NoteViewController()
        noteVC.noteTitle = note.title ?? ""
        noteVC.noteSubtitle = note.subtitle ?? ""
        noteVC.completion = { [unowned self] title, subtitle in
            if title != "" || subtitle != "" {
                StorageManager.shared.update(note, title, subtitle)
                fetchData()
                tableView.reloadData()
//                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        present(noteVC, animated: true)
    }
    
    // Delete task
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            StorageManager.shared.delete(note)
        }
    }
}
