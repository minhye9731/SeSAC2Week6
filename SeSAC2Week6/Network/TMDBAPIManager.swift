//
//  TMDBAPIManager.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/10/22.
//

import Foundation

import Alamofire
import SwiftyJSON


class TMDBAPIManager {
    
    static let shared = TMDBAPIManager()
    
    private init() { }
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    let seasonURL = "https://api.themoviedb.org/3/tv/135157/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
        print(#function)
        
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"
        
        // Alamofire -> URLSession Framework -> 비동기로 Request
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                // json still_path > [String]
                
                // 방법1)
//                var stillArray: [String] = []
//                for list in json["episodes"].arrayValue {
//
//                    let value = list["still_path"].stringValue
//                    stillArray.append(value)
//                }
                
                // 방법2)
                let value = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                
//                dump(stillArray) // print vs dump
//                dump(self.tvList)
//                print(value)
                
                completionHandler(value)
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        var posterList: [[String]] = []
        
        // 첫 번째 구문에서만 tvlist에 self 안붙임. 바깥에서는 괜찮은데, completionhandler 안에서는 self.를 붙여서 구분해줘야 함
        // 나~~~중에 배울 것: async/await(iOS13 이상)
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
}





