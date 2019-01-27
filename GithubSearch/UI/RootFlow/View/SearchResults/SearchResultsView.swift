//
//  SearchResultsView.swift
//  GithubSearch
//
//  Created by Misha Korchak on 1/27/19.
//  Copyright © 2019 Misha Korchak. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultsView: BaseView {
    
    // MARK: - Outlets
    
    @IBOutlet weak private(set) fileprivate var tableView: UITableView!
    
    // MARK: - Public properties
    
    var isLoading: Bool = false {
        didSet {
            self.isLoading ? self.showLoading() : self.hideLoading()
        }
    }
    
    var editable: Bool = true {
        didSet {
            self.tableView.dragInteractionEnabled = self.editable
            self.tableView.allowsSelection = self.editable
        }
    }
    
    private(set) fileprivate var itemsCount = intDummy
    
    // MARK: RegisterViewProtocol
    
    var view: UIView! {
        didSet {
            self.configure()
        }
    }
    
    // MARK: - Private properties
    
    private var disposeBag = DisposeBag()
    private var loadingView: UIView?
    fileprivate let deleteAction = PublishSubject<Int>()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self <- self.xibSetupView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self <- self.xibSetupView
    }
    
    // MARK: - Private methods
    
    private func showLoading() {
        if loadingView == nil {
            self.createLoadingView()
        }
        self.tableView.tableFooterView = self.loadingView
    }
    
    private func hideLoading() {
        self.tableView.tableFooterView = nil
    }
    
    private func createLoadingView() {
        self.loadingView = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: 50))
        let indicator = UIActivityIndicatorView()
        indicator.color = .lightGray
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.startAnimating()
        self.loadingView?.addSubview(indicator)
        indicator.center = self.loadingView?.center ?? .zero
        self.tableView.tableFooterView = loadingView
    }
}

// MARK: - SearchResultsView + RegisterViewProtocol

extension SearchResultsView: RegisterViewProtocol {
    func configure() {
        self.tableView.register(SearchResultCell.self)
        self.tableView.keyboardDismissMode = .onDrag
        self.tableView.dragInteractionEnabled = self.editable
        self.tableView.dragDelegate = self
        self.tableView.dropDelegate = self
        self.tableView.delegate = self
    }
}

// MARK: SearchResultsView + Drag/Drop, Delegate

extension SearchResultsView: UITableViewDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView,
                   editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        return self.editable ? [UITableViewRowAction(style: .destructive, title: "Delete", handler: { [weak self] _, indexPath in
            self?.tableView.beginUpdates()
            self?.deleteAction.onNext(indexPath.row)
            self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            self?.tableView.endUpdates()
        })] : []
    }
    
    func tableView(_ tableView: UITableView,
                   itemsForBeginning session: UIDragSession,
                   at indexPath: IndexPath) -> [UIDragItem] {
        return []
    }
    
    func tableView(_ tableView: UITableView,
                   performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
}

// MARK: - SearchResultsView + DataProviderProtocol

extension SearchResultsView: DataProviderProtocol {
    typealias DataType = Driver<[RepoViewModelData]>
    
    func set(data: Driver<[RepoViewModelData]>) {
        self.disposeBag = DisposeBag()
        data.do(onNext: { [weak self] in self?.itemsCount = $0.count })
            .drive(self
                .tableView
                .rx
                .items(cellIdentifier: SearchResultCell.reuseIdentifier,
                       cellType: SearchResultCell.self)) { (row, data, cell) in
                        cell.set(data: data)
            }.disposed(by: self.disposeBag)
    }
}

// MARK: - SearchResultsView + Rx accessors

extension Reactive where Base == SearchResultsView {
    var selectIndexAction: ControlEvent<Int> {
        return ControlEvent(
            events: self
                .base
                .tableView
                .rx
                .itemSelected
                .map { $0.row }
        )
    }
    
    var moveAction: ControlEvent<(fromIndex: Int, toIndex: Int)> {
        return ControlEvent(
            events: self
                .base
                .tableView
                .rx
                .itemMoved
                .map { ($0.sourceIndex.row, $0.destinationIndex.row) }
        )
    }
    
    var deleteIndexAction: ControlEvent<Int> {
        return ControlEvent(
            events: self
                .base
                .deleteAction
        )
    }
    
    var paginationAction: ControlEvent<Void> {
        return ControlEvent(
            events: self
                .base
                .tableView
                .rx
                .willDisplayCell
                .filter { [weak base = self.base] in $0.indexPath.row == ((base?.itemsCount ?? intDummy) - 1) }
                .map { _ in () }
        )
    }
}
