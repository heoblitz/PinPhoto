//
//  Unsplash.swift
//  PinPhoto
//
//  Created by heo on 2020/12/21.
//  Copyright © 2020 won heo. All rights reserved.
//

import Foundation

struct Unsplash: Codable {
    let id: String
    let thumnail: Thumnail
    let link: Link
    let width: Int
    let height: Int
    let user: User
    
    var imageRatio: Double {
        return Double(height) / Double(width)
    }
    
    var name: String {
        return user.name
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case thumnail = "urls"
        case link = "links"
        case width
        case height
        case user
    }
}

struct Thumnail: Codable {
    let small: String
}

struct Link: Codable {
    let html: String
}

struct User: Codable {
    let name: String
}
