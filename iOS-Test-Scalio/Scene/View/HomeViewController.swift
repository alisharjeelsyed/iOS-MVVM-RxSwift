//
//  HomeViewController.swift
//  iOS-Test-Scalio
//
//  Created by Sharjeel Ali on 10/12/2021.
//

import UIKit
import RxCocoa
import RxSwift

final class HomeViewController: UIViewController {
    
    private struct HomeViewConstants {
        static var userTableViewCell = "UserTableViewCell"
        static var alertTitle = "Ok"
    }
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var listTblView: UITableView!
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    
    private var viewModel: HomeViewModelProtocol!
    private let disposeBag = DisposeBag()
    
    private lazy var alert: UIAlertController = {
        var alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: HomeViewConstants.alertTitle, style: .default, handler: nil))
        return alert
    }()
    
    static func instantiate(viewModel: HomeViewModelProtocol) -> UIViewController {
        let viewController = HomeViewController.instantiate()
        viewController.viewModel = viewModel
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

private extension HomeViewController {
    
    func setup(){
        setUI()
        bindVM()
        bindTableView()
        viewModel.viewDidLoad()
    }
    
    func setUI(){
        listTblView.separatorStyle = .none
    }
    
    func bindVM() {
        
        searchBar.rx.text
            .orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        searchBar.rx
            .searchButtonClicked
            .bind(onNext: { [weak self] _ in
                self?.searchBar.resignFirstResponder()
                self?.viewModel.searchEndEditing.onNext(())
            })
            .disposed(by: disposeBag)
        
        viewModel
            .showLoading
            .asObservable()
            .observe(on: MainScheduler.instance)
            .bind(to: indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        viewModel
            .handleError
            .asObserver()
            .observe(on: MainScheduler.instance)
            .bind(onNext: { [weak self] (errorMessage) in
                guard let strongSelf = self else { return }
                strongSelf.alert.title = errorMessage
                strongSelf.present(strongSelf.alert, animated: true)
            })
            .disposed(by: disposeBag)
       
    }
    
    func bindTableView() {
                
        listTblView
            .registerCell(type: UserTableViewCell.self)
        
        viewModel
            .items
            .bind(to: listTblView.rx.items(cellIdentifier: HomeViewConstants.userTableViewCell, cellType: UserTableViewCell.self)) { (row,item,cell) in
            cell.configureWithModel(item)
        }.disposed(by: disposeBag)
        
        listTblView.rx
            .willDisplayCell
            .asObservable()
            .subscribe { [weak self] (cell, indexPath) in
                self?.viewModel.displayCell.onNext(indexPath)
        }.disposed(by: disposeBag)
        
    }
}
