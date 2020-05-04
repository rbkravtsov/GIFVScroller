//
//  TJournalClient.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

final class TJournalClient {
    
    private lazy var baseURL: URL = {
        URL(string: "https://api.tjournal.ru/v1.8/")!
    }()
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchContent(with request: ContentRequest, page: Int, completion: @escaping (Result<ContentResponse, DataResponseError>) -> ()) {
        let urlPath = baseURL.appendingPathComponent(request.path(subsiteID: NetworkConstants.subsiteID, sorting: .new))
        let urlRequest = URLRequest(url: urlPath)
        let onPage = NetworkConstants.onPage
        let parameters = ["count": String(onPage),"offset": String(page * onPage)].merging(request.parameters, uniquingKeysWith: +)
        let encodedURLRequest = urlRequest.encode(with: parameters)
        session.dataTask(with: encodedURLRequest, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.hasSuccessCode,
                let data = data
            else {
                completion(Result.failure(DataResponseError.network))
                return
            }
            
            guard let decodedResponse = try? JSONDecoder().decode(ContentResponse.self, from: data) else {
                completion(Result.failure(DataResponseError.decoding))
                return
            }
            
            completion(Result.success(decodedResponse))
            }).resume()
    }
}
