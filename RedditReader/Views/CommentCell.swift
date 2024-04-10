//
//  CommentCell.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import SwiftUI

struct CommentCell: View {
    let comment: Comment
    let avatarColors: [Color] = [.blue, .green, .orange, .pink, .purple, .red, .yellow]

    var body: some View {
        HStack {
            // Avatar Circle
            VStack(alignment: .leading) {
                Circle()
                    .fill(avatarColors.randomElement() ?? .gray)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(comment.author.first!).uppercased())
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    )
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(comment.authorFullname)
                        .fontWeight(.bold)
                    Text("•")
                    Text(Comment.getTimeAgo(from: comment.created_utc))
                }
                .font(.system(size: 16))
                .padding(.bottom, 8)
                
                Text(comment.body)
                    .lineLimit(5)
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 16)
                
                HStack {
                    Button(action: {}) {
                        Image(systemName: "arrowshape.up")
                    }
                    Text(String(comment.rating))
                        .fontWeight(.semibold)
                    Button(action: {}) {
                        Image(systemName: "arrowshape.down")
                    }
                }
                .frame(height: 40)
                .font(.system(size: 15))
                .foregroundStyle(.black)
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    CommentCell(comment: Comment(from: PurpleChild(kind: "Listing", data: PurpleData(
        downs: 0,
        name: "5nitgn",
        ups: 5,
        authorFullname: "JohnDoe123",
        permalink: "/r/ios/comments/1be9yha/iphone_photo_locked_folder/kurz5fv/",
        created_utc: 1711413528,
        parentId: nil,
        body: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque dictum fermentum tortor, non imperdiet neque tincidunt et. Suspendisse potenti. Donec vestibulum, mauris sed congue eleifend, nibh turpis consectetur est, non.",
        author: "John Doe",
        children: []
    )))!)
}
