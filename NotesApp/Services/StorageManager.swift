//
//  StorageManager.swift
//  NotesApp
//
//  Created by Сергей Поляков on 27.02.2023.
//

import CoreData

class StorageManager {
    
    // MARK: - Public Properties
    static let shared = StorageManager()
    
    
    // MARK: - Core Data stack
    
    var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "NotesApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    
    // MARK: - Initializers
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    
    // MARK: - Public Methods
    func create(_ title: String, _ subtitle: String, completion: (Note) -> Void) {
        let note = Note(context: viewContext)
        note.title = title
        note.subtitle = subtitle
        completion(note)
        saveContext()
    }
    
    func fetchData(completion: (Result<[Note], Error>) -> Void) {
        let fetchRequest = Note.fetchRequest()
        
        do {
            let notes = try viewContext.fetch(fetchRequest)
            completion(.success(notes))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func update(_ note: Note, _ title: String, _ subtitle: String) {
        note.title = title
        note.subtitle = subtitle
        saveContext()
    }
    
    func delete(_ note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    // MARK: - Core Data Saving support
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}


