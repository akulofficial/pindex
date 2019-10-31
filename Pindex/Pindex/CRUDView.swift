//
//  CRUDView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//
import SwiftUI
import Firebase
import FirebaseFirestore


struct CRUDView: View {
    @State var data: String = "PLACEHOLDER"
    @State var ref: DocumentReference? = nil
    var body: some View {
        let stack = VStack{
            //Create button
            Button(action: {
                self.ref = db.collection("User").addDocument( data: [
                    "First_Name": "test",
                    "Last_Name": "test",
                    "ID": 0
                ])
                print(self.ref!.documentID)
            }) {
                Text("CREATE")
            }
            
            //Read button
            Button(action: {
                db.collection("User").document(self.ref!.documentID).getDocument {
                    (document, error) in
                    if let document = document, document.exists {
                        self.data = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(self.data)")
                        print(self.ref!.documentID)
                    } else {
                        print("Document does not exist")
                    }
                }
                print("ref.docID after read: " + self.ref!.documentID)
            }) {
                Text("READ")
            }
            
            //Update button
            Button(action: {
                db.collection("User").document(self.ref!.documentID).updateData([
                    "First_Name": "updated_test"
                ])
                print(self.ref!.documentID)
            }) {
                Text("UPDATE")
            }
            
            //Delete button
            Button(action:{
                print("BEFORE DELETION")
                print(self.ref!.documentID)
                db.collection("User").document(self.ref!.documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                print(self.ref!.documentID)
            }) {
                Text("DELETE")
            }
            Text(data)
        }
        return stack
    }
}
struct CRUDView_Previews: PreviewProvider {
    static var previews: some View {
        CRUDView()
    }
}
