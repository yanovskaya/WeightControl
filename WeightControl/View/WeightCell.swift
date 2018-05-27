//
//  WeightCell.swift
//  WeightControl
//
//  Created by Елена Яновская on 26.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class WeightCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    private enum LayoutConstants {
        static let cornerRadius: CGFloat = 12
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private var weightLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    // MARK: - Public Methods
    
    func configure(for viewModel: WeightViewModel) {
        weightLabel.text = viewModel.weigth
        dateLabel.text = viewModel.date
    }
    
    // MARK: - Private Methods

    private func configureView() {
        backgroundColor = UIColor.white.withAlphaComponent(0.9)
        layer.masksToBounds = true
        layer.cornerRadius = LayoutConstants.cornerRadius
    }
}
