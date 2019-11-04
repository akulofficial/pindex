//
//  PostView.swift
//  Pindex
//
//  Created by Jake Taylor on 11/3/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI

struct PostView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            Text("Post here")
            .navigationBarTitle("Make Post")
            .navigationBarItems(leading:
                Button("Post") {
                print("Making the post")
                self.presentationMode.wrappedValue.dismiss()
            }, trailing:
                Button("Cancel") {
                print("Cancelling Post")
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
