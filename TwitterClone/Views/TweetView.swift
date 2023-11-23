//
//  TweetView.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 20/11/23.
//


import SwiftUI

struct TweetView: View {
    @State private var tweet: Tweet = Tweet(text: "")
    @Binding var isPresented: Bool
    @State var userData: UserData
    
    var tweetViewModel = TweetViewModel()
        
    var body: some View {
        NavigationView {
            VStack { //VStack1
                HStack { //HStack1
                    VStack {
                        AsyncImage(url: URL(string: userData.profileImageURL ?? "noImage")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 56, height: 56)
                        .clipShape(Circle())
                        Spacer()
                    }
                    VStack {
                        TextField("What's happening?", text: $tweet.text, axis: .vertical)
                        Spacer()
                    }
                    
                } //HStack1
            } //VStack1
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button(action: {
                        tweetViewModel.postTweet(tweet: tweet)
                        isPresented.toggle()
                    }) {
                        Text("Post")
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(Color.blue)
                            .cornerRadius(40)
                            .disabled(tweet.text == "")
                            .opacity(tweet.text == "" ? 0.5 : 1.0)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        isPresented.toggle()
                    }) {
                        Text("Close")
                            .foregroundStyle(Color("MainTextColor"))
                    }
                }
            }
            .padding()
        } //NavigationView
    }
}

#Preview {
    TweetView(isPresented: .constant(true), userData: MockUserData)
}
