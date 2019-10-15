//
//  ContentView.swift
//  Pindex
//
//  Created by Akul Gulrajani on 9/29/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI
import FacebookLogin

struct ContentView: View {
    
    @State var FBLoginText: String = "Facebook Login"
    
    var body: some View {
        
        VStack {
            // Inserting FB login button
            Button(action: {loginToFB()}) {
                Text(FBLoginText)
            } // end of Button
        } // end of VStack
        
    } // end of body
} // end of ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func loginToFB() {
    
} // end of loginToFB()
