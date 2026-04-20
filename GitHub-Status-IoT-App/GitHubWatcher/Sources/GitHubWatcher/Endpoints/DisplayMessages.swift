//
//  DisplayMessages.swift
//  GitHubWatcher
//
//  Created by Devyn Ferman on 3/23/26.
//

import Foundation

extension WatcherManager {
    /// Build a per-repo display message list, ordered by priority:
    /// review requests first, then drafts, then open PR counts.
    func displayMessages() -> [(topLine: String, bottomLine: String)] {
        let reviewRequestedPRs = reviewRequestedPullRequests.filter { $0.state.lowercased() == "open" }
        let openPRs = myPullRequests.filter { $0.state.lowercased() == "open" }

        var messages: [(topLine: String, bottomLine: String)] = []

        // Group review-requested PRs by repo
        let reviewsByRepo = Dictionary(grouping: reviewRequestedPRs) { pr in
            pr.repositoryFullName?.components(separatedBy: "/").last ?? "Unknown Repo"
        }
        for (repoName, prs) in reviewsByRepo.sorted(by: { $0.value.count > $1.value.count }) {
            let count = prs.count
            let label = count == 1 ? "1 Review Req" : "\(count) Reviews Req"
            messages.append((label, String(repoName.prefix(16))))
        }

        // Group open PRs by repo (drafts and non-drafts)
        let prsByRepo = Dictionary(grouping: openPRs) { pr in
            pr.repositoryFullName?.components(separatedBy: "/").last ?? "Unknown Repo"
        }
        for (repoName, prs) in prsByRepo.sorted(by: { $0.value.count > $1.value.count }) {
            let draftCount = prs.filter { $0.draft == true }.count
            let totalCount = prs.count

            if draftCount > 0 && draftCount == totalCount {
                let label = draftCount == 1 ? "1 Draft PR" : "\(draftCount) Draft PRs"
                messages.append((label, String(repoName.prefix(16))))
            } else if draftCount > 0 {
                messages.append(("\(totalCount) PRs/\(draftCount) Draft", String(repoName.prefix(16))))
            } else {
                let label = totalCount == 1 ? "1 Open PR" : "\(totalCount) Open PRs"
                messages.append((label, String(repoName.prefix(16))))
            }
        }

        if messages.isEmpty {
            messages.append(("No Open PRs", "Nothing pending"))
        }

        return messages
    }
}
