//
//  AppDetailsViewController.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit

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
        getAppData()
    }
    
    func updateUI() {
        appNameLabel.text = app?.name ?? ""
        bundleIdLabel.text = app?.bundleId ?? ""
        sellerNameLabel.text = app?.sellerName ?? ""
        versionLabel.text = app?.version ?? ""
        releaseNotesLabel.text = app?.releaseNotes ?? ""
        appDescriptionLabel.text = app?.description ?? ""
        genreLabel.text = app?.genre ?? ""
        releaseDateLabel.text = app?.releaseDateString ?? ""
    }
    
    
    func getAppData() {
        guard let bundleId = app?.bundleId else {return}
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(bundleId)") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                if let jsonDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] {
                    guard let results = jsonDictionary["results"] as? [Any], !results.isEmpty else {return}
                    guard let appDetails = results.first as? [String: Any] else {return}
                    self.updateAppDetails(appDetails)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Image Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Image Download Finished")
            DispatchQueue.main.async() {
                self.appImageView.image = UIImage(data: data)
            }
        }
    }
    
    func updateAppDetails(_ appDetails: [String: Any]) {
        guard let appName = appDetails["trackName"] as? String,
            let bundleId = appDetails["bundleId"] as? String,
            let sellerName = appDetails["sellerName"] as? String,
            let version = appDetails["version"] as? String,
            let releaseNotes = appDetails["releaseNotes"] as? String,
            let description = appDetails["description"] as? String,
            let primaryGenre = appDetails["primaryGenreName"] as? String,
            let releaseDateString = appDetails["releaseDate"] as? String else {return}
        
        app?.name = appName
        app?.bundleId = bundleId
        app?.sellerName = sellerName
        app?.version = version
        app?.releaseNotes = releaseNotes
        app?.appdDescription = description
        app?.genre = primaryGenre
        app?.releaseDateString = releaseDateString
        updateUI()
        
        guard let artworkUrl512 = appDetails["artworkUrl512"] as? String,
            let imageUrl = URL(string: artworkUrl512) else {return}
        downloadImage(from: imageUrl)
    }
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        getAppData()
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



