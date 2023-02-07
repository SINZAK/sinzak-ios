//
//  HomeAPIProviderTests.swift
//  SinzakTests
//
//  Created by Doy Kim on 2023/02/07.
//

import XCTest
import Moya
@testable import Sinzak

final class HomeAPIProviderTests: XCTestCase {
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
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
