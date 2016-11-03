//
//  ReposTableViewController.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit

class ReposTableViewController: UITableViewController {
    
    let store = ReposDataStore.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.accessibilityLabel = "tableView"
        self.tableView.accessibilityIdentifier = "tableView"
        
        
        store.getRepositoriesWithCompletion {
            OperationQueue.main.addOperation({ 
                self.tableView.reloadData()
            })
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.repositories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoTableViewCell

        let repository:GithubRepository = self.store.repositories[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = repository.fullName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        store.toggleStarStatus(name: String(describing: self.store.repositories[indexPath.row].fullName)) {
            (isStarred) in
            
            let message: String
            switch isStarred {
            case true:
                message = "You just starred \(self.store.repositories[indexPath.row].fullName)"
            case false:
                message = "You just unstarred \(self.store.repositories[indexPath.row].fullName)"
            }
            
            
            let alertController = UIAlertController(title: self.accessibilityLabel, message: message, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in })
            if isStarred == true {
                alertController.accessibilityLabel = "Starred Repository"
                alertController.title = self.accessibilityLabel
            } else if isStarred ==  false {
                alertController.accessibilityLabel = "Unstarred Repository"
                alertController.title = self.accessibilityLabel
            }
            alertController.addAction(OKAction)
            
            
            self.present(alertController, animated: true)
        }
    }

}
