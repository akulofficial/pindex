//
//  CreateAccountView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//
import SwiftUI
import Firebase
import FirebaseFirestore
import UIKit
import BCryptSwift
import Combine

// Global booleans for testing purposes
//var displayUsernameErrorTest:Bool = false
//var displayUsernameFormatErrorTest:Bool = false
//var displayPasswordFormatErrorTest:Bool = false
//var displayPasswordsMatchErrorTest:Bool = false

struct CreateAccountView: View {
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @State var data: String = "PLACEHOLDER"
    @State var ref: DocumentReference? = nil
    @State var firstName = ""
    @State var lastName = ""
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var displayUsernameError:Bool = false
    @State var displayUsernameFormatError:Bool = false
    @State var displayPasswordFormatError:Bool = false
    @State var displayPasswordsMatchError:Bool = false
    
    
    func processInput() {
        
        displayUsernameError = false
        displayUsernameFormatError = !isUsernameValid(username: username)
        displayPasswordFormatError = !isPasswordValid(password: password)
        displayPasswordsMatchError = !isPasswordMatch(passwordOne: password, passwordTwo: confirmPassword)
        
            
            if (displayPasswordFormatError == false && displayUsernameFormatError == false ) {
               db.collection("User").whereField("Username", isEqualTo: self.username)
                   .getDocuments() { (querySnapshot, err) in
                       if let err = err {
                           print("Error getting documents: \(err)")
                       } else {
                            
                           var userExists:Bool = false
                           
                           // getting the login for username and password
                           for document in querySnapshot!.documents {
                               userExists = true
                           } // end of for loop document in querySnapshot
                           
                        if userExists == false &&
                            self.displayPasswordsMatchError == false &&
                            self.displayUsernameFormatError == false &&
                            self.displayPasswordFormatError == false &&
                            self.displayUsernameError == false { // the user does not exist so try to create the account
                               
                            if self.password == self.confirmPassword { // the passwords match, create the account
                                   
                                   self.ref = db.collection("User").addDocument( data: [
                                       "First_Name": self.firstName,
                                       "Last_Name": self.lastName,
                                       "ID": 0,
                                       "Username": self.username,
                                       "Password": BCryptSwift.hashPassword(self.password, withSalt: salt)
                                       
                                   ])
                                   print(self.ref!.documentID)
                                   // ACCOUNT IS NOW CREATED
                                   
                                   self.mode.wrappedValue.dismiss()
                                   
                               } else { // the passwords did not match, do not create the account
                                   self.displayPasswordsMatchError = true
                               }
                               
                           } else { // the user does exist display new username error
                               self.displayUsernameError = true
                           }
                           
                    } // end of if-else
                    
               } // end of db query
            }
               
               
    } //end of process-input
    
    
    
    func isUsernameValid(username: String) -> Bool {

        let usernameRegexPattern = "(?=.*[a-zA-Z0-9]).{5,20}" // "(?=.*[a-zA-Z0-9]).{5,20}"
        // letters and numbers and less than 20 characters long

        var isValid:Bool?

        let doesItMatch = NSPredicate(format: "SELF MATCHES %@", usernameRegexPattern).evaluate(with: username)
        if doesItMatch == false {
            isValid = false
        } else {
            isValid = true
        }
        
        return isValid!
    } // end of isUsernameValid()
    
    
    func isPasswordValid(password: String) -> Bool {

        let passwordRegexPattern = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        // one upper case letter, one lower case, one digit and 8 characters long

        var isValid:Bool?

        let doesItMatch = NSPredicate(format: "SELF MATCHES %@", passwordRegexPattern).evaluate(with: password)
        if doesItMatch == false {
            isValid = false
        } else {
            isValid = true
        }

        return isValid!
        
    } // end of isPasswordValid()
    
    func isPasswordMatch(passwordOne: String, passwordTwo: String) -> Bool {
        var doesMatch:Bool?
        if passwordOne == passwordTwo {
            doesMatch = true
        } else {
            doesMatch = false
        }
        return doesMatch!
    }
    
    var body: some View {
        return AnyView(
            NavigationView {
                Form {
                    Section(header: Text("Name")) {
                        TextField("First Name", text: $firstName)
                        TextField("Last Name", text: $lastName)
                    }
                    
                    Section(header: Text("Username")) {
                        TextField("Username", text: $username)
                    }
                  
                    Section(header: Text("Password")) {
                        SecureField("Password", text: $password)
                        SecureField("Confirm Password", text: $confirmPassword)
                    }
                    
                    if displayPasswordsMatchError == true {
                        Text("The passwords did not match!")
                        .foregroundColor(Color.red)
                    }
                    
                    if displayUsernameError == true {
                        Text("That username already exists!")
                        .foregroundColor(Color.red)
                    }

                    if displayUsernameFormatError == true {
                        Text("The username must contain between 5-20 characters (only digits and letters allowed).")
                        .foregroundColor(Color.red)
                    }
                    
                    if  displayPasswordFormatError == true {
                        Text("Password must contain an uppercase letter, lowercase letter, a number, and be at least 8 characters long.")
                        .foregroundColor(Color.red)
                    }
                    
                    //Create button
                    Button(action: {
                        self.processInput()
                    }) {
                        Text("Create Account")
                    } // end of button
                
                
                } //end of form
                .navigationBarTitle(Text("Create Account"))
            } //end of NavigationView
        ) // end of AnyView
    } // end of body
} // end of CreateAccountView



/*
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
*/



