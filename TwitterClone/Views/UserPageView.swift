//
//  MyPageView.swift
//  TwitterClone
//
//  Created by Kirill Baranov on 16/11/23.
//

import OAuthSwift
import SwiftUI
import Foundation

struct UserPageView: View {
    @Environment(\.colorScheme) var colorScheme
    
    @State private var userPageViewModel = UserPageViewModel()
    @State private var selectedSegment = 0
    @State private var isPresented: Bool = false
    
    var body: some View {
        if let userData = userPageViewModel.userData {
            NavigationStack{
                ZStack{
                    VStack { //VStack1
                        VStack(alignment: .leading) { //VStack2
                            HStack { //Hstack1
                                AsyncImage(url: URL(string: userData.profileImageURL ?? "noImage")) { image in
                                    image.resizable()
                                        .accessibilityAddTraits(.isButton)
                                        .accessibilityRemoveTraits(.isImage)

                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                .accessibilityLabel("Profile photo")
                                
                                Spacer()
                                Button("Edit profile") {}
                                
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .cornerRadius(40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(colorScheme == .light ? Color.black : Color.white, lineWidth: 0.5)
                                    )
                            } // HStack1
                            
                            VStack(alignment: .leading) {
                                
                                Text(userData.name)
                                    .font(.title)
                                    .bold()
                                Text(userData.username)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.vertical, 4)
                            
                            Text("\(userData.description ?? "N/A")")
                                .padding(.vertical, 4)
                            
                            VStack(alignment: .leading) {
                                HStack {
                                    Image(systemName: "calendar")
                                        .accessibilityHidden(true)
                                    Text("Joined \(userPageViewModel.formattedDateString(inputDateString: userData.createdAt))")
                                }
                                .foregroundColor(.gray)
                                
                                HStack {
                                    Text("\(userData.publicMetrics?.followingCount ?? 0)")
                                    Text("Following").foregroundStyle(.gray)
                                    Text("\(userData.publicMetrics?.followersCount ?? 0)")
                                    Text(userData.publicMetrics?.followersCount == 1 ? "Follower" : "Followers").foregroundStyle(.gray)
                                }
                                .accessibilityHidden(true)
                                .accessibilityElement()
                                .accessibilityLabel(
                                    "\(userData.publicMetrics?.followingCount ?? 0) Following, \(userData.publicMetrics?.followersCount ?? 0) \(userData.publicMetrics?.followersCount == 1 ? "Follower" : "Followers")"
                                )
                            }
                            .padding(.vertical, 4)
                            
                        }//VStack2
                        .padding(16)
                        
                        TabBarView(userData: userData)
                        
                        Spacer()
                    } //VStack1
                    
                    VStack { //VStack3
                        Spacer()
                        HStack{
                            Spacer()
                            Button(action: {
                                isPresented.toggle()
                            }, label: {
                                Image(systemName: "plus")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .padding()
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .clipShape(Circle())
                            })
                            .padding(16)
                        }
                    } //VStack3
                } //ZStack
                
            } //NavigationStack
            .fullScreenCover(isPresented: $isPresented) {
                TweetView(isPresented: $isPresented, userData: userData)
            }
        } else {
            Text("Загрузка данных...")
                .onAppear(perform: userPageViewModel.loadData)
        } //check userData
    } //body
}

#Preview {
    UserPageView()
}







