//
//  FlowerInfoViewController.swift
//  Botanista
//
//  Created by Lucinda Flores on 12/10/2022.
//

import UIKit
import SafariServices

class FlowerInfoViewController: UIViewController {
    
    var networkManager = NetworkManager()
    
    var newCameraImage: UIImage!
    var pageId = valueNA
    
    var backgroundView = BTBackgroundView()
    var activityIndicatorView = BTActivityIndicatorView(text: loadingMessageText)
    
    @IBOutlet var backToMainButton: UIButton!
    @IBOutlet var flowerTitleLabel: UILabel!
    @IBOutlet var flowerImage: UIImageView!
    @IBOutlet var flowerExtractLabel: UILabel!
    @IBOutlet var openWikipediaButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        networkManager.delegate = self
    
        loadsActivityIndicator()
        flowerImage.image = newCameraImage
        
        networkManager.startRequest(with: newCameraImage)
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func openWikiButtonTapped(_ sender: UIButton) {
        guard let wikiPageUrl = URL(string: wikiURLSearch.pageURL + pageId) else {
            didFailWithError(error: BtErrors.invalidResponseServer)
            return
        }
        
        let safariVC = SFSafariViewController(url: wikiPageUrl)
        safariVC.preferredControlTintColor = .tintColor
        
        present(safariVC, animated: true)
        
    }
    
    
    func loadsActivityIndicator() {
        backgroundView = BTBackgroundView(frame: view.bounds)
        activityIndicatorView = BTActivityIndicatorView(frame: view.bounds)
        
        view.addSubview(backgroundView)
        view.addSubview(activityIndicatorView)
        
        activityIndicatorView.activityIndicator.startAnimating()
    }
    
    func dismissActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicatorView.removeFromSuperview()
            self.backgroundView.removeFromSuperview()
        }
    }

    
}


// MARK: - Network call
extension FlowerInfoViewController: NetworkManagerDelegate {
    func populateWikiInfo(wikiInfo: WikiModel) {
        dismissActivityIndicator()
       
        self.flowerTitleLabel.text = wikiInfo.title
        self.flowerExtractLabel.text = wikiInfo.extract
        self.pageId = wikiInfo.pageid!
    }
    
    func didFailWithError(error: BtErrors) {
        backgroundView = BTBackgroundView(frame: view.bounds)
        view.addSubview(backgroundView)

        let alert = UIAlertController(title: "An error ocurred" , message: error.rawValue, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
}
