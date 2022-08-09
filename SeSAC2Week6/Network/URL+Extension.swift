//
//  URL+Extension.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/8/22.
//

import Foundation

extension URL {
    
    static let baseURL = "https://dapi.kakao.com/v2/search/"
    
    // 연산 프로퍼티로도 활용 가능
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }

}
