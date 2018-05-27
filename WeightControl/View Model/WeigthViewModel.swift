//
//  WeigthViewModel.swift
//  WeightControl
//
//  Created by Елена Яновская on 27.05.2018.
//  Copyright © 2018 Elena Yanovskaya. All rights reserved.
//

import Foundation

class WeightViewModel {
    
    // MARK: - Public Properties
    
    let date: String
    let weigth: String
    
    // MARK: - Initialization
    
    init(model: Weight) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        date = formatter.string(from: model.date)
        weigth = model.weight
    }
}
