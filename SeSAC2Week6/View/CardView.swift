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
        
        // 카드뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 false가 아닌 true로 나온다...
        // true. 오토레이아웃 적용이 되는 관점보다 오토리사이징 내부적으로 constraints 처리가 됨...
        print(view.translatesAutoresizingMaskIntoConstraints)
        // view의 레이아웃은 인터페이스 기반으로 ui로 잡아줬더라도
        // nib형태로 view를 등록하고, addsubview를 통해 화면에 등록을 해줬기 때문에 true로 나온다.
        // 이미지, 버튼, 레이블 등은 인터페이스 기반으로 Ui가 잘 잡혔지만, view자체는 레이아웃이 별도로 잡혀있는게 아니어서 오토리사이징 true처리가 됨.
    }
    
}
