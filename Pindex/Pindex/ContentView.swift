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

let loginButton = FBLoginButton(permissions: [ .publicProfile ])

struct ContentView: View {
    
    @State var FBLoginText: String = "Facebook Login"
    
    var body: some View {
        
        //loginButton.center = CGPoint(x: 0, y: 0)
        
        VStack {
            // Inserting FB login button
            
            
            
            Button(action: {loginToFB()}) {
                Text(FBLoginText)
            } // end of Button
        
        } // end of VStack
        //return body
    } // end of body
} // end of ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func loginToFB() {
    
} // end of loginToFB()
