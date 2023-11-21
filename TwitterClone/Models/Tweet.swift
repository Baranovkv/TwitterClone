//
//  Tweet.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 20/11/23.
//

import Foundation

struct Tweet: Encodable {
    var text: String
    var directMessageDeepLink: String?
    var forSuperFollowersOnly: Bool?
    var geo: Geo?
    var media: Media?
    var poll: Poll?
    var quoteTweetID: String?
    var reply: Reply?
    var replySettings: String?

    struct Geo: Codable {
        var placeID: String

        enum CodingKeys: String, CodingKey {
            case placeID = "place_id"
        }
    }

    struct Media: Codable {
        var mediaIDs: [String]
        var taggedUserIDs: [String]?

        enum CodingKeys: String, CodingKey {
            case mediaIDs = "media_ids"
            case taggedUserIDs = "tagged_user_ids"
        }
    }

    struct Poll: Codable {
        var durationMinutes: Int
        var options: [String]

        enum CodingKeys: String, CodingKey {
            case durationMinutes = "duration_minutes"
            case options
        }
    }

    struct Reply: Codable {
        var inReplyToTweetID: String
        var excludeReplyUserIDs: [String]?

        enum CodingKeys: String, CodingKey {
            case inReplyToTweetID = "in_reply_to_tweet_id"
            case excludeReplyUserIDs = "exclude_reply_user_ids"
        }
    }
}
