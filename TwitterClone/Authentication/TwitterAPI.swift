////
////  TwitterAPI.swift
////  TwitterClone
////
////  Created by Kirill Baranov on 15/11/23.
////
//
//import SwiftUI
//import Combine
//import CommonCrypto
//
//class TwitterAPI: NSObject, ObservableObject {
//    @Published var authorizationSheetIsPresented = false
//    @Published var authorizationURL: URL?
//    @Published var user: User?
//    
//    private var tokenCredentials: TokenCredentials?
//    
////    struct User {
////        let ID: String
////        let screenName: String
////    }
//    
//    lazy var onOAuthRedirect = PassthroughSubject<URL, Never>()
//    
//    enum OAuthError: Error {
//        case unknown
//        case urlError(URLError)
//        case httpURLResponse(Int)
//        case cannotDecodeRawData
//        case cannotParseResponse
//        case unexpectedResponse
//        case failedToConfirmCallback
//    }
//    
//    struct ClientCredentials {
//        static let APIKey = "f2bmQM3zpTS8SGtEtwzWH1oJW"
//        static let APIKeySecret = "ic0NW4DcUXeqB7BTBXpf0cM2R0gzm6T9AlMlINgkRlF0MdBOWb"
//        static let CallbackURLScheme = "twitterclone"
//    }
//    
//    struct TemporaryCredentials {
//        let requestToken: String
//        let requestTokenSecret: String
//    }
//    
//    struct TokenCredentials {
//        let accessToken: String
//        let accessTokenSecret: String
//    }
//    
//    private func oAuthSignatureBaseString(httpMethod: String,
//                                          baseURLString: String,
//                                          parameters: [URLQueryItem]) -> String {
//        var parameterComponents: [String] = []
//        for parameter in parameters {
//            let name = parameter.name.oAuthURLEncodedString
//            let value = parameter.value?.oAuthURLEncodedString ?? ""
//            parameterComponents.append("\(name)=\(value)")
//        }
//        let parameterString = parameterComponents.sorted().joined(separator: "&")
//        return httpMethod + "&" +
//            baseURLString.oAuthURLEncodedString + "&" +
//            parameterString.oAuthURLEncodedString
//    }
//    
//    private func oAuthSigningKey(consumerSecret: String,
//                                 oAuthTokenSecret: String?) -> String {
//        if let oAuthTokenSecret = oAuthTokenSecret {
//            return consumerSecret.oAuthURLEncodedString + "&" +
//                oAuthTokenSecret.oAuthURLEncodedString
//        } else {
//            return consumerSecret.oAuthURLEncodedString + "&"
//        }
//    }
//    
//    private func oAuthSignature(httpMethod: String,
//                                baseURLString: String,
//                                parameters: [URLQueryItem],
//                                consumerSecret: String,
//                                oAuthTokenSecret: String? = nil) -> String {
//        let signatureBaseString = oAuthSignatureBaseString(httpMethod: httpMethod,
//                                                           baseURLString: baseURLString,
//                                                           parameters: parameters)
//        
//        let signingKey = oAuthSigningKey(consumerSecret: consumerSecret,
//                                         oAuthTokenSecret: oAuthTokenSecret)
//
//        return signatureBaseString.hmacSHA1Hash(key: signingKey)
//    }
//    
//    private func oAuthAuthorizationHeader(parameters: [URLQueryItem]) -> String {
//        var parameterComponents: [String] = []
//        for parameter in parameters {
//            let name = parameter.name.oAuthURLEncodedString
//            let value = parameter.value?.oAuthURLEncodedString ?? ""
//            parameterComponents.append("\(name)=\"\(value)\"")
//        }
//        return "OAuth " + parameterComponents.sorted().joined(separator: ", ")
//    }
//    
//    func oAuthRequestTokenPublisher() -> AnyPublisher<TemporaryCredentials, OAuthError> {
//        let request = (baseURLString: "https://api.twitter.com/oauth/request_token",
//                       httpMethod: "POST",
//                       consumerKey: ClientCredentials.APIKey,
//                       consumerSecret: ClientCredentials.APIKeySecret,
//                       callbackURLString: "\(ClientCredentials.CallbackURLScheme)://")
//        
//        guard let baseURL = URL(string: request.baseURLString) else {
//            return Fail(error: OAuthError.urlError(URLError(.badURL)))
//                .eraseToAnyPublisher()
//        }
//        
//        var parameters = [
//            URLQueryItem(name: "oauth_callback", value: request.callbackURLString),
//            URLQueryItem(name: "oauth_consumer_key", value: request.consumerKey),
//            URLQueryItem(name: "oauth_nonce", value: UUID().uuidString),
//            URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"),
//            URLQueryItem(name: "oauth_timestamp", value: String(Int(Date().timeIntervalSince1970))),
//            URLQueryItem(name: "oauth_version", value: "1.0")
//        ]
//        
//        let signature = oAuthSignature(httpMethod: request.httpMethod,
//                                       baseURLString: request.baseURLString,
//                                       parameters: parameters,
//                                       consumerSecret: request.consumerSecret)
//        
//        parameters.append(URLQueryItem(name: "oauth_signature", value: signature))
//
//        var urlRequest = URLRequest(url: baseURL)
//        urlRequest.httpMethod = request.httpMethod
//        urlRequest.setValue(oAuthAuthorizationHeader(parameters: parameters),
//                            forHTTPHeaderField: "Authorization")
//
//        return
//            URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .tryMap { data, response -> TemporaryCredentials in
//                guard let response = response as? HTTPURLResponse
//                else { throw OAuthError.unknown }
//
//                guard response.statusCode == 200
//                else { throw OAuthError.httpURLResponse(response.statusCode) }
//
//                guard let parameterString = String(data: data, encoding: .utf8)
//                else { throw OAuthError.cannotDecodeRawData }
//                
//                if let parameters = parameterString.urlQueryItems {
//                    guard let oAuthToken = parameters["oauth_token"],
//                          let oAuthTokenSecret = parameters["oauth_token_secret"],
//                          let oAuthCallbackConfirmed = parameters["oauth_callback_confirmed"]
//                    else {
//                        throw OAuthError.unexpectedResponse
//                    }
//                    
//                    if oAuthCallbackConfirmed != "true" {
//                        throw OAuthError.failedToConfirmCallback
//                    }
//                    
//                    return TemporaryCredentials(requestToken: oAuthToken,
//                                                requestTokenSecret: oAuthTokenSecret)
//                } else {
//                    throw OAuthError.cannotParseResponse
//                }
//            }
//            .mapError { error -> OAuthError in
//                switch (error) {
//                case let oAuthError as OAuthError:
//                    return oAuthError
//                default:
//                    return OAuthError.unknown
//                }
//            }
//            .eraseToAnyPublisher()
//    }
//    
//    func oAuthAccessTokenPublisher(temporaryCredentials: TemporaryCredentials, verifier: String) -> AnyPublisher<(TokenCredentials, User), OAuthError> {
//        let request = (baseURLString: "https://api.twitter.com/oauth/access_token",
//                       httpMethod: "POST",
//                       consumerKey: ClientCredentials.APIKey,
//                       consumerSecret: ClientCredentials.APIKeySecret)
//        
//        guard let baseURL = URL(string: request.baseURLString) else {
//            return Fail(error: OAuthError.urlError(URLError(.badURL)))
//                .eraseToAnyPublisher()
//        }
//        
//        var parameters = [
//            URLQueryItem(name: "oauth_token", value: temporaryCredentials.requestToken),
//            URLQueryItem(name: "oauth_verifier", value: verifier),
//            URLQueryItem(name: "oauth_consumer_key", value: request.consumerKey),
//            URLQueryItem(name: "oauth_nonce", value: UUID().uuidString),
//            URLQueryItem(name: "oauth_signature_method", value: "HMAC-SHA1"),
//            URLQueryItem(name: "oauth_timestamp", value: String(Int(Date().timeIntervalSince1970))),
//            URLQueryItem(name: "oauth_version", value: "1.0")
//        ]
//        
//        let signature = oAuthSignature(httpMethod: request.httpMethod,
//                                       baseURLString: request.baseURLString,
//                                       parameters: parameters,
//                                       consumerSecret: request.consumerSecret,
//                                       oAuthTokenSecret: temporaryCredentials.requestTokenSecret)
//        
//        parameters.append(URLQueryItem(name: "oauth_signature", value: signature))
//        
//        var urlRequest = URLRequest(url: baseURL)
//        urlRequest.httpMethod = request.httpMethod
//        urlRequest.setValue(oAuthAuthorizationHeader(parameters: parameters),
//                            forHTTPHeaderField: "Authorization")
//        
//        return URLSession.shared.dataTaskPublisher(for: urlRequest)
//            .tryMap { data, response -> (TokenCredentials, User) in
//                guard let response = response as? HTTPURLResponse
//                else { throw OAuthError.unknown }
//                
//                guard response.statusCode == 200
//                else { throw OAuthError.httpURLResponse(response.statusCode) }
//                
//                guard let parameterString = String(data: data, encoding: .utf8)
//                else { throw OAuthError.cannotDecodeRawData }
//                
//                if let parameters = parameterString.urlQueryItems {
//                    guard let oAuthToken = parameters.value(for: "oauth_token"),
//                          let oAuthTokenSecret = parameters.value(for: "oauth_token_secret"),
//                          let userID = parameters.value(for: "user_id"),
//                          let screenName = parameters.value(for: "screen_name")
//                    else {
//                        throw OAuthError.unexpectedResponse
//                    }
//                    
//                    return (TokenCredentials(accessToken: oAuthToken,
//                                            accessTokenSecret: oAuthTokenSecret),
//                            User(ID: userID,
//                                 screenName: screenName))
//                } else {
//                    throw OAuthError.cannotParseResponse
//                }
//            }
//            .mapError { error -> OAuthError in
//                switch (error) {
//                case let oAuthError as OAuthError:
//                    return oAuthError
//                default:
//                    return OAuthError.unknown
//                }
//            }
//            .receive(on: DispatchQueue.main)
//            .eraseToAnyPublisher()
//    } //oAuthAccessTokenPublisher()
//    
//    private var subscriptions: [String: AnyCancellable] = [:]
//    
//    func authorize() {
//        print("autorize...")
//        guard !self.authorizationSheetIsPresented else { return }
//        self.authorizationSheetIsPresented = true
//        
//        self.subscriptions["oAuthRequestTokenSubscriber"] =
//            self.oAuthRequestTokenPublisher()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion {
//                case .finished: ()
//                case .failure(_):
//                    // Handle Errors
//                    self.authorizationSheetIsPresented = false
//                }
//                print(completion)
//                self.subscriptions.removeValue(forKey: "oAuthRequestTokenSubscriber")
//            }, receiveValue: { [weak self] temporaryCredentials in
//                guard let self = self else { return }
//                
//                guard let authorizationURL = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(temporaryCredentials.requestToken)")
//                else { return }
//                self.authorizationURL = authorizationURL
//                
//                //test
//                print("Authorization URL: \(String(describing: self.authorizationURL))")
//                
//                self.subscriptions["onOAuthRedirect"] =
//                    self.onOAuthRedirect
//                    .sink(receiveValue: { [weak self] url in
//                        guard let self = self else { return }
//                        
//                        self.subscriptions.removeValue(forKey: "onOAuthRedirect")
//
//                        self.authorizationSheetIsPresented = false
//                        self.authorizationURL = nil
//                        
//                        if let parameters = url.query?.urlQueryItems {
//                            guard let oAuthToken = parameters["oauth_token"],
//                                  let oAuthVerifier = parameters["oauth_verifier"]
//                            else {
//                                // Handle error for unexpected response
//                                return
//                            }
//                            
//                            if oAuthToken != temporaryCredentials.requestToken {
//                                // Handle error for tokens do not match
//                                return
//                            }
//                            
//                            self.subscriptions["oAuthAccessTokenSubscriber"] =
//                                self.oAuthAccessTokenPublisher(temporaryCredentials: temporaryCredentials,
//                                                               verifier: oAuthVerifier)
//                                .receive(on: DispatchQueue.main)
//                                .sink(receiveCompletion: { _ in
//                                    // Error handler
//                                }, receiveValue: { [weak self] (tokenCredentials, user) in
//                                    guard let self = self else { return }
//                                    
//                                    self.subscriptions.removeValue(forKey: "oAuthRequestTokenSubscriber")
//                                    self.subscriptions.removeValue(forKey: "onOAuthRedirect")
//                                    self.subscriptions.removeValue(forKey: "oAuthAccessTokenSubscriber")
//                                    
//                                    self.tokenCredentials = tokenCredentials
//                                    self.user = user
//                                })
//                            print("test")
//                        }
//                    })
//            })
//    } //authorize()
//}
//
//extension String {
//    func hmacSHA1Hash(key: String) -> String {
//        var digest = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
//        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1),
//               key,
//               key.count,
//               self,
//               self.count,
//               &digest)
//        return Data(digest).base64EncodedString()
//    }
//}
//
//extension CharacterSet {
//    static var urlRFC3986Allowed: CharacterSet {
//        CharacterSet(charactersIn: "-_.~").union(.alphanumerics)
//    }
//}
//
//extension String {
//    var oAuthURLEncodedString: String {
//        self.addingPercentEncoding(withAllowedCharacters: .urlRFC3986Allowed) ?? self
//    }
//}
//
//extension String {
//    var urlQueryItems: [URLQueryItem]? {
//        URLComponents(string: "://?\(self)")?.queryItems
//    }
//}
//
//extension Array where Element == URLQueryItem {
//    func value(for name: String) -> String? {
//        return self.filter({$0.name == name}).first?.value
//    }
//    
//    subscript(name: String) -> String? {
//        return value(for: name)
//    }
//}
