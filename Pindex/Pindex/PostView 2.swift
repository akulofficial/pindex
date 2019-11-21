//
//  PostView.swift
//  Pindex
//
//  Created by Jake Taylor on 11/3/19.
//  Copyright © 2019 Yeet. All rights reserved.
//

import SwiftUI

struct PostView: View {
    
    var post: Post
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Text(post.content)
        }
        .navigationBarTitle(post.title)
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post(title: "fakePost", content: "fakeContent", id: -1))
    }
}
