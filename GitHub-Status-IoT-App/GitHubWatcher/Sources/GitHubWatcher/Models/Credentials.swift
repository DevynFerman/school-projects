//
//  Credentials.swift
//  GitHub Watcher
//
//  Created by Devyn Ferman on 2/14/26.
//

struct Credentials: Codable {
    let username: String
    let ghAuthToken: String

    // Devyn: Consider deleting as they're not needed with the auth token approach
    // let password: String?
    // let name: String
    // let email: String
}
