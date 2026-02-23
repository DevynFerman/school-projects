//
//  Autheticate.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/14/26.
//

import Foundation

extension WatcherManager {
    func fetchGitHubUser(_ manager: WatcherManager) async throws {
        let url = URL(string: "https://api.github.com/users/\(manager.credentials.username)")!
        var request = URLRequest(url: url)
        request.setValue("token \(manager.credentials.ghAuthToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            print("GitHub API error: unable to retrieve user data")
            return
        }
        
        let json = try JSONSerialization.jsonObject(with: data, options: [])
        print(json)
    }
    
    func fetchRepos(_ manager: WatcherManager) async throws {
        
    }
}
