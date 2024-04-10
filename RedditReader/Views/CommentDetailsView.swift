//
//  CommentDetailsView.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import SwiftUI

struct CommentDetailsView: View {
    let comment: Comment
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(comment.authorFullname)
                    .fontWeight(.bold)
                Text("•")
                Text(Comment.getTimeAgo(from: comment.created_utc))
            }
            .font(.system(size: 16))
            .padding(.bottom, 8)
            Text(comment.body)
            .padding(.bottom, 8)
            Text("Rating: \(comment.rating)")
                .fontWeight(.semibold)
                .padding(.bottom, 8)
            ShareLink("Share", item: URL(string: "https://reddit.com\(comment.url)")!)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 44)
            .font(.system(size: 16))
            .foregroundStyle(.black)
            .background(Color("ratingButtonColor"))
            .cornerRadius(15)
            Spacer()
        }
        .padding(.top, 8)
        .padding(.horizontal, 16)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .navigationBarTitle("", displayMode: .inline)
    }
}

//#Preview {
//    CommentDetailsView()
//}
