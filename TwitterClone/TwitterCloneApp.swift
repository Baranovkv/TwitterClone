//
//  TwitterCloneApp.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 14/11/23.
//

import SwiftUI
import SwiftData
import Foundation

@main
struct TwitterCloneApp: App {
    
//    @StateObject private var twitterAPI = TwitterAPI()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }() // sharedModelContainer
    
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) { //TabView
                UserPageView()
                    .tabItem {
                        Image(systemName: selectedTab == 0 ? "person.fill" : "person")
                    }
                    .tag(0)
                Text("Search")
                    .tabItem {
                            Image(systemName: "magnifyingglass")
                    }
                    .tag(1)
                
                Text("Communities")
                    .tabItem {
                        Image(systemName: selectedTab == 2 ? "person.2.fill" : "person.2")
                    }
                    .tag(2)
                
                Text("Notifications")
                    .tabItem {
                        Image(systemName: selectedTab == 3 ? "bell.fill" : "bell")
                    }
                    .tag(3)
                
                Text("Messages")
                    .tabItem {
                        Image(systemName: selectedTab == 4 ? "envelope.fill" : "envelope")
                    }
                    .tag(4)

                
                //                .environmentObject(twitterAPI)
                //                .onOpenURL { url in
                //                    print("Received URL: \(url)")
                //                    guard let urlScheme = url.scheme,
                //                          let callbackURL = URL(string: "\(TwitterAPI.ClientCredentials.CallbackURLScheme)://"),
                //                          let callbackURLScheme = callbackURL.scheme
                //                    else { return }
                //
                //                    guard urlScheme.caseInsensitiveCompare(callbackURLScheme) == .orderedSame
                //                    else { return }
                //
                //                    twitterAPI.onOAuthRedirect.send(url)
                //                } // onOpenURL
                
            } //TabView
            
        }
        .modelContainer(sharedModelContainer)
    } // body
} // App
