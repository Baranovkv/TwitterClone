//
//  UserData.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 16/11/23.
//

struct UserDataResponse: Decodable {
    let data: UserData
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}

struct UserData: Decodable {
    let id: String
    let name: String
    let username: String
    let createdAt: String
    let mostRecentTweetID: String?
    let isProtected: Bool
    let location: String?
    let description: String?
    let isVerified: Bool
    let profileImageURL: String?
    let publicMetrics: PublicMetrics?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case username
        case createdAt = "created_at"
        case mostRecentTweetID = "most_recent_tweet_id"
        case isProtected = "protected"
        case location
        case description
        case isVerified = "verified"
        case profileImageURL = "profile_image_url"
        case publicMetrics = "public_metrics"
    }
}

struct PublicMetrics: Decodable {
    let followersCount: Int
    let followingCount: Int
    let tweetCount: Int
    let listedCount: Int
    let likeCount: Int  // Add the new field for like count
    
    enum CodingKeys: String, CodingKey {
        case followersCount = "followers_count"
        case followingCount = "following_count"
        case tweetCount = "tweet_count"
        case listedCount = "listed_count"
        case likeCount = "like_count"  // Add the new field for like count
    }
}
