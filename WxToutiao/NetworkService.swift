//
//  NetworkService.swift
//  WxToutiao
//
//  Created by chenxi on 2017/9/22.
//  Copyright © 2017年 chenxi. All rights reserved.
//

import Foundation
import Moya

enum NetworkService {
    case category
    case showCateNewsList(id: Int)
    case submitComment(postId: Int, name: String, email: String, content: String)
}

extension NetworkService: TargetType {
    
    var baseURL: URL {
        return URL(string:"http://localhost:8888/wordpress/api")!
    }
    
    var path: String {
        switch self {
        case .category:
            return "/get_category_index"
        case .showCateNewsList:
            return "/get_category_posts"
        case .submitComment:
            return "/respond/submit_comment"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .category, .showCateNewsList, .submitComment:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .category:
            return .requestPlain
        case let .showCateNewsList(id):
            return .requestParameters(parameters: ["id": id], encoding: URLEncoding.default)
        case let .submitComment(postId, name, email, content):
            return .requestParameters(parameters: ["post_id": postId, "name": name, "email": email, "content": content], encoding: URLEncoding.default)
        
        }
    }
    
    var sampleData: Data {
        switch self {
        case .category:
            return "category test data".utf8Encoded
        case .showCateNewsList(let id):
            return "newslist id is \(id)".utf8Encoded
        case .submitComment(let postId, let name, let email, let content):
            return "\(postId),\(name),\(email),\(content)".utf8Encoded
        }
    }
    
    var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
}

// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
