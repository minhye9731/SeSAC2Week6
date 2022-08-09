//
//  Endpoint.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/8/22.
//

import Foundation

enum Endpoint {
    
    case blog
    case cafe
    // 저장 프로퍼티를 못 쓰는 이유?
    // 인스턴스를 생성하지 못해서.
    
    // 연산 프로퍼티는 왜 사용이 가능한가?
    // 메서드처럼 작동해서
    
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
    
    
}
