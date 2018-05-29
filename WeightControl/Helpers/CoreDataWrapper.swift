//
//  CoreDataWrapper.swift
//  WeightControl
//
//  Created by Елена Яновская on 29.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import CoreData

class CoreDataWrapper {
    
    // MARK: - Constants
    
    private enum Constants {
        static let container = "Weight"
        static let entity = "WeightEntity"
    }
    
    private enum Keys {
        static let weight = "weight"
        static let date = "date"
    }
    
    // MARK: - Core Data stack
    
    lazy private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: Constants.container)
        container.loadPersistentStores { _, _  in }
        return container
    }()
    
    lazy private var context: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    private var objects: [NSManagedObject]? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entity)
        if let objects = try? context.fetch(request) as? [NSManagedObject] {
            return objects
        } else {
            return nil
        }
    }
    
    lazy private var entity: NSEntityDescription? = {
        return NSEntityDescription.entity(forEntityName: Constants.entity, in: context)
    }()
    
    // MARK: - Public Methods
    
    func fetchWeightViewModels() -> [WeightViewModel] {
        var viewModels = [WeightViewModel]()
        do {
            guard let objects = objects else {
                let emptyArray = [WeightViewModel]()
                return emptyArray
            }
            for object in objects {
                guard let weight = object.value(forKey: Keys.weight) as? String,
                    let date = object.value(forKey: Keys.date) as? Date else { return viewModels }
                let model = Weight(weight: weight, date: date)
                let viewModel = WeightViewModel(model: model)
                viewModels.insert(viewModel, at: 0)
            }
        }
        return viewModels
    }
    
    func storeNewWeight(_ weight: String, date: Date) {
        guard let entity = entity else { return }
        let newWeight = NSManagedObject(entity: entity, insertInto: context)
        
        newWeight.setValue(weight, forKey: Keys.weight)
        newWeight.setValue(date, forKey: Keys.date)
        saveContext()
    }
    
    func updateWeigth(_ newWeight: String, index: Int) {
        do {
            guard let objects = objects else { return }
            objects[index].setValue(newWeight, forKey: Keys.weight)
        }
        saveContext()
    }
    
    func removeWeight(at index: Int) {
        print(index)
        guard let objects = objects else { return }
        do {
            context.delete(objects[index])
        }
        saveContext ()
    }
    
    // MARK: - Core Data Saving support
    
    private func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try? context.save()
            }
        }
    }
    
}
