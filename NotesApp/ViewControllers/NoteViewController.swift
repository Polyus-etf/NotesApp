//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Сергей Поляков on 28.02.2023.
//

import UIKit

final class NoteViewController: UIViewController {

    // MARK: - Public Properties
    var noteTitle = ""
    var noteSubtitle = ""
    var completion: ((String, String) -> ())?
    
    
    // MARK: - Private Properties
    private lazy var noteTitleTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.placeholder = "Название"
        textField.font = .boldSystemFont(ofSize: 20)
        textField.textAlignment = .left
        return textField
    }()
    
    private lazy var noteSubtitleTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.font = .systemFont(ofSize: 16)
        textView.textColor = .black
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        return textView
    }()
    
    private lazy var saveButton: UIButton = {
        createButton(
            withTitile: "Save",
            andColor: UIColor(red: 21/255, green: 101/255, blue: 192/255, alpha: 194/255),
            action: UIAction { [unowned self] _ in
                let title = noteTitleTextField.text ?? ""
                let subtitle = noteSubtitleTextView.text ?? ""
                completion?(title, subtitle)
                dismiss(animated: true)
            }
        )
    }()
    
    private lazy var cancelButton: UIButton = {
        createButton(
            withTitile: "Cancel",
            andColor: UIColor(red: 196/255, green: 30/255, blue: 58/255, alpha: 194/255),
            action: UIAction { [unowned self] _ in
                dismiss(animated: true)
            }
        )
    }()
    
    
    // MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupSubviews(noteTitleTextField, noteSubtitleTextView, saveButton, cancelButton)
        setConstraints()
    }
    
    
    // MARK: - Private Methods
    private func saveNote() {
        let title = noteTitleTextField.text ?? ""
        let subtitle = noteSubtitleTextView.text ?? ""
        StorageManager.shared.create(title, subtitle) { _ in }
    }
    
    private func setupView() {
        view.backgroundColor = .white
        noteSubtitleTextView.delegate = self
        noteTitleTextField.text = noteTitle
        noteSubtitleTextView.text = noteSubtitle
    }
    
    private func setupSubviews(_ subviews: UIView...) {
        subviews.forEach { subview in
            view.addSubview(subview)
        }
    }
    
    private func setConstraints() {
        noteTitleTextField.translatesAutoresizingMaskIntoConstraints = false
        noteSubtitleTextView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            noteTitleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            noteTitleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteTitleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noteSubtitleTextView.topAnchor.constraint(equalTo: noteTitleTextField.bottomAnchor, constant: 20),
            noteSubtitleTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteSubtitleTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noteSubtitleTextView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: -20),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancelButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cancelButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    private func createButton(withTitile title: String, andColor color: UIColor, action: UIAction) -> UIButton {
        var attributes = AttributeContainer()
        attributes.font = UIFont.boldSystemFont(ofSize: 18)
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.attributedTitle = AttributedString(title, attributes: attributes)
        buttonConfiguration.baseBackgroundColor = color
        return UIButton(configuration: buttonConfiguration, primaryAction: action)
    }


}

// MARK: - UITextViewDelegate
extension NoteViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = .black
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = .lightGray
            textView.text = "Текст заметки"
            textView.textColor = UIColor.lightGray
        }
    }
}
