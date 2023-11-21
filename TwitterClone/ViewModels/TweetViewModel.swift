//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 20/11/23.
//

import OAuthSwift
import Foundation

class TweetViewModel {
    
    private var isShowingErrorAlert = false
    
    func postTweet(tweet: Tweet) {
        
        guard let tweetData = try? JSONEncoder().encode(tweet),
              let tweetJSONString = String(data: tweetData, encoding: .utf8) else {
            print("Failed to encode tweet to JSON.")
            return
        }
        
        let oauthswift = OAuth1Swift(
            consumerKey: "f2bmQM3zpTS8SGtEtwzWH1oJW",
            consumerSecret: "ic0NW4DcUXeqB7BTBXpf0cM2R0gzm6T9AlMlINgkRlF0MdBOWb",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token"
        )
        
        oauthswift.client.credential.oauthToken = "your_access_token"
        oauthswift.client.credential.oauthTokenSecret = "your_access_token_secret"
        
        let parameters = ["status": tweetJSONString]
        
        oauthswift.client.post("https://api.twitter.com/2/tweets", parameters: parameters) { result in
            print("Error")
        }
    }
}
