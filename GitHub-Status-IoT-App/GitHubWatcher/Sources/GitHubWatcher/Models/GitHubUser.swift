//
//  GitHubUser.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/23/26.
//

import Foundation

/// Represents the response from GitHub's "Get the authenticated user" API (/user).
/// Only commonly-used fields are included; add more as needed.
public struct GitHubUser: Codable, Identifiable, Sendable {
    public let login: String
    public let id: Int
    public let nodeID: String
    public let avatarURL: URL?
    public let gravatarID: String?
    public let url: URL
    public let htmlURL: URL
    public let followersURL: URL
    public let followingURL: String
    public let gistsURL: String
    public let starredURL: String
    public let subscriptionsURL: URL
    public let organizationsURL: URL
    public let reposURL: URL
    public let eventsURL: String
    public let receivedEventsURL: URL
    public let type: String
    public let siteAdmin: Bool

    // Profile details
    public let name: String?
    public let company: String?
    public let blog: String?
    public let location: String?
    public let email: String?
    public let hireable: Bool?
    public let bio: String?
    public let twitterUsername: String?

    // Stats
    public let publicRepos: Int
    public let publicGists: Int
    public let followers: Int
    public let following: Int

    // Timestamps
    public let createdAt: Date
    public let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case login
        case id
        case nodeID = "node_id"
        case avatarURL = "avatar_url"
        case gravatarID = "gravatar_id"
        case url
        case htmlURL = "html_url"
        case followersURL = "followers_url"
        case followingURL = "following_url"
        case gistsURL = "gists_url"
        case starredURL = "starred_url"
        case subscriptionsURL = "subscriptions_url"
        case organizationsURL = "organizations_url"
        case reposURL = "repos_url"
        case eventsURL = "events_url"
        case receivedEventsURL = "received_events_url"
        case type
        case siteAdmin = "site_admin"
        case name
        case company
        case blog
        case location
        case email
        case hireable
        case bio
        case twitterUsername = "twitter_username"
        case publicRepos = "public_repos"
        case publicGists = "public_gists"
        case followers
        case following
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

/// A JSONDecoder configured for GitHub's date format (ISO 8601).
public extension JSONDecoder {
    static func githubDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
