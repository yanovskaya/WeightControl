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
        static let cellIdentifier = String(describing: WeightCell.self)
    }
    
    private enum LayoutConstants {
        static let leadingMargin: CGFloat = 8
        static let topEdge: CGFloat = 10
        static let bottomEdge: CGFloat = 15
        static let cellSpacing: CGFloat = 5
        static let cellHeight: CGFloat = 64
    }
    
    // MARK: - Private Properties
    
    private let viewModels = [WeightViewModel]()
    
    // MARK: - ViewController lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.title
        configureCollectionView()
    }
    
    // MARK: - Private Methods

    private func configureCollectionView() {
        self.collectionView!.register(UINib(nibName: Constants.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: Constants.cellIdentifier)
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.itemSize.width = view.frame.width - LayoutConstants.leadingMargin
        flowLayout.itemSize.height = LayoutConstants.cellHeight
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath)
        return cell
    }

}

// MARK: - UICollectionViewDelegateFlowLayout

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: LayoutConstants.topEdge, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 0, left: 0, bottom: LayoutConstants.bottomEdge, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return LayoutConstants.cellSpacing
    }
}
