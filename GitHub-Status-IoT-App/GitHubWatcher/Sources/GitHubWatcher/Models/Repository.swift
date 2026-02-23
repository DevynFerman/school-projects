//
//  Repository.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 2/23/26.
//

import Foundation

/// Represents a GitHub repository returned from the API.
public struct Repository: Codable, Identifiable, Sendable {
    // Identity
    public let id: Int
    public let nodeID: String
    public let name: String
    public let fullName: String
    public let isPrivate: Bool

    // Owner (minimal subset; you can reuse GitHubUser if desired, but here we keep just login/id to avoid cycles)
    public let owner: Owner

    // URLs
    public let htmlURL: URL
    public let url: URL
    public let forksURL: URL
    public let keysURL: String
    public let collaboratorsURL: String
    public let teamsURL: URL
    public let hooksURL: URL
    public let issueEventsURL: String
    public let eventsURL: URL
    public let assigneesURL: String
    public let branchesURL: String
    public let tagsURL: URL
    public let blobsURL: String
    public let gitTagsURL: String
    public let gitRefsURL: String
    public let treesURL: String
    public let statusesURL: String
    public let languagesURL: URL
    public let stargazersURL: URL
    public let contributorsURL: URL
    public let subscribersURL: URL
    public let subscriptionURL: URL
    public let commitsURL: String
    public let gitCommitsURL: String
    public let commentsURL: String
    public let issueCommentURL: String
    public let contentsURL: String
    public let compareURL: String
    public let mergesURL: URL
    public let archiveURL: String
    public let downloadsURL: URL
    public let issuesURL: String
    public let pullsURL: String
    public let milestonesURL: String
    public let notificationsURL: String
    public let labelsURL: String
    public let releasesURL: String
    public let deploymentsURL: URL

    // Description and metadata
    public let description: String?
    public let fork: Bool
    public let homepage: String?
    public let language: String?

    // Visibility & status
    public let isTemplate: Bool?
    public let visibility: String?
    public let archived: Bool
    public let disabled: Bool
    public let allowForking: Bool?

    // Counts
    public let forksCount: Int
    public let stargazersCount: Int
    public let watchersCount: Int
    public let size: Int
    public let openIssuesCount: Int
    public let defaultBranch: String

    // Dates
    public let createdAt: Date
    public let updatedAt: Date
    public let pushedAt: Date?

    public struct Owner: Codable, Sendable {
        public let login: String
        public let id: Int
        public let nodeID: String
        public let avatarURL: URL?
        public let url: URL
        public let htmlURL: URL
        public let type: String
        public let siteAdmin: Bool

        enum CodingKeys: String, CodingKey {
            case login
            case id
            case nodeID = "node_id"
            case avatarURL = "avatar_url"
            case url
            case htmlURL = "html_url"
            case type
            case siteAdmin = "site_admin"
        }
    }

    enum CodingKeys: String, CodingKey {
        case id
        case nodeID = "node_id"
        case name
        case fullName = "full_name"
        case isPrivate = "private"
        case owner
        case htmlURL = "html_url"
        case url
        case forksURL = "forks_url"
        case keysURL = "keys_url"
        case collaboratorsURL = "collaborators_url"
        case teamsURL = "teams_url"
        case hooksURL = "hooks_url"
        case issueEventsURL = "issue_events_url"
        case eventsURL = "events_url"
        case assigneesURL = "assignees_url"
        case branchesURL = "branches_url"
        case tagsURL = "tags_url"
        case blobsURL = "blobs_url"
        case gitTagsURL = "git_tags_url"
        case gitRefsURL = "git_refs_url"
        case treesURL = "trees_url"
        case statusesURL = "statuses_url"
        case languagesURL = "languages_url"
        case stargazersURL = "stargazers_url"
        case contributorsURL = "contributors_url"
        case subscribersURL = "subscribers_url"
        case subscriptionURL = "subscription_url"
        case commitsURL = "commits_url"
        case gitCommitsURL = "git_commits_url"
        case commentsURL = "comments_url"
        case issueCommentURL = "issue_comment_url"
        case contentsURL = "contents_url"
        case compareURL = "compare_url"
        case mergesURL = "merges_url"
        case archiveURL = "archive_url"
        case downloadsURL = "downloads_url"
        case issuesURL = "issues_url"
        case pullsURL = "pulls_url"
        case milestonesURL = "milestones_url"
        case notificationsURL = "notifications_url"
        case labelsURL = "labels_url"
        case releasesURL = "releases_url"
        case deploymentsURL = "deployments_url"
        case description
        case fork
        case homepage
        case language
        case isTemplate = "is_template"
        case visibility
        case archived
        case disabled
        case allowForking = "allow_forking"
        case forksCount = "forks_count"
        case stargazersCount = "stargazers_count"
        case watchersCount = "watchers_count"
        case size
        case openIssuesCount = "open_issues_count"
        case defaultBranch = "default_branch"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case pushedAt = "pushed_at"
    }
}

// Usage: decode with JSONDecoder.githubDecoder() to handle ISO8601 dates.

