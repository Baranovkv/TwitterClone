//
//  ContentView.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 14/11/23.
//

import SwiftUI
import Combine

struct TimelineView: View {
//    @EnvironmentObject var twitterAPI: TwitterAPI

    var body: some View {
        NavigationStack {
//            if let screenName = twitterAPI.user?.screenName {
//                Text("Welcome").font(.largeTitle)
//                Text(screenName).font(.largeTitle)
//            } else {
//                Button("Signin with Twitter", action: {
//                    twitterAPI.authorize()
//                })
//            }
            NavigationLink("My Page", destination: UserPageView())
        }
//        .sheet(isPresented: $twitterAPI.authorizationSheetIsPresented) {
//            SafariView(url: $twitterAPI.authorizationURL)
//                .onAppear {
//                            print("SafariView appeared with URL: \($twitterAPI.authorizationURL)")
//                        }
//        }
    }
}

//struct TimelineView_Previews: PreviewProvider {
//    static var previews: some View {
//        TimelineView()
//    }
//}
