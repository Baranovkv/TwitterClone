//
//  TweetView.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 20/11/23.
//


import SwiftUI

struct TweetView: View {
    @State private var tweet: Tweet = Tweet(text: "")
    @State private var isShowingErrorAlert = false
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
            .padding()
        } //NavigationView
        
        
        
        Button(action: {
            tweetViewModel.postTweet(tweet: tweet)
        }) {
            Text("Отправить твит")
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(8)
        }
        
        .padding()
        .navigationBarTitle("Новый твит", displayMode: .inline)
        .alert(isPresented: $isShowingErrorAlert) {
            Alert(title: Text("Ошибка"), message: Text("Не удалось отправить твит"), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    TweetView(userData: MockUserData)
}
