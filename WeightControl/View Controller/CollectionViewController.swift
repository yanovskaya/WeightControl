//
//  CollectionViewController.swift
//  WeightControl
//
//  Created by Елена Яновская on 26.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    // MARK: - Constants
    
    private enum Constants {
        static let title = "Мой вес"
        static let alertTitle = "Ваш вес"
        static let saveAction = "Сохранить"
        static let editAction = "Изменить"
        static let deleteAction = "Удалить"
        static let cancelAction = "Отмена"
        static let defaultText = "45.0"
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
    private let coreData = CoreDataWrapper()
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        configureCollectionView()
    }
    
    // MARK: - Private Methods

    private func configureCollectionView() {
        self.collectionView!.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        collectionView?.backgroundColor = PaletteColors.blue
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize.width = view.frame.width - LayoutConstants.leadingMargin
        flowLayout.itemSize.height = LayoutConstants.cellHeight
        
        viewModels = coreData.fetchWeightViewModels()
        collectionView?.reloadData()
    }
    
    private func saveNewWeight(_ weight: String) {
        let date = Date()
        let model = Weight(weight: weight, date: date)
        let viewModel = WeightViewModel(model: model)
        viewModels.insert(viewModel, at: 0)
        collectionView?.reloadData()
        
        coreData.storeNewWeight(weight, date: date)
    }
    
    private func editWeigth(_ newWeight: String, index: Int) {
        viewModels[index].editWeight(with: newWeight)
        collectionView?.reloadData()
        
        let coreDataIndex = viewModels.count - index - 1
        coreData.updateWeigth(newWeight, index: coreDataIndex)
    }
    
    private func deleteWeight(index: Int) {
        viewModels.remove(at: index)
        collectionView?.reloadData()
        
        let coreDataIndex = viewModels.count - index
        coreData.removeWeight(at: coreDataIndex)
    }
    
    private func presentAddWeightAlert() {
        let alert = UIAlertController(title: Constants.alertTitle, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: Constants.saveAction, style: .default) { _ in
            if let text = alert.textFields![0].text, text != "" {
                self.saveNewWeight(text)
            }
        }
        alert.addTextField { textField in
            textField.placeholder = Constants.defaultText
            textField.font = UIFont.boldSystemFont(ofSize: 18)
            textField.textAlignment = .center
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func presentEditWeightAlert(index: Int) {
        let oldValue = viewModels[index].weight
        let alert = UIAlertController(title: Constants.alertTitle, message: "", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: Constants.saveAction, style: .default) { _ in
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
        let editAction = UIAlertAction(title: Constants.editAction, style: .default) { _ in
            self.presentEditWeightAlert(index: row)
        }
        let deleteAction = UIAlertAction(title: Constants.deleteAction, style: .destructive) { _ in
            self.deleteWeight(index: row)
        }
        let cancelAction = UIAlertAction(title: Constants.cancelAction, style: .cancel)

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
