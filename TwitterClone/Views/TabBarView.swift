//
//  TabBarView.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 17/11/23.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedSegment = 0
    @State var userData: UserData

    var body: some View {
        Group {
            HStack(alignment: .center) {
                ForEach(0..<5) { index in
                    Spacer()
                    Button(["Posts", "Replies", "Highlights", "Media", "Likes"][index])
                    {
                        selectedSegment = index
                    }
                    .font(Font.system(size: 16).weight(.bold))
                    .foregroundColor(selectedSegment == index ? Color("MainTextColor") : .gray)
                    .multilineTextAlignment(.center)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
                    .overlay(Rectangle()
                        .frame(width: nil, height: 4)
                        .foregroundColor(selectedSegment == index ? Color.blue: Color.clear), alignment: .bottom)
                    Spacer()
                }
                
            } //HStack
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            Divider()
        } //VStack
            TabView(selection: $selectedSegment) {
                PostsView(userData: userData)
                    .tag(0)
                RepliesView()
                    .tag(1)
                HighlightsView()
                    .tag(2)
                MediaView()
                    .tag(3)
                LikesView()
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
}

#Preview {
    TabBarView(userData: MockUserData)
}
