//
//  DataManager.swift
//  NotesApp
//
//  Created by Сергей Поляков on 27.02.2023.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private var notes: [Note] = []
    
    private init() {}
    
    func createTempData() {
        if !UserDefaults.standard.bool(forKey: "done") {
            StorageManager.shared.create("Первая заметка", "Данное приложение предназначено для хранения заметок") { _ in }
            StorageManager.shared.create("Добавление заметок", "Нажмите на знак + в верхнем правом углу приложения") { _ in }
            StorageManager.shared.create("Удаление заметок", "Сделайте свайп влево и нажмите кнопку delete") { _ in }
            UserDefaults.standard.set(true, forKey: "done")
        }
    }
}
