//
//  BulletinBoardView.swift
//  Pindex
//
//  Created by Jake Taylor on 11/2/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI


struct BulletinBoardView: View {
    @State var showingPostView = false
    @Binding var mapAction: Int?

    var body: some View {
        VStack {
            Text("Bulletin Board Stuff Here")
            ScrollView {
                Text("posts here")
            }
            Button(action: {
                self.showingPostView.toggle()
            }) {
                Text("Make Post")
                .padding(EdgeInsets(top: 8, leading: 10, bottom: 20,
                trailing: 10 ))
            }.sheet(isPresented: $showingPostView) {
                PostView()
            }
        }
        .onDisappear(perform: {
            self.mapAction = 0 // resetting so that the user may tap the annotation again
            needToCenterLocation = true // resetting so that the map centers back on the user when the view swithces back
        })
    }
    
    
} // end of BulletinBoardView

/*
struct BulletinBoardView_Previews: PreviewProvider {
    static var previews: some View {
        BulletinBoardView(mapAction: <#Binding<Int>#>)
    }
}
*/
