//
//  GitHubGetters.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/14/26.
//

import Foundation

extension WatcherManager {
    func getGitHubUser(_ manager: WatcherManager) async throws -> GitHubUser {
        let url = URL(string: "https://api.github.com/users/\(manager.credentials.username)")!
        var request = URLRequest(url: url)
        request.setValue("token \(manager.credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            fatalError("GitHub API error: unable to retrieve user data")
        }

        let ghUser: GitHubUser = try! JSONDecoder.githubDecoder().decode(GitHubUser.self, from: data)
        return ghUser
    }
    
//    func getRepos(_ manager: WatcherManager) async throws -> [Repository] {
//        guard let userRepos = manager.ghUser?.reposURL
//        else {
//            fatalError("No user repos")
//        }
//        for repo in userRepos {
//            let url = URL(string: "https://api.github.com\(repo)")!
//            var request = URLRequest(url: url)
//            request.setValue("token \(manager.credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
//            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
//        }
//    }
}
