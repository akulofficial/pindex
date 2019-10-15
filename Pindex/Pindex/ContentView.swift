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

struct ContentView: View {
    var body: some View {
        login().frame(width: 100, height: 50)
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
        let button =   FBLoginButton()
        button.delegate = context.coordinator;
        return button
    }
    func updateUIView(_ uiView: FBLoginButton, context: UIViewRepresentableContext<login>) { // code
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
