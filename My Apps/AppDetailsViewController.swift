//
//  AppDetailsViewController.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit
import AlamofireImage

class AppDetailsViewController: UIViewController {
    
    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var appBasicDetailsStackView: UIStackView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var bundleIdLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var releaseNotesLabel: UILabel!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var app: MyApp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //We must have the app details
        guard let _ = app else {
            self.navigationController?.popViewController(animated: false)
            return
        }
        updateUI()
        getAppDetails()
    }
    
    func updateUI() {
        appNameLabel.text = app?.trackName ?? ""
        bundleIdLabel.text = app?.bundleId ?? ""
        sellerNameLabel.text = app?.sellerName ?? ""
        versionLabel.text = app?.version ?? ""
        releaseNotesLabel.text = app?.releaseNotes ?? ""
        appDescriptionLabel.text = app?.appDescription ?? ""
        genreLabel.text = app?.primaryGenreName ?? ""
        releaseDateLabel.text = app?.releaseDate ?? ""
        guard let urlString = app?.artworkUrl512, let imageUrl = URL(string: urlString) else {return}
        appImageView.af_setImage(withURL: imageUrl)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        getAppDetails()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AppDetailsViewController: Requestable {
    
    func getAppDetails() {
        guard let bundleId = app?.bundleId else {return}
        Service.shared.getAppDetails(bundleId, mapType: MyAppResponse.self) { [unowned self]  (appResponse) in
            self.app = appResponse.results.first
            self.updateUI()
        }
    }
}



