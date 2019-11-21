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
import Combine

var account:UserAccount?

struct LoginView: View {
    
    @State var username = ""
    @State var password = ""
    //@ObservedObject var passwordChecker: PasswordChecker = PasswordChecker()
    @State var switchView = false // will change to true when the user taps a button to change the view
    @State var isLoggedIn = false
    @State var displayLoginError = false // will be true when the user enters a wrong username or password

    var body: some View {
        
        if switchView == false { // show the login view
            return AnyView(
                NavigationView {
                    Form {
                        Section(header: Text("Username")) {
                            TextField("Username", text: $username)
                        }
                        
                        Section(header: (Text("Password"))) {
                            SecureField("Password", text: $password)
                        }
                        
                        if displayLoginError == true {
                            Text("Invalid login info!")
                            .foregroundColor(Color.red)
                        }
                        Section {
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
                           }
                        }
                       
                        
                        Section(header: Text("Don't have an account?")) {
                           NavigationLink(destination: CreateAccountView()) {
                               Text("Create Account")
                           } // end of NavigationLink
                        } //end of Section
                    
                    } // end of Form
                         
                 .navigationBarTitle(Text("Welcome to Pindex!"))
                } // end of NavigationView
                .environment(\.horizontalSizeClass, .compact)
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



