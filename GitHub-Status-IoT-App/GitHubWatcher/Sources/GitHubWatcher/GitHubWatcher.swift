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
    
    @Argument(help: "Your GitHub username.")
    var username: String

    // Devyn: Needs review before deleting
    // @Argument
    // var password: String

    @Argument(help: "A GitHub personal access token with repo scope.")
    var ghAuthToken: String

    // Devyn: Needs review before deleting
    // @Argument
    // var name: String

    // Devyn: Needs review before deleting
    // @Argument
    // var email: String

    @Option(help: "Time in minutes between poll cycles.")
    var wait: Int = 5

    @Option(help: "Total session duration in hours before auto-terminating.")
    var watchTimeout: Int = 8

    @Option(help: "Serial port path for the Arduino connection.")
    var port: String = "/dev/cu.usbserial-210"
    
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
        let sessionCredentials = Credentials(username: username, ghAuthToken: ghAuthToken)
        var watchManager = WatcherManager(credentials: sessionCredentials)

        let runCount = watchTimeout * 60 / wait
        let serialConnection = try ArduinoSerialConnection(portPath: port)
        var lastDisplayedMessage: (topLine: String, bottomLine: String)?

        // Fetch user profile and repos once at startup — these don't change during a session.
        try await watchManager.getGitHubUser()
        try await watchManager.getRepos()

        for index in 0..<runCount {
            do {
                // Reset PR data each cycle to avoid stale accumulation.
                watchManager.myPullRequests = []
                watchManager.reviewRequestedPullRequests = []

                try await watchManager.getMyPullRequests()
                try await watchManager.getReviewRequestedPullRequests()

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

                try await Task.sleep(for: .seconds(60 * wait))
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

                try await Task.sleep(for: .seconds(60 * wait))
            }
        }
    }
}
