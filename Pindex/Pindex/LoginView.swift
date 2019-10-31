//
//  LoginView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
//import FacebookLogin
//import FBSDKLoginKit
import Firebase

var signInSuccess = false
struct LoginView: View {
    
    @State var username = "Username"
    @State var password = "Password"

    var body: some View {
        NavigationView {
            VStack {
                // login().frame(width: 100, height: 50) // adds the facebook login button
                
                // add login button and text view here
                        
                        TextField("username", text: $username)
                            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                trailing: 10 ))
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 8)
                        TextField("password", text: $password)
                            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                                trailing: 10 ))
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(radius: 8)
                
                        
                        NavigationLink(destination: MapView()) {
                            Text("Login")
                        } // end of NavigationLink
                
                NavigationLink(destination: CRUDView()) {
                    Text("Go To CRUD operations")
                } // end of NavigationLink
                
            } // end of VStack
            
        } // end of NavigationView
        .background(Color.black)
    } // end of body view
} // end of LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

// ============== Facebook Stuff (Currently not in use) ===================

//struct login : UIViewRepresentable {
//    func makeCoordinator() -> login.Coordinator {
//        return login.Coordinator()
//    }
//
//    func makeUIView(context: UIViewRepresentableContext<login>) -> login.UIViewType {
//        let button = FBLoginButton()
//        button.permissions = ["email"]
//        button.delegate = context.coordinator;
//        return button
//    }
//
//    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<login>) { // code
//    }
//
//    class Coordinator : NSObject, LoginButtonDelegate{
//        func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
//            signInSuccess = true
//            if signInSuccess {
//                print("Moving to CRUDView")
//                // move to actual view
//            } else {
//                print("Sign in didn't work")
//            }
//        }
//
//        func loginButtonDidLogOut(_ loginButton: FBLoginButton, error: Error?) {
//            if error != nil {
//                print((error?.localizedDescription)!)
//                return
//            }
//            if AccessToken.current != nil {
//                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString )
//                Auth.auth().signIn(with: credential) { (res, er) in
//                    if er != nil {
//                        print((er?.localizedDescription)!)
//                        return
//                    }
//                    print("success")
//                }
//            }
//        }
//        func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
//            try! Auth.auth().signOut()
//        }
//    }
//}
