//
//  CardView.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit

/*
 Xml Interface Builder
 1. UIView Custom Class 설정
 2. File's owner => 활용도 / 여러 View 제약
 - 사용 확장성이 조금 더 크다
 */

/*
 View:
 - 인터페이스 빌더 UI 초기화 구문 : required init?
   - 프로토콜 초기화 구문 : required > 초기화 구문이 프로토콜로 명세되어 있음
 - 코드 UI 초기화 구문 : override init
 */

protocol A {
    func example()
    init()
}


class CardView: UIView {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    // 이거 자동으로 뜨게 하는 에러 캡처 필요
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        
        view.frame = bounds
        view.backgroundColor = .lightGray
        self.addSubview(view)
    }
    
}
