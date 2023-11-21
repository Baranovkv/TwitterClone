//
//  UserPageViewModel.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 16/11/23.
//

import Foundation
import OAuthSwift

class UserPageViewModel {
    var userData: UserData? = MockUserData
    
    func loadData() {
        // OAuth 1.0a tokens
        let consumerKey = "f2bmQM3zpTS8SGtEtwzWH1oJW"
        let consumerSecret = "ic0NW4DcUXeqB7BTBXpf0cM2R0gzm6T9AlMlINgkRlF0MdBOWb"
        let accessToken = "1703379143264538625-e70zoTAmQbp4vyObVWIB7GS8QnlLWA"
        let accessTokenSecret = "g2daN34LdGGGNahPPQpd3CGrmm5fNlzqSRdM1MCqs9tms"
        
//        let url = "https://api.twitter.com/2/users/me?user.fields=created_at,most_recent_tweet_id,protected,location,description,verified,verified_type,profile_image_url,public_metrics&expansions=pinned_tweet_id&tweet.fields=created_at,text,public_metrics"

        let url = "https://api.twitter.com/2/users/me?user.fields=created_at,most_recent_tweet_id,protected,location,description,verified,verified_type,profile_image_url,public_metrics";

        let oauthswift = OAuth1Swift(
            consumerKey: consumerKey,
            consumerSecret: consumerSecret,
            requestTokenUrl: "",
            authorizeUrl: "",
            accessTokenUrl: ""
        )
        
        oauthswift.client.credential.oauthToken = accessToken
        oauthswift.client.credential.oauthTokenSecret = accessTokenSecret
        
        oauthswift.client.get(url) { result in
            switch result {
            case .success(let response):
                do {
                    let jsonString = String(data: response.data, encoding: .utf8)
                    print("JSON: \(jsonString ?? "Невозможно прочитать JSON-ответ")")
                    
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(UserDataResponse.self, from: response.data)
                    DispatchQueue.main.async {
                        self.userData = result.data
                    }
                } catch {
                    print("Ошибка декодирования JSON: \(error.localizedDescription)")
                }
            case .failure(let error):
                print("Ошибка запроса данных: \(error.localizedDescription)")
            }
        }
    }
}
