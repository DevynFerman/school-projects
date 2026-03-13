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
        
        let runCount = watchTimeout * 60 / wait
        
        // Here
        print("Here is my username: \(username)")
        print("Here is my name: \(name)")
        print("Here is my email: \(email)")
        print("Here is my wait: \(wait)")
        print("Here is my watchTimeout: \(watchTimeout)")
        for _ in 0..<runCount {
            do {
                // MARK: Testing Block
                try await watchManager.getGitHubUser(watchManager)
                try await watchManager.getRepos(watchManager)
                
                // Now available:
                print(watchManager.ghUser?.login ?? "No user")
                print("Repo count: \(watchManager.repos.count)")
                for repo in watchManager.repos {
                    print(repo.name)
                }
                
                // Fetch and print pull requests authored by the watcher
                try await watchManager.getMyPullRequests(watchManager)
                print("My PRs for \(String(describing: watchManager.ghUser?.login))")
                print("Total: \(watchManager.myPullRequests.count)")
                for pr in watchManager.myPullRequests {
                    let repoName = pr.repositoryFullName ?? "unknown repo"
                    print("#\(pr.number) [\(pr.state.uppercased())] \(pr.title) — \(repoName)")
                }
                sleep(UInt32(60 * wait))
                // MARK: End Testing Block
                
                // The process will by default poll every 5 minutes and then stop after 8 hours if not killed manually.
            } catch {
                fatalError("We Died!")
            }
        }
    }
}

