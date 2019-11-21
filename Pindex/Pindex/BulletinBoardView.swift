//
//  BulletinBoardView.swift
//  Pindex
//
//  Created by Jake Taylor on 11/2/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import FirebaseFirestore


struct BulletinBoardView: View {
    @State var showingPostView = false
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
        .onAppear(perform: {
            self.loadPostsWithPaging()
        })
        .onDisappear(perform: {
            self.mapAction = 0 // resetting so that the user may tap the annotation again
            self.posts.removeAll() //clears the posts
            needToCenterLocation = true // resetting so that the map centers back on the user when the view swithces back
        })
        .navigationBarTitle(currentBulletinBoard)
        .navigationBarItems(trailing:
            Button(action: {
                self.showingPostView.toggle()
            }) {
                Text("Post")
            }.sheet(isPresented: $showingPostView) {
                NewPost(posts: self.$posts)
            })
        
    }
    
    //DEPRECATED
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
    
    
    
    
    // called in place of getPosts()
    func loadPostsWithPaging() {
        
        self.posts.removeAll() // need to remove all old posts before loading new ones
     
        let numOfPosts:Int = getNumberOfPosts() // getting the number of posts for this bulletin board
        var count = 0
        let pagingAmount = 1
        
        while (count < 30) { // the current date has not been reached yet
            getPostsPaging(startNum: count, endNum: (count + pagingAmount))
            count += pagingAmount
        } // end of while loop
        
    } // end of loadPostsWithPaging()
    
    // returns the number of posts associated with this bulletin board
    func getNumberOfPosts() -> Int {
        
        var numOfPosts = 0
        
        db.collection("Post").whereField("ID", isEqualTo: currentBulletinBoard)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents for bulletin post count: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        numOfPosts += 1
                    }
                }
                print("post size: \(self.posts.count)")
        }
        
        return numOfPosts
    
    } // end of getNumberOfPosts()
    
    func getPostsPaging(startNum: Int, endNum: Int){
        
        var count:Int = startNum // used to create a specific id for posts
        var postID:Int = count
        
        // looping through firestore to get all posts from this bulletin board and add them to the array above
        db.collection("Post").whereField("ID", isEqualTo: currentBulletinBoard)
            .whereField("PostNumber", isEqualTo: startNum)
            .getDocuments()
                { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    
                    for document in querySnapshot!.documents {
                        let documentDict = document.data()
                        print("\(document.documentID) => \(documentDict)")
                        let p = Post.init(title: documentDict["Title"] as! String, content: documentDict["Content"] as! String, id: postID)
                        self.posts.append(p)
                        postID += 1
                    }
                }
                print("post size: \(self.posts.count)")
                count += 1
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

extension CollectionReference {
    func whereField(_ field: String, isDateInToday value: Date) -> Query {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: value)
        guard
            let start = Calendar.current.date(from: components),
            let end = Calendar.current.date(byAdding: .day, value: 1, to: start)
        else {
            fatalError("Could not find start date or calculate end date.")
        }
        return whereField(field, isGreaterThan: start).whereField(field, isLessThan: end)
    }
}


