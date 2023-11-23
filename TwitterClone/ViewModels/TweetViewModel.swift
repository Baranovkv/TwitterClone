//
//  TweetViewModel.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 20/11/23.
//

import OAuthSwift
import Foundation

class TweetViewModel {
        
    func postTweet(tweet: Tweet) {
        
        let oauthswift = OAuth1Swift(
            consumerKey: "f2bmQM3zpTS8SGtEtwzWH1oJW",
            consumerSecret: "ic0NW4DcUXeqB7BTBXpf0cM2R0gzm6T9AlMlINgkRlF0MdBOWb",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl: "https://api.twitter.com/oauth/authorize",
            accessTokenUrl: "https://api.twitter.com/oauth/access_token"
        )
        
        oauthswift.client.credential.oauthToken = "1703379143264538625-e70zoTAmQbp4vyObVWIB7GS8QnlLWA"
        oauthswift.client.credential.oauthTokenSecret = "g2daN34LdGGGNahPPQpd3CGrmm5fNlzqSRdM1MCqs9tms"
        
        let parameters = ["text": tweet.text]
        let headers = ["Content-Type": "application/json"]
        
        print(parameters)
        
        oauthswift.client.post("https://api.twitter.com/2/tweets", parameters: parameters, headers: headers) { result in
            switch result {
            case .success(let response):
                print("Successfully posted tweet. Response: \(response)")
            case .failure(let error):
                print("Error posting tweet: \(error)")
            }
        }
    }
}
