//
//  CollectionViewController.swift
//  WeightControl
//
//  Created by Елена Яновская on 26.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import CoreData
import UIKit

class CollectionViewController: UICollectionViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Мой вес"
        static let cellIdentifier = String(describing: WeightCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 8
        static let verticalEdge: CGFloat = 10
        static let cellSpacing: CGFloat = 10
        static let cellHeight: CGFloat = 64
    }
    
    // MARK: - Private Properties
    
    private var viewModels = [WeightViewModel]()
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        configureCollectionView()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "WeightEntity")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try? context.fetch(request)
            for data in result as! [NSManagedObject] {
                let weight = data.value(forKey: "weight") as! String
                let date = data.value(forKey: "date") as! Date
                let model = Weight(weight: weight, date: date)
                let viewModel = WeightViewModel(model: model)
                viewModels.insert(viewModel, at: 0)
            }
            collectionView?.reloadData()
        }
    }
    
    // MARK: - Private Methods

    private func configureCollectionView() {
        self.collectionView!.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView?.backgroundColor = PaletteColors.blue
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize.width = view.frame.width - LayoutConstants.leadingMargin
        flowLayout.itemSize.height = LayoutConstants.cellHeight
    }
    
    private func saveNewWeight(_ weight: String) {
        let model = Weight(weight: weight, date: Date())
        let viewModel = WeightViewModel(model: model)
        viewModels.insert(viewModel, at: 0)
        collectionView?.reloadData()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "WeightEntity", in: context)
        let newWeight = NSManagedObject(entity: entity!, insertInto: context)
        
        
        newWeight.setValue(model.weight, forKey: "weight")
        newWeight.setValue(model.date, forKey: "date")
        
        do {
            try? context.save()
            
        }
    }
    
    private func editWeigth(_ newWeight: String, index: Int) {
        viewModels[index].editWeight(with: newWeight)
        collectionView?.reloadData()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeightEntity")

        do {
            guard let results = try? context.fetch(fetchRequest) as! [NSManagedObject] else { return }
                results[viewModels.count-index-1].setValue(newWeight, forKey: "weight")
        }
        
        do {
            try? context.save()
        }
        
    }
    
    private func presentAddWeightAlert() {
        let alert = UIAlertController(title: "Ваш вес", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let text = alert.textFields![0].text, text != "" {
                self.saveNewWeight(text)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = "45.0"
            textField.font = UIFont.boldSystemFont(ofSize: 18)
            textField.textAlignment = .center
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentEditWeightAlert(index: Int) {
        let oldValue = viewModels[index].weight
        let alert = UIAlertController(title: "Ваш вес", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Сохранить", style: .default) { _ in
            if let text = alert.textFields![0].text, text != "", text != oldValue {
                self.editWeigth(text, index: index)
            }
        }
        alert.addTextField { textField in
            textField.text = oldValue
            textField.font = UIFont.boldSystemFont(ofSize: 18)
            textField.textAlignment = .center
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as? WeightCell else {
            return WeightCell()
        }
        cell.configure(for: viewModels[indexPath.row])
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        changeCell(row: indexPath.row)
    }
    
    private func changeCell(row: Int) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Изменить", style: .default) { _ in
            self.presentEditWeightAlert(index: row)
        }
        let deleteAction = UIAlertAction(title: "Удалить", style: .destructive) { _ in
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "WeightEntity")
            
            do {
                guard let results = try? context.fetch(fetchRequest) as! [NSManagedObject] else { return }
                context.delete(results[self.viewModels.count-row-1])
            }
            
            do {
                try? context.save()
            }
            self.viewModels.remove(at: row)
            self.collectionView?.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)

        alertController.addAction(editAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction private func addButtonTapped(_ sender: Any) {
        presentAddWeightAlert()
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: LayoutConstants.verticalEdge, left: 0, bottom: LayoutConstants.verticalEdge, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}
