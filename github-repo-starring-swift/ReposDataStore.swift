//
//  ReposDataStore.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class ReposDataStore {
    
    static let sharedInstance = ReposDataStore()
    fileprivate init() {}
    
    var repositories:[GithubRepository] = []
    
    func getRepositoriesWithCompletion(_ completion: @escaping () -> ()) {
        GithubAPIClient.getRepositoriesWithCompletion { (reposArray) in
            self.repositories.removeAll()
            for dictionary in reposArray {
                guard let repoDictionary = dictionary as? [String : Any] else { fatalError("Object in reposArray is of non-dictionary type") }
                let repository = GithubRepository(dictionary: repoDictionary)
                self.repositories.append(repository)
            }
            completion()
        }
    }
    
    func checkIfRepositoryIsStarred(fullName: String, completion: ()->()) {
        GithubAPIClient.checkIfRepositoryIsStarred(fullName) { (isStarred) in
            print("Closure is workeeeng! \(isStarred)")
        }
    }
    
    func toggleStarStatus(name: String, completion: @escaping (Bool)->()) {
        GithubAPIClient.checkIfRepositoryIsStarred(name) { (isStarred) in
            if isStarred == true {
                GithubAPIClient.unstarRepository(named: name, completion: { (success) in
                    completion(success)
                })
            } else if isStarred == false {
                GithubAPIClient.starRepository(named: name, completion: { (success) in
                    completion(success)
                })
            }
            }
        }
    }

