//
//  SearchResultViewController.swift
//  MusicApp
//
//  Created by 이가을 on 3/27/24.
//

import UIKit

final class SearchResultViewController: UIViewController {
    
    // 컬렉션뷰 (테이블뷰와 유사)
    @IBOutlet weak var collectionView: UICollectionView!
    
    // 컬렉션뷰의 레이아웃을 담당하는 객체
    let flowLayout = UICollectionViewFlowLayout()
    
    // 네트워크 매니저 (싱글톤)
    let networkManager = NetworkManager.shared
    
    // (음악 데이터를 다루기 위함) 빈배열로 시작
    var musicArrays: [Music] = []
    
    // (서치바에서) 검색을 위한 단어를 담는 변수 (전화면에서 전달받음)
    var searchTerm: String? {
        didSet {
            setDatas()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setCollectionView()
    }
    

    func setCollectionView() {
    
        collectionView.dataSource = self
        
        collectionView.backgroundColor = .white
        flowLayout.scrollDirection = .vertical // 컬렉션뷰의 스크롤 방향 설정
        
        let collectionCellWidth = (UIScreen.main.bounds.width - CVCell.spacingWitdh * (CVCell.cellColumns - 1)) / CVCell.cellColumns // 각 아이템(셀)의 넓이 설정
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth) // 아이템 사이 간격 설정
        flowLayout.minimumInteritemSpacing = CVCell.spacingWitdh // 아이템 위아래 사이 간격 설정
        flowLayout.minimumLineSpacing = CVCell.spacingWitdh
        
        // 컬렉션뷰의 속성에 할당
        collectionView.collectionViewLayout = flowLayout
        
    }
    
    // 데이터 셋업
    func setDatas() {
        // 옵셔널 바인딩
        guard let term = searchTerm else { return }
        print("\(term)")
        
        // (네트워킹 시작전에) 다시 빈배열로
        self.musicArrays = []
        
        // 네트워킹 시작 (찾고자하는 단어를 가지고)
        networkManager.fetchMusic(searchTerm: term) { result in
            switch result {
            case .success(let musicDatas):
                self.musicArrays = musicDatas // 결과를 배열에 담고
                DispatchQueue.main.async { // 컬렉션뷰를 리로드 (메인쓰레드에서)
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("ERROR " + error.localizedDescription)
            }
        }
    }

}

extension SearchResultViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicArrays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cell.musicCollectionViewCellIdentifier, for: indexPath) as! MusicCollectionViewCell
        
        cell.imageUrl = musicArrays[indexPath.row].imageUrl
        
        return cell
    }

}
