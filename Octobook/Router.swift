//
//  Router.swift
//  Octobook
//
//  Created by Xue Yu on 5/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import Foundation
import Alamofire

enum URLs {
    static let exploreUrl = "https://www.gitbook.com/explore"
    static let authorUrl = "https://www.gitbook.com/@"
    static let readUrl = "https://www.gitbook.com/read"
    static let downloadUrl = "https://www.gitbook.com/download/epub/book/"
    
    static let searchBook = "https://www.gitbook.com/search?"
}


enum Router: URLRequestConvertible {
    
    
    case popularBooks(Int)
    case searchBooks(Int, String)
    
    
    func asURLRequest() throws -> URLRequest {
        
        var method: HTTPMethod{
            switch self {
            case .popularBooks, .searchBooks:
                return .get
            }
        }
        
        
        
        let url: URL = {
            switch self {
            case .popularBooks(let curPage):
                if curPage == 0{
                    return URL(string: URLs.exploreUrl)!
                } else {
                    return URL(string: "\(URLs.exploreUrl)?page=\(curPage)")!
                }
            case .searchBooks(let curPage, let searchText):
                if curPage == 0{
                    return URL(string: "\(URLs.searchBook)type=books&q=\(searchText)")!
                } else {
                    return URL(string: "\(URLs.searchBook)page=\(curPage)&type=books&q=\(searchText)")!
                }
            }
        }()
        
        
        let params: ([String: AnyObject]?) = {
            switch self {
            case .popularBooks, .searchBooks:
                return nil
            }
        }()
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        let encoding = JSONEncoding.default
        return try encoding.encode(urlRequest, with: params)
    }
    



    
}

