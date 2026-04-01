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
    
    private func displayMessage(for watchManager: WatcherManager) -> (topLine: String, bottomLine: String) {
        let reviewRequestedPullRequests = watchManager.reviewRequestedPullRequests.filter { $0.state.lowercased() == "open" }
        let openPullRequests = watchManager.myPullRequests.filter { $0.state.lowercased() == "open" }

        if let reviewRequestedPullRequest = reviewRequestedPullRequests.max(by: { left, right in
            left.updatedAt < right.updatedAt
        }) {
            let repoName = reviewRequestedPullRequest.repositoryFullName?.components(separatedBy: "/").last ?? "Unknown Repo"
            return ("Review Requested", String(repoName.prefix(16)))
        }

        if let draftPullRequest = openPullRequests.first(where: { $0.draft == true }) {
            let repoName = draftPullRequest.repositoryFullName?.components(separatedBy: "/").last ?? "Unknown Repo"
            return ("Draft PR Active", String(repoName.prefix(16)))
        }

        if let mostRecentlyUpdatedPullRequest = openPullRequests.max(by: { left, right in
            left.updatedAt < right.updatedAt
        }) {
            let repoName = mostRecentlyUpdatedPullRequest.repositoryFullName?.components(separatedBy: "/").last ?? "Unknown Repo"
            return ("Open PRs: \(openPullRequests.count)", String(repoName.prefix(16)))
        }

        return ("No Open PRs", "Nothing pending")
    }
    
    func run() async throws {
        
        // MARK: Initialize the Watcher's Manager for the session
        let sessionCredentials = Credentials(username: username, password: password, ghAuthToken: ghAuthToken, name: name, email: email)
        var watchManager = WatcherManager(credentials: sessionCredentials)
        
        let runCount = watchTimeout * 60 / wait
        let serialConnection = try ArduinoSerialConnection(portPath: "/dev/cu.usbserial-210")
        var lastDisplayedMessage: (topLine: String, bottomLine: String)?
        
        // Here
        print("Here is my username: \(username)")
        print("Here is my name: \(name)")
        print("Here is my email: \(email)")
        print("Here is my wait: \(wait)")
        print("Here is my watchTimeout: \(watchTimeout)")
        for index in 0..<runCount {
            do {
                try await watchManager.getGitHubUser(watchManager)
                try await watchManager.getMyPullRequests(watchManager)
                try await watchManager.getReviewRequestedPullRequests(watchManager)

                let nextMessage = displayMessage(for: watchManager)

                print("Completed GitHub poll cycle \(index + 1)")
                print("My PR count: \(watchManager.myPullRequests.count)")
                print("Review requested count: \(watchManager.reviewRequestedPullRequests.count)")
                let openPRCount = watchManager.myPullRequests.filter { $0.state.lowercased() == "open" }.count
                print("Open PR count: \(openPRCount)")

                if lastDisplayedMessage?.topLine != nextMessage.topLine || lastDisplayedMessage?.bottomLine != nextMessage.bottomLine {
                    try serialConnection.send(
                        topLine: nextMessage.topLine,
                        bottomLine: nextMessage.bottomLine
                    )
                    lastDisplayedMessage = nextMessage
                    print("Updated Arduino display")
                } else {
                    print("Display unchanged")
                }

                sleep(UInt32(60 * wait))
                // The process will by default poll every 5 minutes and then stop after 8 hours if not killed manually.
            } catch {
                print("Failed during poll cycle \(index + 1): \(error)")

                do {
                    try serialConnection.send(
                        topLine: "Watcher Error",
                        bottomLine: "See terminal"
                    )
                    lastDisplayedMessage = ("Watcher Error", "See terminal")
                } catch {
                    print("Failed to send error state to Arduino: \(error)")
                }

                sleep(UInt32(60 * wait))
            }
        }
    }
}
