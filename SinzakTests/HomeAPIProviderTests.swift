//
//  HomeAPIProviderTests.swift
//  SinzakTests
//
//  Created by Doy Kim on 2023/02/07.
//

import XCTest
import Moya
import RxSwift
import RxMoya
import RxTest

@testable import Sinzak

enum APIError: Error {
    case decodingFailed
}
class HomeViewModel {
    let homeObservable: Single<HomeNotLogined>
    init(provider: MoyaProvider<HomeAPI>) {
        homeObservable = provider.rx.request(.homeNotLogined)
            .map { response -> HomeNotLogined in
                guard let user = try? JSONDecoder().decode(HomeNotLogined.self, from: response.data) else {
                    throw APIError.decodingFailed
                }
                print("@@@@", user)
                return user
            }

    }
}

final class HomeAPIProviderTests: XCTestCase {
    let schedular = TestScheduler(initialClock: 0)
    var provider = MoyaProvider<HomeAPI>()
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testFetchBanner_success() throws {
        let promise = expectation(description: "배너 정보가 올 때까지 기다리기")

        provider.request(.banner) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(BannerList.self, from: response.data)
                    print(data)
                    let expectedData = BannerList(data: [], success: true)
                    XCTAssert(data.success, "Success")
                    promise.fulfill()
                } catch {
                    XCTFail("API call failed with error: \(error)")
                }
            case .failure(let error):
                XCTFail("API call failed with error: \(error)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    func testFetchHomeNotLogined_success() throws {
        let promise = expectation(description: "홈 정보가 올 때까지 기다리기")

        provider.request(.homeNotLogined) { result in
            switch result {
            case .success(let response):
                do {
                    let decoder = JSONDecoder()
                    let data = try decoder.decode(HomeNotLogined.self, from: response.data)
                    print(data)
                    XCTAssertNotNil(data)
                    promise.fulfill()
                } catch {
                    XCTFail("API call failed with error: \(error)")
                }
            case .failure(let error):
                XCTFail("API call failed with error: \(error)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    func testRxSingleAndHomeRequest() throws {
        let promise = expectation(description: "홈 정보가 올 때까지 기다리기")
        let disposeBag = DisposeBag()
        // let provider = MoyaProvider<HomeAPI>(plugins: [])
        let homeObservable: Single<HomeNotLogined> = provider.rx.request(.homeNotLogined)
            .map { response -> HomeNotLogined in
                guard let user = try? JSONDecoder().decode(HomeNotLogined.self, from: response.data) else {
                    throw APIError.decodingFailed
                }
                return user
            }
        homeObservable.subscribe { result in
            switch result {
            case let .success(data):
                print("🌈🌈🌈🌈", data)
                XCTAssertNotNil(data)
            case let .failure(error):
                print("🥲🥲🥲🥲", error)
            }
            promise.fulfill()
        }
        .disposed(by: disposeBag)
        wait(for: [promise], timeout: 5)
    }
    func testHomeViewModel() throws {
        let schedular = TestScheduler(initialClock: 0)
        let viewModel = HomeViewModel(provider: provider)
        let disposeBag = DisposeBag()
        var homeNotLogined: HomeNotLogined?
        print("🍀🍀🍀", viewModel.homeObservable)
        let homeObserver = schedular.createObserver(HomeNotLogined.self)
        schedular.scheduleAt(0) {
            viewModel.homeObservable.subscribe(onSuccess: { data in
                print("🍕🍕🍕", data)
                homeNotLogined = data
                homeObserver.onNext(data)
                // Update UI
            }, onFailure: { error in
                homeObserver.onError(error)
                XCTFail("Received unexpected error: \(error)")
                // Handle error
            })
        }
        schedular.start()

        // Then
        print(homeObserver.events, "💕", homeNotLogined)
        XCTAssertNotNil(homeObserver.events)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
