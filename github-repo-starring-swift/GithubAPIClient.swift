//
//  GithubAPIClient.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 6/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Alamofire

class GithubAPIClient {
    
    class func getRepositoriesWithCompletion(_ completion: @escaping ([Any]) -> ()) {
        
        let githubAPIURL = Secrets.githubURL
        let githubClientID = Secrets.clientID
        let githubClientSecret = Secrets.clientSecret
        
        let urlString = "\(githubAPIURL)/repositories?client_id=\(githubClientID)&client_secret=\(githubClientSecret)"
        
        let url = URL(string: urlString)
        let session = URLSession.shared
        
        guard let unwrappedURL = url else { fatalError("Invalid URL") }
        let task = session.dataTask(with: unwrappedURL, completionHandler: { (data, response, error) in
            guard let data = data else { fatalError("Unable to get data \(error?.localizedDescription)") }
            
            if let responseArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [Any] {
                if let responseArray = responseArray {
                    completion(responseArray)
                }
            }
        })
        task.resume()
    }
    
    
    class func checkIfRepositoryIsStarred(_ fullName: String, completion: @escaping (Bool)->Void) {
        //Check if repo is currently starred
        let urlString = "\(Secrets.githubURL)/user/starred/\(fullName)\(Secrets.accessToken)"
        
        let url = URL(string: urlString)
        guard let unwrappedURL =  url else { return }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: unwrappedURL) { (data, response, error) in
            let httpResponse = response as! HTTPURLResponse
            
            if httpResponse.statusCode == 204 {
                completion(true)
            } else if httpResponse.statusCode == 404 {
                completion(false)
            }
        }
        task.resume()
    }
    
    
    //for starring  - in the data task area, add a request and a header value. ->
    //create the toggle  in the data store since you're not making a new request
    class func starRepository(named: String, completion: @escaping (Bool)->()) {
        let urlString = "\(Secrets.githubURL)/user/starred/\(named)\(Secrets.accessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return }
        
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "PUT"
        request.addValue("0", forHTTPHeaderField: "Content-Length") //from github documentation
        
        Alamofire.request(request).responseJSON{ response in
            guard let unwrappedResponse = response.response else { return }
            if unwrappedResponse.statusCode == 204 {
                completion(true)
            } else if unwrappedResponse.statusCode == 404 {
                completion(false)
            }
        }
        
    }
    
    class func unstarRepository(named: String, completion: @escaping (Bool)->()) {
        let urlString = "\(Secrets.githubURL)/user/starred/\(named)\(Secrets.accessToken)"
        let url = URL(string: urlString)
        guard let unwrappedURL = url else { return }
        
        var request = URLRequest(url: unwrappedURL)
        request.httpMethod = "DELETE"
        
        Alamofire.request(request).responseJSON{ response in
            guard let unwrappedResponse = response.response else { return }
            if unwrappedResponse.statusCode == 204 {
                completion(false)
            } else if unwrappedResponse.statusCode == 404 {
                completion(true)
            }
        }

    }
    
    
}

