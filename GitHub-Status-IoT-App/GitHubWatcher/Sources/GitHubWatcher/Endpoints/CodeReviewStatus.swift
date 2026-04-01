//
//  CodeReviewStatus.swift
//  GitHub Watcher
//
//  Created by Devyn Ferman on 2/18/26.
//

import Foundation

struct CodeReviewStatus: Codable, Hashable {
    let totalCount: Int
    let incompleteResults: Bool
    let items: [ReviewRequestedPullRequest]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
        case items
    }
}

struct ReviewRequestedPullRequest: Codable, Hashable {
    let id: Int
    let number: Int
    let title: String
    let state: String
    let htmlURL: String
    let repositoryURL: String
    let updatedAt: Date
    let draft: Bool?
    let user: ReviewRequestedUser?
    let pullRequest: ReviewRequestedPullRequestLinks

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case title
        case state
        case htmlURL = "html_url"
        case repositoryURL = "repository_url"
        case updatedAt = "updated_at"
        case draft
        case user
        case pullRequest = "pull_request"
    }

    var repositoryFullName: String? {
        guard let parsedURL = URL(string: repositoryURL) else {
            return nil
        }

        let pathComponents = parsedURL.pathComponents.filter { $0 != "/" }
        guard pathComponents.count >= 2 else {
            return nil
        }

        let owner = pathComponents[pathComponents.count - 2]
        let repo = pathComponents[pathComponents.count - 1]
        return "\(owner)/\(repo)"
    }
}

struct ReviewRequestedUser: Codable, Hashable {
    let login: String
}

struct ReviewRequestedPullRequestLinks: Codable, Hashable {
    let url: String
    let htmlURL: String

    enum CodingKeys: String, CodingKey {
        case url
        case htmlURL = "html_url"
    }
}
