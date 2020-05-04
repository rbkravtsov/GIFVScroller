//
//  ViewController.swift
//  GIFV Scroller
//
//  Created by Roman Kravtsov on 29.04.2020.
//  Copyright © 2020 Roman Kravtsov. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    // MARK: - Types

    // MARK: - Constants
    private struct Constants {
      static let contentCell = "ContentCell"
    }
    
    // MARK: - IBOutlets

    // MARK: - Public Properties
    
    // MARK: - Private Properties
    private var viewModel: FeedViewModel!
    
    private lazy var feedTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.allowsSelection = false        
        return tableView
    }()
    // MARK: - Initializers

    // MARK: - UIViewController(*)
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        setViewModel()
    }
    // MARK: - Public methods

    // MARK: - IBActions

    // MARK: - Private Methods
    private func setTableView() {
        view.addSubview(feedTableView)
        feedTableView.dataSource = self
        feedTableView.delegate = self
        feedTableView.prefetchDataSource = self
        feedTableView.isHidden = true
        
        feedTableView.register(ContentCell.self, forCellReuseIdentifier: Constants.contentCell)
        
        let constraints = [
            feedTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            feedTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            feedTableView.topAnchor.constraint(equalTo: view.topAnchor),
            feedTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setViewModel() {
        let request = ContentRequest.getRequest()
        viewModel = FeedViewModel(request: request, delegate: self)
        viewModel.fetchContent()
    }
    
    private func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = feedTableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        print("is loading cell - row: \(indexPath.row) current count: \(viewModel.currentCount)")
        return indexPath.row >= viewModel.currentCount
    }
}

extension FeedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 280
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ContentCell else { return }
        cell.playVideo()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? ContentCell else { return }
        cell.pauseVideo()
    }
}

extension FeedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contentCell, for: indexPath) as? ContentCell
        else {
            return UITableViewCell()
        }
        
        if isLoadingCell(for: indexPath) {
            cell.configure(with: nil)
        } else {
            cell.configure(with: viewModel.contentItem(at: indexPath.row))
        }        
        
        return cell
    }
}

extension FeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            viewModel.fetchContent()
        }
    }
}

extension FeedViewController: FeedViewModelDelegate {
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        guard let newIndexPathsToReload = newIndexPathsToReload else {
            feedTableView.isHidden = false
            feedTableView.reloadData()
            return
        }
        
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        feedTableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func onFetchFailed(with error: String) {
        print("something wrong i can feel it: \(error)")
    }
}

