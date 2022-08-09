//
//  ViewController.swift
//  SeSAC2Week6
//
//  Created by 강민혜 on 8/8/22.
//

import UIKit
import Alamofire
import SwiftyJSON



/*
 TableView automaticDimension
 - 컨텐츠 양에 따라서 셀 높이가 자유롭게
 - 조건1: 레이블 numberOfLines 0
 - 조건2: automaticDimension
 - 조건3: 레이아웃
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var blogList: [String] = []
    var cafeList: [String] = []
    
    var isExpanded = false // false면 2줄, true면 0줄
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension // 모든 섹션과 셀에 대해서 유동적으로 잡겠다는 의미
        
        searchBlog()
        
    }
    
    
    
    func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "고래밥") { json in
            
            for item in json["documents"].arrayValue {
                self.blogList.append(item["contents"].stringValue)
            }
            
            self.searchCafe()
        }
        
    }
   
    func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "떡볶이") { json in
            
            for item in json["documents"].arrayValue {
                
                let value = item["contents"].stringValue.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                
                self.cafeList.append(value)
            }
            
            print(self.blogList)
            print(self.cafeList)
            
            // 데이터를 다 받은시점에 갱신해줘야 함!
            self.tableView.reloadData()
            
        }
        
    }
    
    
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        isExpanded = !isExpanded
        tableView.reloadData()
        
    }
    
    
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "kakaoCell", for: indexPath) as? kakaoCell else { return UITableViewCell() }
        
        cell.testLabel.numberOfLines = isExpanded ? 0 : 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}

class kakaoCell: UITableViewCell {
    
    @IBOutlet weak var testLabel : UILabel!
    
}


