//
//  NewPost.swift
//  Pindex
//
//  Created by Swetha Chandrasekar on 11/4/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct NewPost: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var eventName = ""
    @State var eventContent = ""
    var datePosted = NSDate()
    var dateExpiry = NSDate()
    
    @Binding var posts: [Post]
    
    @State var data: String = "PLACEHOLDER"
    @State var ref: DocumentReference? = nil

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Event Name")) {
                    TextField("Event Name", text: $eventName)
                }
                    
                Section(header: Text("Event Content")) {
                    TextField("Event Content", text: $eventContent)
                }
                
                Button(action: {
                    self.ref = db.collection("Post").addDocument( data: [
                      "Title": self.eventName,
                      "Content": self.eventContent,
                      "Date_Posted": self.datePosted,
                      "Date_Expiration": self.dateExpiry,
                      "ID" : currentBulletinBoard
                   ])
                
                    let p = Post.init(title: self.eventName, content: self.eventContent, id: self.posts.count)
                    self.posts.append(p)
                    
                    print("\n\nDocumentID: " + self.ref!.documentID)
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                   Text("Create Post")
                    .navigationBarTitle("Create a Post")
                    .navigationBarItems(leading:
                        Button("Cancel") {
                        print("Cancelling Post")
                        self.presentationMode.wrappedValue.dismiss()
                    })
               }
            
            } // end of Form
        } // end of NavigationView
    } // end of body
} //end of NewPost

/*
struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost()
    }
}
*/
