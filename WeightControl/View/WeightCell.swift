//
//  WeightCell.swift
//  WeightControl
//
//  Created by Елена Яновская on 26.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import UIKit

class WeightCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var view: UIView!
    
    // MARK: - View lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }

}
