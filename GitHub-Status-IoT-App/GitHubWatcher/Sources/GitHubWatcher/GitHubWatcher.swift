//
//  GitHubWatcher.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/14/26.
//

import Foundation
import ArgumentParser

@main
struct GitHubWatcher: AsyncParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Command for launching the GitHub Watcher."
    )
    
    @Argument
    var username: String
    
    @Argument
    var password: String
    
    @Argument
    var ghAuthToken: String
    
    @Argument
    var name: String
    
    @Argument
    var email: String
    
    @Option(help: "Enter time in minutes to wait before checking for new commits.")
    var wait: Int = 5
    
    @Option(help: "Enter time in hours to wait before terminating the program.")
    var watchTimeout: Int = 8
    
    func run() async throws {
        
        // MARK: Initialize the Watcher's Manager for the session
        let sessionCredentials = Credentials(username: username, password: password, ghAuthToken: ghAuthToken, name: name, email: email)
        var watchManager = WatcherManager(credentials: sessionCredentials)
        // Here
        print("Here is my username: \(username)")
        print("Here is my name: \(name)")
        print("Here is my email: \(email)")
        print("Here is my wait: \(wait)")
        print("Here is my watchTimeout: \(watchTimeout)")
        
        do {
            // MARK: Testing Block
            watchManager.ghUser = try await watchManager.getGitHubUser(watchManager)
            print(watchManager.ghUser?.reposURL)
//            guard let repos = watchManager.ghUser?.publicRepos else {
//                fatalError("Error: User is not associated with any repositories.")
//            }
            // MARK: End Testing Block
            
            // Check the current auth status
            
            // If Auth is logged out, Authenticate Command
            
            // MARK: Watcher Loop
            
            
            
            
            // Here's what I'm thinking:
            // Check the auth status:
            // Auth'd means ignore the authorization command and run the loop
            // No-Auth means run the authorization command then the loop
            //
            // The process will by default poll every 5 minutes and then stop after 8 hours if not killed manually.
        } catch {
            fatalError("We Died!")
        }
    }
}
