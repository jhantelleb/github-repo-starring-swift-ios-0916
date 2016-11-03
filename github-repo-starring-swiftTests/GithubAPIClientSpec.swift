//
//  GithubAPIClientSpec.swift
//  github-repo-starring-swift
//
//  Created by Haaris Muneer on 7/26/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import Quick
import Nimble
import OHHTTPStubs

@testable import github_repo_starring_swift
class GithubAPIClientSpec: QuickSpec {
    
    var starred = false
    
    override func spec() {
        
        guard let path = Bundle(for: type(of: self)).path(forResource: "repositories", ofType: "json") else { print("error getting the path"); return }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { print("error getting data"); return }
        let repositoryArray = try? JSONSerialization.jsonObject(with: data, options: []) as! NSArray
        
        //stubbing GET repositories
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            return(request.url?.host == "api.github.com" && request.url?.path == "/repositories")
            
        }) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(fileAtPath: OHPathForFileInBundle("repositories.json", Bundle(for: type(of: self)))!, statusCode: 200, headers: ["Content-Type" : "application/json"])
        }
        
        //stubbing GET star status
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            return(request.url?.host == "api.github.com" && request.url?.path == "/user/starred/wycats/merb-core")
            
        }) { (request) -> OHHTTPStubsResponse in
            if self.starred == true {
                return OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: nil)
            }
            else {
                return OHHTTPStubsResponse(fileAtPath: OHPathForFileInBundle("not_starred.json", Bundle(for: type(of: self)))!, statusCode: 404, headers: ["Content-Type" : "application/json"])
            }
            
        }
        
        //stubbing PUT/DELETE star
        OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
            let urlCheck = (request.url?.host == "api.github.com" && request.url?.path == "/user/starred/wycats/merb-core")
            let httpMethodCheck = (request.httpMethod == "PUT" || request.httpMethod == "DELETE")
            return urlCheck && httpMethodCheck
            
        }) { (request) -> OHHTTPStubsResponse in
            return OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: nil)
        }
        
        describe("getRepositories") {
            it("should get the proper repositories from Github") {
                waitUntil(action: { (done) in
                    GithubAPIClient.getRepositoriesWithCompletion({ (repos) in
                        
                        expect(repos).toNot(beNil())
                        expect(repos.count).to(equal(2))
//                        expect(repos).to(equal(repositoryArray! as? [Any]))
                        done()
                        
                    })
                })
            }
        }
        
        describe("checkIfRepositoryIsStarred") {
            it("should respond false if the given repo is not starred") {
                OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                    return(request.url?.host == "api.github.com" && request.url?.path == "/user/starred/wycats/merb-core")
                    
                }) { (request) -> OHHTTPStubsResponse in
                    return OHHTTPStubsResponse(fileAtPath: OHPathForFileInBundle("not_starred.json", Bundle(for: type(of: self)))!, statusCode: 404, headers: ["Content-Type" : "application/json"])

                }
                waitUntil(action: { (done) in
                    GithubAPIClient.checkIfRepositoryIsStarred("wycats/merb-core", completion: { (starred) in
                        expect(starred).to(beFalsy())
                        done()
                    })
                })
            }
            
            it("should respond true if the given repo is starred") {
                OHHTTPStubs.stubRequests(passingTest: { (request) -> Bool in
                    return(request.url?.host == "api.github.com" && request.url?.path == "/user/starred/wycats/merb-core")
                    
                }) { (request) -> OHHTTPStubsResponse in
                    return OHHTTPStubsResponse(data: Data(), statusCode: 204, headers: nil)
                    
                }
                waitUntil(action: { (done) in
                    GithubAPIClient.checkIfRepositoryIsStarred("wycats/merb-core", completion: { (starred) in
                        expect(starred).to(beTruthy())
                        done()
                    })
                })
            }
        }
        
            
            
        
        
    }
}
