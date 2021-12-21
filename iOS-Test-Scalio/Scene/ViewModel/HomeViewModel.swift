//
//  HomeViewModel.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import Foundation
import RxSwift
import RxRelay

protocol HomeViewModelProtocol {
    
    var pageIndex: Int { get }
    var searchQuery: String { get }
    
    // MARK: Data Variables 
    var searchText: BehaviorSubject<String> { get set }
    var searchEndEditing: PublishSubject<Void> { get set }
    var handleError: PublishSubject<String> { get set }
    var displayCell: PublishSubject<IndexPath> { get set }
    var showLoading: BehaviorRelay<Bool> { get set }
    var items: BehaviorSubject<[UserCellViewModel]> { get set }
    
    // MARK: View life cycle
    func viewDidLoad()
    
    // MARK: Public Methods
    func didTapOnSearch()
    
}

final class HomeViewModel: HomeViewModelProtocol {
    
    private struct HomeVMConstant {
        static var NoResultMessage =
        "Sorry, No result found for this search query."
    }
    
    var items: BehaviorSubject<[UserCellViewModel]>
    
    private let homeService: HomeServiceProtocol
    private let router: HomeRouterProtocol
    private var _pageIndex: Int
    private var _searchQuery: String
    
    internal var showLoading: BehaviorRelay<Bool>
    internal var handleError: PublishSubject<String>
    internal var searchText: BehaviorSubject<String>
    internal var searchEndEditing: PublishSubject<Void>
    internal var displayCell: PublishSubject<IndexPath>
    private let disposeBag: DisposeBag
    
    var pageIndex: Int {
        get {
            return _pageIndex
        }
    }
    
    var searchQuery: String {
        get {
            return _searchQuery
        }
    }

    // MARK: Initializer
    init(network: HomeServiceProtocol, router: HomeRouterProtocol) {
        self.homeService = network
        self.router = router
        self.searchText = BehaviorSubject<String>(value: "")
        self.searchEndEditing = PublishSubject<Void>()
        self.handleError = PublishSubject<String>()
        self.displayCell = PublishSubject<IndexPath>()
        self.showLoading = BehaviorRelay<Bool>(value: true)
        self._pageIndex = 1
        self._searchQuery = ""
        self.items = BehaviorSubject<[UserCellViewModel]>(value: [])
        self.disposeBag = DisposeBag()
    }
    
    // MARK: Public methods to interact with View
    func viewDidLoad() {
        bindVM()
    }
        
    func didTapOnSearch() {
        // Reset this to initial value as tap on search button
        _pageIndex = 1
        loadData()
    }
}

// MARK: Private Methods
extension HomeViewModel {
    
    // Method to bind View
    func bindVM() {
        searchText.asObservable().subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self._searchQuery = value
        }).disposed(by: disposeBag)
        
        searchEndEditing.asObserver().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.didTapOnSearch()
        }).disposed(by: disposeBag)
        
        displayCell.asObserver().subscribe(onNext: { [weak self] indexPath in
            guard let self = self,
                  let value = try? self.items.value(),
                  indexPath.row <= value.count - 2 else { return }
            self.loadNextBatch()
        }).disposed(by: disposeBag)
        
    }
    
    // Method to bind View
    func loadNextBatch() {
        _pageIndex += 1
        loadData()
    }
    
    func loadData() {
        
        let queryRequest = SearchRequest(searchQuery: _searchQuery, page: _pageIndex)
        loadData(requestParam: queryRequest)
    }
    
    func loadData(requestParam: SearchRequest) {
        showLoading.accept(false)
        homeService.search(requestParam: requestParam) { [weak self] (result) in
            guard let self = self else { return }
            self.showLoading.accept(true)
            switch result {
            case .success(let response):
                self.handleSuccess(data: response)
            case .failure(let error):
                self.handleError(error: error)
            }
        }
    }
    
    func handleSuccess(data: SearchResultResponse) {
        
        guard data.items.count > 0 else {
            handleError.onNext(HomeVMConstant.NoResultMessage)
            items.onNext([])
            return
        }
        
        // If page index is 1 then append direclty,
        // otherwise need to append the previous data.
        if _pageIndex == 1 {
            items.onNext(data.items.map{ UserCellViewModel(data: $0)})
        } else if var value = try? items.value() {
            value = value + data.items.map{ UserCellViewModel(data: $0)}
            items.onNext(value)
        }
    }
    
    func handleError(error: Error) {
        handleError.onNext(error.localizedDescription)
    }
}
