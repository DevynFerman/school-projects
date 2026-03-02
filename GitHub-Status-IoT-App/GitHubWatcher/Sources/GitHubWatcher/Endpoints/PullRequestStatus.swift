//
//  PullRequestStatus.swift
//  GitHub Watcher
//
//  Created by Devyn Ferman on 2/18/26.
//

import Foundation

/// Represents a GitHub Pull Request returned from the API.
public struct PullRequest: Codable, Identifiable, Sendable {
    public let id: Int
    public let number: Int
    public let title: String
    public let state: String
    public let draft: Bool?
    public let htmlURL: URL
    public let createdAt: Date
    public let updatedAt: Date
    public let closedAt: Date?
    public let mergedAt: Date?
    public let user: User
    /// Not part of the API payload; set by client code after decoding to indicate which repository this PR belongs to.
    public var repositoryFullName: String?

    public struct User: Codable, Sendable {
        public let login: String
        public let id: Int
        public let type: String
        public let siteAdmin: Bool?

        enum CodingKeys: String, CodingKey {
            case login
            case id
            case type
            case siteAdmin = "site_admin"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case number
        case title
        case state
        case draft
        case htmlURL = "html_url"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case closedAt = "closed_at"
        case mergedAt = "merged_at"
        case user
        // repositoryFullName intentionally omitted
    }
}
