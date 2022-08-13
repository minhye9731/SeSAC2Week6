//
//  MainViewController.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/9/22.
//

import UIKit

import Kingfisher

/*
 <key point>
 Tableview - collectionview > 프로토콜
 tag
 
 */

/*
 awakeFromNib
 - 셀 UI 초기화, 재사용 메커니즘에 의해 일정 횟수 이상 호출되지 않음.
 
 cellForItemAt
 - 재사용 될 때마다, 사용자에게 보일 때 마다 항상 실행됨
 - 화면과 데이터는 별개, 모든 indexPath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있음
 
 prepareForReuse
 - 셀이 재사용 될 때 초기화 하고자 하는 값을 넣으면 오류를 해결할 수 있음.
 - 즉, cellForRowAt에서 모든 indexPath.item에 대한 조건을 작성하지 않아도 됨!
 
 CollectionView in TableView
 - 하나의 컬렉션뷰나 테이블뷰라면 문제 X
 - 복합적인 구조라면, 테이블셀도 재사용 되어야 하고 컬렉션셀도 재사용이 되어야 함
 - Index > reloadData
 
 - print, Debug
 */


class MainViewController: UIViewController {

    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var mainTableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .lightGray, .yellow, .black]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](55...75),
        [Int](5000...5006),
        [Int](81...90)
        ]
    
    var episodeList: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true //  device width
        
        TMDBAPIManager.shared.requestImage { value in
            dump(value)
            //1. 네트워크 통신 2.배열 생성 3. 배열 담기
            //4. 뷰 등에 표현
                // ex. 테이블뷰 섹션, 컬렉션 뷰
            // 뷰 갱신!
            self.episodeList = value
            self.mainTableView.reloadData()
        }
    }
    
}

// MARK: - tableview 설정
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print(#function)
        
        // 내부 매개변수 tableview를 통해 테이블뷰를 특정
        // 테이블뷰 객체가 하나 일 경우에는 내부 매개변수를 활용하지 않아도 문제가 생기지 않는다.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell() }
        
        
        print("MainTableViewCell", #function, indexPath)
        cell.backgroundColor = .yellow
        cell.titleLabel.text = "\(TMDBAPIManager.shared.tvList[indexPath.section].0) 드라마 다시보기"
        
        cell.contentCollectionView.backgroundColor = .lightGray
        cell.contentCollectionView.delegate = self
        cell.contentCollectionView.dataSource = self
        cell.contentCollectionView.tag = indexPath.section // 섹션별 색상 다르게 설정하려고 tag를 준다. 각 셀 구분 짓기!
        cell.contentCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        cell.contentCollectionView.reloadData() // Index Out of Range 해결!
        //그리고 셀의 갯수가 적어서 재사용될 일이 없을 때에도 reload없이도 에러가 안남
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return indexPath.section == 3 ? 350 : 190
        return 240
    }
}

// 하나의 프로토콜, 메서드에서 여러 컬렉션뷰의 delegate, datasource 구현해야 함
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        print(#function)
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        
        if collectionView == bannerCollectionView {
        cell.cardView.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            cell.cardView.backgroundColor = .red
            cell.cardView.posterImageView.backgroundColor = .black
            cell.cardView.posterImageView.contentMode = .scaleAspectFill
            cell.cardView.contentLabel.textColor = .white
//            cell.cardView.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
            
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardView.posterImageView.kf.setImage(with: url)
            
            cell.cardView.contentLabel.text = ""
            
        }
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
    }
}


