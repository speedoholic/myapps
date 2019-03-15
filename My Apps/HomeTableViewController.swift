//
//  HomeTableViewController.swift
//  My Apps
//
//  Created by Kushal Ashok on 3/15/19.
//  Copyright © 2019 my. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {

    var myApps = [MyApp]()
    var selectedApp: MyApp?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addAppButtonTapped))
        var tradeXApp = MyApp()
        tradeXApp.bundleId = "com.tradexport.tradex"
        tradeXApp.name = "TRADE X GLOBAL"
        myApps.append(tradeXApp)
        tableView.register(AppTableViewCell.self, forCellReuseIdentifier: "AppTableViewCell")
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myApps.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppTableViewCell", for: indexPath) as? AppTableViewCell else {
            return UITableViewCell()
        }
        cell.textLabel?.text = myApps[indexPath.row].name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }


    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            myApps.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            let newApp = MyApp()
            myApps.append(newApp)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */


    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedApp = myApps[indexPath.row]
        self.performSegue(withIdentifier: "appDetailsSegue", sender: self)
    }

    
    // MARK: - Navigation

    @objc func addAppButtonTapped() {
        self.performSegue(withIdentifier: "addAppSegue", sender: self)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let appDetailsController = segue.destination as? AppDetailsViewController {
            appDetailsController.app = selectedApp
        } else if let addAppController = segue.destination as? AddAppViewController {
            addAppController.addAppDelegate = self
        }
    }
    

}

extension HomeTableViewController: AddAppDelegate {
    func addApp(_ newApp: MyApp) {
        myApps.append(newApp)
        tableView.reloadData()
    }
}
