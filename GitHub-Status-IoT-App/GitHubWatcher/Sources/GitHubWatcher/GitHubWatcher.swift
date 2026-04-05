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

                let messages = watchManager.displayMessages()

                print("Completed GitHub poll cycle \(index + 1)")
                print("My PR count: \(watchManager.myPullRequests.count)")
                print("Review requested count: \(watchManager.reviewRequestedPullRequests.count)")
                let openPRCount = watchManager.myPullRequests.filter { $0.state.lowercased() == "open" }.count
                print("Open PR count: \(openPRCount)")
                print("Display messages: \(messages.count) repo(s)")

                // Cycle through per-repo messages, showing each for 10 seconds.
                for message in messages {
                    if lastDisplayedMessage?.topLine != message.topLine || lastDisplayedMessage?.bottomLine != message.bottomLine {
                        try serialConnection.send(
                            topLine: message.topLine,
                            bottomLine: message.bottomLine
                        )
                        lastDisplayedMessage = message
                        print("  -> \(message.topLine) | \(message.bottomLine)")
                    }
                    try await Task.sleep(for: .seconds(5))
                }

                // Wait the remainder of the poll interval.
                let displayTime = messages.count * 10
                let remainingSeconds = (60 * wait) - displayTime
                if remainingSeconds > 0 {
                    try await Task.sleep(for: .seconds(remainingSeconds))
                }
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
