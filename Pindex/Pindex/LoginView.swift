//
//  LoginView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import Firebase
import BCryptSwift

var account:UserAccount?

struct LoginView: View {
    
    @State var username = ""
    @State var password = ""
    @State var switchView = false // will change to true when the user taps a button to change the view
    @State var isLoggedIn = false
    @State var displayLoginError = false // will be true when the user enters a wrong username or password

    var body: some View {
        
        if switchView == false { // show the login view
            return AnyView(
                
                NavigationView {
                    VStack {
                        
                        Text("Pindex")
                            .font(.title)
                        
                       TextField("username", text: $username)
                           .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                               trailing: 10 ))
                           .background(Color.white)
                           .clipShape(RoundedRectangle(cornerRadius: 8))
                           .shadow(radius: 8)
                        
                        SecureField("password", text: $password)
                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                            trailing: 10 ))
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(radius: 8)
                            
                        if displayLoginError == true {
                            Text("Username or password was incorrect")
                            .foregroundColor(Color.red)
                        }
                               
                       Button(action: {
                           // Closure will be called once user taps your button
                           print("Tapped the login button")
                        
                        db.collection("User").whereField("Username", isEqualTo: self.username).whereField("Password", isEqualTo: BCryptSwift.hashPassword(self.password, withSalt: salt))
                                .getDocuments() { (querySnapshot, err) in
                                    if let err = err {
                                        print("Error getting documents: \(err)")
                                    } else {
                                         
                                        // getting the login for username and password
                                        for document in querySnapshot!.documents {
                                            let documentDict = document.data()
                                            print("\(document.documentID) => \(documentDict)")
                                            
                                            account = UserAccount.init(fName: documentDict["First_Name"] as! String,
                                                lName: documentDict["Last_Name"] as! String,
                                                username: documentDict["Username"] as! String)
                                        } // end of for loop document in querySnapshot
                                        
                                        if account != nil { // the user successfully logged in
                                            self.isLoggedIn = true
                                            self.displayLoginError = false
                                            self.switchView = true
                                        } else { // the user name or password was wrong
                                            self.displayLoginError = true
                                        }
                                        
                                    } // end of if-else
                            } // end of db query
                           
                       }) {
                           Text("Login")
                            .padding(EdgeInsets(top: 15, leading: 10, bottom: 8,
                                                trailing: 10 ))
                       }
                       
                        
                       Text("Don't have and account?")
                       NavigationLink(destination: CreateAccountView()) {
                           Text("Create Account")
                            .padding(EdgeInsets(top: 7, leading: 10, bottom: 8,
                                                trailing: 10 ))
                       } // end of NavigationLink
                    
                    } // end of VStack
                        .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                            trailing: 10 ))
                } // end of NavigationView
                .background(Color.black)
                
            ) // end of AnyView()
        } else { // show the next view
            return AnyView(MapView(isLoggedIn: self.$isLoggedIn))
        }
        
    } // end of body view
} // end of LoginView

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}


struct UserAccount {
    
    var fName, lName, username: String
    
    // password and id currently not included in this model by design
    
} // end of Post



