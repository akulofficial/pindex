//
//  LoginView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import Firebase

var currentMainScreen:String = "Login" // used to return the specific screen that we want
func getNextView(nextViewStr: String) -> AnyView {
    var returnView:AnyView = AnyView(LoginView()) // initializing arbitrarily to login View
    switch nextViewStr {
    case "login":
        returnView = AnyView(LoginView())
    case "createAccount":
        returnView = AnyView(CreateAccountView())
    case "map":
        returnView = AnyView(MapView())
    case "bulletin":
        print("cannot return bulletin currently")
        //returnView = AnyView(BulletinBoardView())
    case "post":
        returnView = AnyView(PostView())
    default:
        print("ERROR: could not get the next view")
    }
    return returnView
} // end of getNextView()


struct LoginView: View {
    
    @State var username = "Username"
    @State var password = "Password"
    @State var switchView = false // will change to true when the user taps a button to change the view

    var body: some View {
        
        
        if (switchView == false) { // show the login view
            return AnyView(
                
                NavigationView {
                    VStack {
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
                               
                       Button(action: {
                           // Closure will be called once user taps your button
                           print("Tapped the login button")
                           currentMainScreen = "map"
                           self.switchView = true
                       }) {
                           Text("Login")
                       }
                       
                       NavigationLink(destination: CreateAccountView()) {
                           Text("Create Account")
                       } // end of NavigationLink
                    
                    } // end of VStack
                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                            trailing: 10 ))
                } // end of NavigationView
                .background(Color.black)
                
            ) // end of AnyView()
        } else { // show the next view
            return getNextView(nextViewStr: currentMainScreen)
        }
        
    } // end of body view
} // end of LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
