//
//  ChildComment.swift
//  RedditReader
//
//  Created by Kristina Cherevko on 4/4/24.
//

import Foundation

struct MoreCommentsData: Codable {
    let jquery: [[Jquery]]
}

enum Jquery: Codable {
    case integer(Int)
    case string(String)
    case unionArray([JqueryJqueryUnion])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .integer(x)
            return
        }
        if let x = try? container.decode([JqueryJqueryUnion].self) {
            self = .unionArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Jquery.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Jquery"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .integer(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        case .unionArray(let x):
            try container.encode(x)
        }
    }
}

enum JqueryJqueryUnion: Codable {
    case bool(Bool)
    case jqueryClassArray([PurpleChild])
    case string(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Bool.self) {
            self = .bool(x)
            return
        }
        if let x = try? container.decode([PurpleChild].self) {
            self = .jqueryClassArray(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(JqueryJqueryUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JqueryJqueryUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .bool(let x):
            try container.encode(x)
        case .jqueryClassArray(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}
