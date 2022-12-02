//
//  BTActivityIndicatorView.swift
//  Botanista
//
//  Created by Lucinda Flores on 17/11/2022.
//

import UIKit

class BTActivityIndicatorView: UIView {

    let loadingMessageLabel = UILabel()
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(text: String) {
        super.init(frame: .zero)
        loadingMessageLabel.text = text
        configure()
    }
    
    
    private func configure() {
        activityIndicator.color = #colorLiteral(red: 0.175999999, green: 0.6470000148, blue: 0.4670000076, alpha: 1)
        activityIndicator.transform = CGAffineTransform(scaleX: 2.5, y: 2.5) //makes activityIndicator bigger
        
        loadingMessageLabel.text = loadingMessageText
        loadingMessageLabel.font = UIFont.systemFont(ofSize: 18.0, weight: .medium)
        loadingMessageLabel.textAlignment = .center
        loadingMessageLabel.numberOfLines = 2
        loadingMessageLabel.lineBreakMode = .byWordWrapping
        
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(loadingMessageLabel)
        self.addSubview(activityIndicator)
        
        
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -70.0),
            activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            
            loadingMessageLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 60.0),
            loadingMessageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }

    
}
