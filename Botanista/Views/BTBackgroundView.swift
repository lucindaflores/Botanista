//
//  BTBackgroundView.swift
//  Botanista
//
//  Created by Lucinda Flores on 17/11/2022.
//

import UIKit

class BTBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure() {
        layer.backgroundColor = UIColor.systemBackground.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }

    
}
