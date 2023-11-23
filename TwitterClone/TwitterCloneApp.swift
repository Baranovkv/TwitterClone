//
//  TwitterCloneApp.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 14/11/23.
//

import SwiftUI
//import SwiftData
import Foundation

@main
struct TwitterCloneApp: App {
    
    
    
    //   var twitterAPI = TwitterAPI() // App auth
    
    //    var sharedModelContainer: ModelContainer = { // SwiftData
    //        let schema = Schema([
    //            Item.self,
    //        ])
    //        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    //
    //        do {
    //            return try ModelContainer(for: schema, configurations: [modelConfiguration])
    //        } catch {
    //            fatalError("Could not create ModelContainer: \(error)")
    //        }
    //    }() // sharedModelContainer
    
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) { //TabView
                UserPageView()
                    .tabItem {
                        Image(systemName: "person")
                            .accessibilityLabel("Your Profile")
                    }
                    .tag(0)

                Text("Search")
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }
                    .tag(1)

                
                Text("Communities")
                    .tabItem {
                        Image(systemName: "person.2")
                            .accessibilityLabel("Communities")
                    }
                    .tag(2)

                Text("Notifications")
                    .tabItem {
                        Image(systemName: "bell")
                    }
                    .tag(3)

                Text("Messages")
                    .tabItem {
                        Image(systemName: "envelope")
                            .accessibilityLabel("Messages")
                    }
                    .tag(4)
                
            } //TabView
            
//            .environment(twitterAPI)
//            
//            .onOpenURL { url in
//                print("Received URL: \(url)")
//                guard let urlScheme = url.scheme,
//                      let callbackURL = URL(string: "\(TwitterAPI.ClientCredentials.CallbackURLScheme)://"),
//                      let callbackURLScheme = callbackURL.scheme
//                else { return }
//                
//                guard urlScheme.caseInsensitiveCompare(callbackURLScheme) == .orderedSame
//                else { return }
//                
//                twitterAPI.onOAuthRedirect.send(url)
//            } // onOpenURL
            
        }
        //        .modelContainer(sharedModelContainer)
    } // body
} // App
