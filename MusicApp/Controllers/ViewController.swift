//
//  ViewController.swift
//  MusicApp
//
//  Created by 이가을 on 3/25/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - property
    @IBOutlet weak var musicTableView: UITableView!
    
    var networkManager = NetworkManager.shared // 네트워크 매니저 (싱글톤)
    var musicArrays: [Music] = []     // 음악 데이터 (빈 배열로 시작)
    
    // 방법 - 1) 서치 컨트롤러 생성 => 네비게이션 아이템에 할당
    // let searchController = UISearchController()
    
    // 방법 - 2) 서치 result 컨트롤러 => 검색할 때 해당 뷰컨(SearchResultViewController)을 보여줌
    let searchController = UISearchController(searchResultsController: UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchResultViewController") as! SearchResultViewController)
    

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchBar()
        setTableView()
        setDatas()
    }
    
    
    // MARK: - set searchBar
    func setSearchBar(){
        self.title = "Search Music"

        navigationItem.searchController = searchController
        
        // 방법 - 1) (단순) 서치바 사용
        //searchController.searchBar.delegate = self
        
        // 방법 - 2) 서치(결과) 컨트롤러의 사용 (복잡한 구현 가능)
        // => 글자마다 검색 기능 + 새로운 화면을 보여주는 것도 가능
        searchController.searchResultsUpdater = self
        searchController.searchBar.autocapitalizationType = .none // 첫글자 대문자 X
    }
    
    // MARK: - set tableView
    func setTableView(){
        musicTableView.delegate = self
        musicTableView.dataSource = self
        
        // nib파일을 사용한다면 등록의 과정이 필요함 ⭐️
        musicTableView.register(UINib(nibName: Cell.musicCellIdentifier, bundle: nil), forCellReuseIdentifier: Cell.musicCellIdentifier)
    }
    
    // MARK: - set datas
    func setDatas() {
        networkManager.fetchMusic(searchTerm: "love") { result in
            print(#function)
            
            switch result {
            case .success(let musicData):
                self.musicArrays = musicData // 클로저 내부에서는 self로 명시
                DispatchQueue.main.async { // 네트워킹 작업은 메인스레드가 아닌 다른 스레드에서 비동기적으로 동작하기 때문에, 화면을 바꾸는 작업은 메인 스레드에서 동작하게 해줘야 함 ⭐️
                    self.musicTableView.reloadData() // 성공적으로 가져온 데이터로 테이블 뷰 리로드
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = musicTableView.dequeueReusableCell(withIdentifier: Cell.musicCellIdentifier, for: indexPath) as! MusicCell
        
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        cell.songNameLabel.text = musicArrays[indexPath.row].songName
        cell.artistNameLabel.text = musicArrays[indexPath.row].artistName
        cell.albumNameLabel.text = musicArrays[indexPath.row].albumName
        cell.releaseDateLabel.text = musicArrays[indexPath.row].releaseDateString
        
        cell.selectionStyle = .none
        
        return cell
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

// 방법 - 1) (단순) 서치바 사용 시 델리게이트
extension ViewController: UISearchBarDelegate {
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print(#function + " \(searchText)")
//        
//        self.musicArrays = [] // 한 글자씩 입력될 때 마다 새로운 검색 결과 보여주기 위해 빈 배열로 만들어 줌
//        
//        // 네트워킹 (입력한 문자열로 검색)
//        networkManager.fetchMusic(searchTerm: searchText) { result in
//            print(#function)
//            
//            switch result {
//            case .success(let musicData):
//                self.musicArrays = musicData
//                DispatchQueue.main.async {
//                    self.musicTableView.reloadData()
//                }
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
}


// 방법 - 2) 서치(결과) 컨트롤러의 사용 시 델리게이트
extension ViewController: UISearchResultsUpdating {
    
    // 유저가 글자를 입력하는 순간마다 호출되는 메서드 => 일반적으로 다른 화면을 보여줄 때 구현
    func updateSearchResults(for searchController: UISearchController) {
        // 글자를 입력하는 순간에 다른 화면을 보여주고 싶다면 (컬렉션 뷰를 보여줌)
        let vc = searchController.searchResultsController as! SearchResultViewController
        vc.searchTerm = searchController.searchBar.text ?? "" // 다른 화면(컬렉션 뷰)에 검색한 단어 전달
    }

}
