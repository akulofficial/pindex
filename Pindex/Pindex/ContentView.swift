//
//  ContentView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//
import SwiftUI
import FacebookLogin
import FBSDKLoginKit
import Firebase
import FirebaseFirestore


struct ContentView: View {
    @State var data: String = "PLACEHOLDER";
    var body: some View {
        //login().frame(width: 100, height: 50)
//        var ref: DocumentReference? = nil
//        ref = db.collection("User").addDocument(data: [
//            "First_Name": "test",
//            "Last_Name": "test",
//            "ID": 0
//        ])
        var ref: DocumentReference? = nil;
        let stack = VStack{
            
            //Create button
            Button(action: {
                ref = db.collection("User").addDocument( data: [
                    "First_Name": "test",
                    "Last_Name": "test",
                    "ID": 0
                ])
                print(ref!.documentID)
            }) {
                Text("CREATE")
            }
            
            //Read button
            Button(action: {
                db.collection("User").document(ref!.documentID).getDocument {
                    (document, error) in
                    if let document = document, document.exists {
                        self.data = document.data().map(String.init(describing:)) ?? "nil"
                        print("Document data: \(self.data)")
                        print(ref!.documentID)
                    } else {
                        print("Document does not exist")
                    }
                }
            }) {
                Text("READ")
            }
            
            //Update button
            Button(action: {
                db.collection("User").document(ref!.documentID).updateData([
                    "First_Name": "updated_test"
                ])
                print(ref!.documentID)
            }) {
                Text("UPDATE")
            }
            
            //Delete button
            Button(action:{
                print("BEFORE DELETION")
                print(ref!.documentID)
                db.collection("User").document(ref!.documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
                print(ref!.documentID)
            }) {
                Text("DELETE")
            }
            Text(data)
        }
        return stack;
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct login : UIViewRepresentable {
    
    func makeCoordinator() -> login.Coordinator {
        return login.Coordinator()
    }
    
    func makeUIView(context: UIViewRepresentableContext<login>) -> login.UIViewType {
        let button = FBLoginButton()
        button.delegate = context.coordinator;
        return button
    }
    
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<login>) {
        // code
    }
    
    class Coordinator : NSObject, LoginButtonDelegate{
        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
            //code
            
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton, error: Error?) {
            if error != nil {
                print((error?.localizedDescription)!)
                return
            }
            if AccessToken.current != nil {
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString )
                Auth.auth().signIn(with: credential) { (res, er) in
                    if er != nil {
                        print((er?.localizedDescription)!)
                        return
                    }
                    print("success")
                }
            }
        }
        
        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
            try! Auth.auth().signOut()
        }
    }
}
