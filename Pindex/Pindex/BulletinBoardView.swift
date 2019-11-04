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
    @Binding var mapAction: Int?

    var body: some View {
        VStack {
            Text("Bulletin Board Stuff Here")
            getPosts()
            ScrollView {
                Text("posts here")
                getPosts()
            }
            Button(action: {
                self.showingPostView.toggle()
            }) {
                Text("Make Post")
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 20,
                trailing: 10 ))
            }.sheet(isPresented: $showingPostView) {
                NewPost()
            }
        }
        .onDisappear(perform: {
            self.mapAction = 0 // resetting so that the user may tap the annotation again
            needToCenterLocation = true // resetting so that the map centers back on the user when the view swithces back
        })
        .navigationBarTitle(currentBulletinBoard)
        
    }
    
    
} // end of BulletinBoardView

/*
struct BulletinBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BulletinBoardView(mapAction: <#Binding<Int>#>)
    }
}
*/

func getPosts() -> AnyView {
    var returnView:AnyView = AnyView(Text("this works"))
    print("INSIDE THE GETPOSTS()")
    /*
    let postRef = db.collection("Post")
    let query = postRef.whereField("ID", isEqualTo: currentBulletinBoard)
    let docs = query.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("Got inside")
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    // add these docs (posts) to the returnView
                    
                }
            }
    }
    print(query)*/
    print(currentBulletinBoard)
    db.collection("Post").whereField("ID", isEqualTo: currentBulletinBoard)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
    }
    return returnView
}
