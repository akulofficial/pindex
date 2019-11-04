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
    
    @State var eventName = "Name"
    @State var eventContent = "Content"
    @State var datePosted = NSDate()
    @State var dateExpiry = NSDate()

    
    @State var data: String = "PLACEHOLDER"
    @State var ref: DocumentReference? = nil

    var body: some View {
        NavigationView {
            
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
                      "Title": self.eventName,
                      "Content": self.eventContent,
                      "Date_Posted": self.datePosted,
                      "Date_Expiration": self.dateExpiry,
                      "ID" : 1
                   ])
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
            
            } // end of VStack
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                    trailing: 10 ))
            
        } // end of NavigationView
                            
    } // end of body
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost()
    }
}
