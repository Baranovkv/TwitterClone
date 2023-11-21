//
//  PostsView.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 17/11/23.
//

import SwiftUI

struct PostsView: View {
    
    @State var userData: UserData
    
    var body: some View {
        VStack{
            ScrollView {
                if userData.mostRecentTweetID != nil {
                    ForEach (0..<10) { _ in
                    HStack(alignment: .top, content: { //HStack1
                        AsyncImage(url: URL(string: userData.profileImageURL ?? "noImage")) { image in
                            image.resizable()
                        } placeholder: {
                            Color.gray
                        }
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                        VStack(alignment: .leading, content: { //VStack1
                            HStack { // HStack2
                                Text(userData.name)
                                Text(userData.username)
                                Text("10m") //Time from publish
                                Spacer()
                                Button("..."){ }
                                    .foregroundColor(.black)
                            } //Hstack2
                            Text("I'm testing twitter API")
                            HStack {
                                Image(systemName: "message")
                                Spacer()
                                Image(systemName: "arrow.2.squarepath")
                                Spacer()
                                Image(systemName: "heart")
                                Spacer()
                                HStack{
                                    Image(systemName: "chart.bar.xaxis")
                                    Text("20") //views count
                                }
                                Spacer()
                                HStack{
                                    Image(systemName: "bookmark")
                                    Image(systemName: "square.and.arrow.up")
                                }
                            } //HStack2
                        }) // VStack1
                    }) // HStack1
                    .padding()
                }
                    
                    Spacer()
                }
            }
        }
    }
    
}

#Preview {
    PostsView(userData: MockUserData)
}
