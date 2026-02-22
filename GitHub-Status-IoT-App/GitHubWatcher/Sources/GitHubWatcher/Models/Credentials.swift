//
//  Credentials.swift
//  GitHub Watcher
//
//  Created by Devyn Ferman on 2/14/26.
//

struct  Credentials: Codable {
    let username: String
    let password: String?
    let ghAuthToken: String
    let name: String
    let email: String
}
