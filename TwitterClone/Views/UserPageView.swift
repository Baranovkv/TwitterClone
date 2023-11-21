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
    @State private var userPageViewModel = UserPageViewModel()
    @State private var selectedSegment = 0
    
    var body: some View {
        if let userData = userPageViewModel.userData {
        NavigationStack{
            ZStack{
                VStack { //VStack1
                        VStack(alignment: .leading) { //VStack2
                            HStack { //Hstack1
                                AsyncImage(url: URL(string: userData.profileImageURL ?? "noImage")) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: 72, height: 72)
                                .clipShape(Circle())
                                
                                Spacer()
                                Button("Edit profile") {}
                                
                                    .foregroundColor(.black)
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 7)
                                    .cornerRadius(40)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 40)
                                            .stroke(Color.black, lineWidth: 0.5)
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
                                    Text("Joined \(userData.createdAt)")
                                }
                                .foregroundColor(.gray)
                                
                                HStack {
                                    Text("\(userData.publicMetrics?.followersCount ?? 0)")
                                    Text("Following").foregroundStyle(.gray)
                                    Text("\(userData.publicMetrics?.followingCount ?? 0)")
                                    Text(userData.publicMetrics?.followingCount == 1 ? "Follower" : "Followers").foregroundStyle(.gray)
                                }
                                
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
                        NavigationLink {
                            TweetView(userData: userData)
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .frame(width: 56, height: 56)
                                .background(.white)
                                .foregroundColor(.blue)
                        }
                        .padding(16) // Отступы для кнопки
                    }
                } //VStack3
            } //ZStack
            
        } //NavigationStack
        } else {
            Text("Загрузка данных...")
                .onAppear(perform: userPageViewModel.loadData)
        } //check userData
    } //body
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UserPageView()
    }
}





