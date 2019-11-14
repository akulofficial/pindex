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
    @State var displayFirstNameError:Bool = false
    @State var displayLastNameError:Bool = false
    
    
    func processInput() {
            displayPasswordsMatchError = false
            displayUsernameFormatError = false
            displayPasswordFormatError = false
            displayUsernameError = false
            displayLastNameError = false
            displayFirstNameError = false
            
        
             //var nameRegex = "[^A-Za-z]{2,}$"
            //displayFirstNameError =  !NSPredicate(format: "firstName == %@" , nameRegex).evaluate(with: firstName)
            //displayLastNameError =  !NSPredicate(format: "lastName == %@" , nameRegex).evaluate(with: lastName)
           var passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d\\W]{8,}$"
           displayPasswordFormatError =  !NSPredicate(format: "SELF MATCHES %@" , passwordRegex).evaluate(with: password)
            var userNameRegex = "[^A-Za-z0-9]{5,}$"
            displayUsernameFormatError = !NSPredicate(format: "SELF MATCHES %@", userNameRegex).evaluate(with: username)
            //print("displayPasswordFormatError: \(displayPasswordFormatError)")
            
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
                            self.displayUsernameError == false &&
                            self.displayLastNameError == false &&
                            self.displayFirstNameError == false { // the user does not exist so try to create the account
                               
                            if self.password == self.confirmPassword { // the passwords match, create the account
                                   
                                   self.ref = db.collection("User").addDocument( data: [
                                       "First_Name": self.firstName,
                                       "Last_Name": self.lastName,
                                       "ID": 0,
                                       "Username": self.username,
                                       "Password": self.password
                                       
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
               
               
    }
    
    func checkPasswordFormat() {
        
    }
    
    func checkUsernameFormat() {
        
    }
    
    
    var body: some View {
        let stack = VStack{
            
            
             Text("Create Account")
                 .font(.title)
             
            TextField("First Name", text: $firstName)
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                trailing: 10 ))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 8)
            
            TextField("Last Name", text: $lastName)
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                trailing: 10 ))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 8)
            
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
            
            SecureField("confirm password", text: $confirmPassword)
            .padding(EdgeInsets(top: 8, leading: 10, bottom: 8,
                                trailing: 10 ))
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 8)
            
            if displayUsernameError == true {
                Text("That username already exists!")
                .foregroundColor(Color.red)
            }
            
//            if displayPasswordFormatError == true {
//                Text("Password must contain an uppercase letter, lowercase letter, a number, and a special character")
//                .foregroundColor(Color.red)
//            }

            if displayUsernameFormatError == true {
                Text("The username must contain at least 5 characters.")
                .foregroundColor(Color.red)
            }
            
            if displayPasswordsMatchError == true {
                Text("The passwords did not match!")
                .foregroundColor(Color.red)
            }
            
            //Create button
            Button(action: {
                
                self.processInput()
                
            }) {
                Text("Create Account")
            }
            
            
            
        }
        return stack
    }
}



struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
