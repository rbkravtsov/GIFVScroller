//
//  FeedViewModel.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import Foundation

protocol FeedViewModelDelegate: class {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?)
    func onFetchFailed(with error: String)
}

final class FeedViewModel {
    private weak var delegate: FeedViewModelDelegate?
    
    private var content = [ContentItem]()
    private var currentPage = 0
    private var isFetchInProgress = false
    
    let client = TJournalClient()
    let request: ContentRequest
    
    init(request: ContentRequest, delegate: FeedViewModelDelegate) {
        self.request = request
        self.delegate = delegate
    }
    
    var currentCount: Int {
        content.count
    }
    
    func contentItem(at index: Int) -> ContentItem {
        content[index]
    }
    
    func fetchContent() {
        guard !isFetchInProgress else { return }
        
        isFetchInProgress = true
        client.fetchContent(with: request, page: currentPage, completion: { result in
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    self.delegate?.onFetchFailed(with: error.reason)
                }
            case .success(let response):
                DispatchQueue.main.async {
                    self.isFetchInProgress = false
                    
                    self.content += response.result
                    
                    if self.currentPage > 0 {
                        let indexPathToReload = self.calculateIndexPathsToReload(from: response.result)
                        self.delegate?.onFetchCompleted(with: indexPathToReload)
                    } else {
                        self.delegate?.onFetchCompleted(with: nil)
                    }
                    
                    self.currentPage += 1
                    
                }
            }
        })
        
    }
    
    private func calculateIndexPathsToReload(from newContent: [ContentItem]) -> [IndexPath] {
        let startIndex = content.count - newContent.count
        let endIndex = startIndex + newContent.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
}
