//
//  GitHubGetters.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/14/26.
//

import Foundation

extension WatcherManager {
    mutating func getGitHubUser() async throws {
        let url = URL(string: "https://api.github.com/users/\(credentials.username)")!
        var request = URLRequest(url: url)
        request.setValue("token \(credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: [
                NSLocalizedDescriptionKey: "GitHub API error: unable to retrieve user data"
            ])
        }

        self.ghUser = try JSONDecoder.githubDecoder().decode(GitHubUser.self, from: data)
    }

    mutating func getRepos() async throws {
        guard let reposURL = ghUser?.reposURL else {
            throw URLError(.userAuthenticationRequired, userInfo: [
                NSLocalizedDescriptionKey: "No GitHub user loaded — cannot fetch repos"
            ])
        }

        var request = URLRequest(url: reposURL)
        request.setValue("token \(credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: [
                NSLocalizedDescriptionKey: "GitHub API error: unable to retrieve user repos"
            ])
        }

        let repos = try JSONDecoder.githubDecoder().decode([Repository].self, from: data)
        self.repos = repos
        print("Fetched \(repos.count) repos")
    }

    /// Fetch pull requests across all repositories and keep only those authored by the watcher user.
    mutating func getMyPullRequests() async throws {
        guard let login = ghUser?.login else {
            throw URLError(.userAuthenticationRequired)
        }

        // Ensure we have repositories to query.
        if repos.isEmpty {
            try await getRepos()
        }

        var collected: [PullRequest] = []

        for repo in repos {
            let pullsURL = repo.url.appendingPathComponent("pulls")
            var request = URLRequest(url: pullsURL)
            request.setValue("token \(credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                continue
            }

            var prs = try JSONDecoder.githubDecoder().decode([PullRequest].self, from: data)
            for pr in prs.indices {
                prs[pr].repositoryFullName = repo.fullName
            }
            prs = prs.filter { $0.user.login.caseInsensitiveCompare(login) == .orderedSame }
            collected.append(contentsOf: prs)
        }

        self.myPullRequests = collected
        print("Found \(collected.count) pull requests authored by \(login)")
    }

    /// Fetch open pull requests where the watcher's review has been requested via GitHub Search API.
    mutating func getReviewRequestedPullRequests() async throws {
        guard let login = ghUser?.login else {
            throw URLError(.userAuthenticationRequired, userInfo: [
                NSLocalizedDescriptionKey: "No GitHub user loaded — cannot fetch review requests"
            ])
        }

        let query = "is:pr is:open review-requested:\(login)"
        guard var urlComponents = URLComponents(string: "https://api.github.com/search/issues") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [URLQueryItem(name: "q", value: query)]

        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue("token \(credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse, userInfo: [
                NSLocalizedDescriptionKey: "GitHub API error: unable to fetch review-requested pull requests"
            ])
        }

        let result = try JSONDecoder.githubDecoder().decode(CodeReviewStatus.self, from: data)
        self.reviewRequestedPullRequests = result.items
        print("Found \(result.items.count) pull requests requesting review from \(login)")
    }
}
