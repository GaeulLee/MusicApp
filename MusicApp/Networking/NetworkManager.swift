//
//  NetworkManager.swift
//  MusicApp
//
//  Created by 이가을 on 3/26/24.
//

import Foundation

// MARK: - 네트워크에서 발생할 수 있는 에러 정의
enum NetworkError: Error {
    case networkingError
    case dataError
    case parseError
}

// MARK: - Networking 클래스 모델
class NetworkManager {
    
    // 싱글톤 패턴으로 설계
    static let shared = NetworkManager()
    private init() {} // 다른 곳에서 새로운 인스턴스 생성하지 못하도록 생성자 접근 제한
   
    typealias NetworkCompletion = (Result<[Music], NetworkError>) -> Void // 타입 정의(?)
    
    // 네트워킹 요청 (음악 데이터 가져오기)
    func fetchMusic(searchTerm: String, completion: @escaping NetworkCompletion) {
        let urlString = "\(MusicApi.requestUrl)\(MusicApi.mediaParam)&term=\(searchTerm)"
        print(urlString)
        
        performRequest(with: urlString) { result in
            completion(result)
        }
    }
    
    // 실제 Request히는 함수 (비동기적 실행 => 클로저 방식으로 끝난 시점을 전달 받도록 설계)
    private func performRequest(with urlStirng: String, completion: @escaping NetworkCompletion) {

        // URL구조체 만들기
        guard let url = URL(string: urlStirng) else { return }
        
//      guard let url = URL(string: "https://itunes.apple.com/search?media=music&term=love") else {
//          print("Error: cannot create URL")
//          completion(nil)
//          return
//      }
        
//      // URL요청 생성
//      var request = URLRequest(url: url)
//      request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { data, response, error in
            if error != nil {
                print(error!)
                completion(.failure(.networkingError))
                return
            }
            
            guard let safeData = data else {
                completion(.failure(.dataError))
                return
            }
            
            if let musics = self.parseJSON(safeData) {
                print("parse 실행")
                completion(.success(musics))
                
            } else {
                print("parse싪패")
                completion(.failure(.parseError))
            }
        }
        task.resume()
        
//        // 요청을 가지고 작업 세션 시작 (비동기적으로 동작됨 ⭐️)
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            // 에러가 없어야 넘어감
//            guard error == nil else {
//                print("Error: error calling GET")
//                print(error!)
//                completion(nil)
//                return
//            }
//            // 옵셔널 바인딩
//            guard let safeData = data else {
//                print("Error: Did not receive data")
//                completion(nil)
//                return
//            }
//            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
//            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
//                print("Error: HTTP request failed")
//                completion(nil)
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                let musicData = try decoder.decode(MusicData.self, from: safeData)
//                completion(musicData.results)
//                return
//            } catch {
//                
//            }
//        }.resume() // 시작 (까먹지 말기 ⭐️)
    }
    
    private func parseJSON(_ musicData: Data) -> [Music]? {
        do {
            let musicData = try JSONDecoder().decode(MusicData.self, from: musicData)
            return musicData.results
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
