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
    
    @State var data: String = "PLACEHOLDER"
    @State var ref: DocumentReference? = nil
    @State var firstName = ""
    @State var lastName = ""
    @State var username = ""
    @State var password = ""
    @State var confirmPassword = ""
    @State var displayUsernameError:Bool = false
    @State var displayPasswordsMatchError:Bool = false
    
    
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
            
            if displayPasswordsMatchError == true {
                Text("The passwords did not match!")
                .foregroundColor(Color.red)
            }
            
            //Create button
            Button(action: {
                
                self.displayPasswordsMatchError = false
                self.displayUsernameError = false
                
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
                            
                            if userExists == false { // the user does not exist so try to create the account
                                
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
                                    
                                    
                                    
                                } else { // the passwords did not match, do not create the account
                                    self.displayPasswordsMatchError = true
                                }
                                
                            } else { // the user does exist display new username error
                                self.displayUsernameError = true
                            }
                            
                        } // end of if-else
                } // end of db query
                
                
                
            }) {
                Text("Create Account")
            }
            
            
            /*
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
 */
            
            
            
        }
        return stack
    }
}
struct CreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        CreateAccountView()
    }
}
