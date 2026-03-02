//
//  GitHubGetters.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/14/26.
//

import Foundation

extension WatcherManager {
    mutating func getGitHubUser(_ manager: WatcherManager) async throws {
        let url = URL(string: "https://api.github.com/users/\(manager.credentials.username)")!
        var request = URLRequest(url: url)
        request.setValue("token \(manager.credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("GitHub API error: unable to retrieve user data")
        }

        let ghUser: GitHubUser = try JSONDecoder.githubDecoder().decode(GitHubUser.self, from: data)
        self.ghUser = ghUser
    }
    
    mutating func getRepos(_ manager: WatcherManager) async throws {
        guard let userRepo = manager.ghUser?.reposURL
        else {
            fatalError("No user repos")
        }
        
        let url = URL(string: "\(userRepo)")!
        var request = URLRequest(url: url)
        request.setValue("token \(manager.credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("GitHub API error: unable to retrieve user repos")
        }

        let repos = try JSONDecoder.githubDecoder().decode([Repository].self, from: data)
        self.repos = repos
        print("Fetched \(repos.count) repos")
    }
    
    /// Fetch pull requests across all repositories and keep only those authored by the watcher user.
    mutating func getMyPullRequests(_ manager: WatcherManager) async throws {
        guard let login = manager.ghUser?.login else {
            throw URLError(.userAuthenticationRequired)
        }

        // Ensure we have repositories to query.
        if repos.isEmpty {
            try await getRepos(manager)
        }

        var collected: [PullRequest] = []

        for repo in repos {
            // Build the pulls API URL: GET /repos/{owner}/{repo}/pulls
            // Use the base repo.url and append "/pulls" if needed
            let pullsURL = repo.url.appendingPathComponent("pulls")
            var request = URLRequest(url: pullsURL)
            request.setValue("token \(manager.credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                // Skip this repo on error, continue to next
                continue
            }

            // Decode list of PRs for this repo
            var prs = try JSONDecoder.githubDecoder().decode([PullRequest].self, from: data)
            // Annotate with repo full name for context
            for pr in prs.indices {
                prs[pr].repositoryFullName = repo.fullName
            }
            // Filter to PRs authored by the watcher (login)
            prs = prs.filter { $0.user.login.caseInsensitiveCompare(login) == .orderedSame }
            collected.append(contentsOf: prs)
        }

        self.myPullRequests = collected
        print("Found \(collected.count) pull requests authored by \(login)")
    }
}
