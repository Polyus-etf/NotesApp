//
//  DataStore.swift
//  NotesApp
//
//  Created by Сергей Поляков on 27.02.2023.
//

import Foundation

class DataStore {
    static let shared = DataStore()
    
    private var notes: [Note] = []
    
    
    private init() {}
    
    func create() {
        
    }
}
