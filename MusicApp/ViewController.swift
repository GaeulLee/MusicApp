//
//  ViewController.swift
//  MusicApp
//
//  Created by 이가을 on 3/25/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var musicTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        
    }

    func setTableView(){
        musicTableView.delegate = self
        musicTableView.dataSource = self
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}

extension ViewController: UITableViewDelegate {
    
    // set tableView height
    // musicTableView.rowHeight = 120 대신 사용 가능
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension // 셀 높이 자동 지정
//    }
    
}
