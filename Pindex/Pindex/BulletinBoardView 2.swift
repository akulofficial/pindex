//
//  BulletinBoardView.swift
//  Pindex
//
//  Created by Jake Taylor on 11/2/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI


struct BulletinBoardView: View {
    @State var showingPostView = false
    //@State var posts = getPosts()
    @Binding var mapAction: Int?
    
    @State var posts:[Post] = [] // array that will hold all posts for the current bulletin

    var body: some View {
        VStack {
            List {
                ForEach(posts, id: \.id) { post in
                    NavigationLink(destination: PostView(post: post)) {
                        Text(post.title)
                    } // end of NavigationLink
                }
                
            } // end of list
        }
        .onAppear(perform: {self.getPosts()})
        .onDisappear(perform: {
            self.mapAction = 0 // resetting so that the user may tap the annotation again
            needToCenterLocation = true // resetting so that the map centers back on the user when the view swithces back
        })
        .navigationBarTitle(currentBulletinBoard)
        .navigationBarItems(trailing:
            Button(action: {
                self.showingPostView.toggle()
            }) {
                Text("Post")
                .padding(EdgeInsets(top: 12, leading: 10, bottom: 20,
                trailing: 10 ))
            }.sheet(isPresented: $showingPostView) {
                NewPost(posts: self.$posts)
            })
        
    }
    
    
    func getPosts(){
        
        self.posts.removeAll() // need to remove all posts from collection
        
        var count:Int = 0 // used to create a specific id for posts
        
        // looping through firestore to get all posts from this bulletin board and add them to the array above
        db.collection("Post").whereField("ID", isEqualTo: currentBulletinBoard)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        let documentDict = document.data()
                        print("\(document.documentID) => \(documentDict)")
                        let p = Post.init(title: documentDict["Title"] as! String, content: documentDict["Content"] as! String, id: count)
                        self.posts.append(p)
                        count += 1
                    }
                }
                print("post size: \(self.posts.count)")
        }
        
    } // end of getPosts()

    
} // end of BulletinBoardView

/*
struct BulletinBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BulletinBoardView(mapAction: <#Binding<Int>#>)
    }
}
*/

