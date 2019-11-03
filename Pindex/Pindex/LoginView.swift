//
//  LoginView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
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
                
                NavigationLink(destination: CreateAccountView()) {
                    Text("Create Account")
                } // end of NavigationLink
                
            } // end of VStack
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
            trailing: 10 ))
            
        } // end of NavigationView
        .background(Color.black)
    } // end of body view
} // end of LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
