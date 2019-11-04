//
//  NewPost.swift
//  Pindex
//
//  Created by Swetha Chandrasekar on 11/4/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import Firebase

struct NewPost: View {
    @State var eventName = "Name"
    @State var eventContent = "Content"
    var datePosted = NSDate()
    var dateExpiry = NSDate()

    
    @State var data: String = "PLACEHOLDER"
    @State var ref: DocumentReference? = nil
    @State var switchView = false // will change to true when the user taps a button to change the view
    var body: some View {
                            VStack {
                             TextField("Event Name", text: $eventName)
                                 .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                                     trailing: 10 ))
                                 .background(Color.white)
                                 .clipShape(RoundedRectangle(cornerRadius: 8))
                                 .shadow(radius: 8)
                             TextField("Event Content", text: $eventContent)
                                 .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                                     trailing: 10 ))
                                 .background(Color.white)
                                 .clipShape(RoundedRectangle(cornerRadius: 8))
                                 .shadow(radius: 8)

                             Button(action: {
                                 self.ref = db.collection("Post").addDocument( data: [
                                    "Title": self.$eventName,
                                    "Content": self.$eventContent,
                                    "Date_Posted": self.datePosted,
                                    "Date_Expiration": self.dateExpiry
                                 ])
                                 print(self.ref!.documentID)
                             }) {
                                 Text("Create Post")
                             }
                          
                          } // end of VStack
                              .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                                  trailing: 10 ))
                      }
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost()
    }
}
