//
//  HomeViewModelTest.swift
//  iOSTestScalioTests
//
//  Created by Sharjeel Ali on 21/12/2021.
//

import XCTest
import Foundation
@testable import iOSTestScalio

final class HomeViewModelTest: XCTestCase {
    
    private enum Constants {
        static let sampleTextToSearch = "User101"
        static let sampleTextBeforeOnNext = "Test"
        static let sampleTextAfterOnNext = "Sample"
        static let pageCount = 1
        static let perPageItem = 9
        static let indexPathToShow = IndexPath(row: 7, section: 0)
        static let pageCountAfterLoadNextBadge = 2
    }
    
    var viewModel : HomeViewModel!
    var view : HomeViewController!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func setupViewModel(withfailure bool: Bool = false) {
        
        // Setup view-model
        let router = MockHomeRouter()
        let networkService = MockHomeServices(withFailure: bool)
        viewModel = HomeViewModel(network: networkService, router: router)
    }
    
    func testViewDidLoad() {
        
        // Test before binding, searchQuery should be empty.
        viewModel.searchText.onNext(Constants.sampleTextBeforeOnNext)
        XCTAssert(viewModel.searchQuery.isEmpty)
        
        // Bind values
        viewModel.viewDidLoad()
        
        // Test After binding, searchQuery should not be empty.
        viewModel.searchText.onNext(Constants.sampleTextAfterOnNext)
        XCTAssertEqual(viewModel.searchQuery, Constants.sampleTextAfterOnNext)
    }
    
    func testDidTapOnSearch() {
        
        viewModel.viewDidLoad()
        
        viewModel.searchText.onNext(Constants.sampleTextToSearch)
        viewModel.searchEndEditing.onNext(())
        
        XCTAssertEqual(viewModel.searchQuery, Constants.sampleTextToSearch)
        XCTAssertEqual(viewModel.pageIndex, Constants.pageCount)
        
        guard let items = try? viewModel.items.value()
        else { return XCTFail("Unable to get the item from pre-define json") }
        
        XCTAssertEqual(items.count, Constants.perPageItem)
        
        // Test fisrt and last item as if someone hard code
        // the name then it should be well tested.
        XCTAssertEqual(items.first?.userName, "kmustriver")
        XCTAssertEqual(items.last?.userName, "mgurdal")
        
        XCTAssertEqual(viewModel.showLoading.value, true)
        
        viewModel.displayCell.onNext(Constants.indexPathToShow)
        
        XCTAssertEqual(viewModel.pageIndex, Constants.pageCountAfterLoadNextBadge)
    }
    
    func testDidTapOnSearchWhenNoResultFound() {
        
        // set viewmodel for failure case
        setupViewModel(withfailure: true)
        viewModel.didTapOnSearch()
        
        guard let items = try? viewModel.items.value()
        else { return XCTFail("Unable to get the value") }
        
        // If there is failure then it should be 0.
        XCTAssertEqual(items.count, 0)
    }

}

