//
//  KituraTest.swift
//  NoteWikiTests
//
//  Created by Liam on 10/11/18.
//  Copyright © 2018 Liam Rosenfeld. All rights reserved.
//

import XCTest
import Kitura
import HeliumLogger
import KituraNet

import Dispatch
import Foundation

@testable import NoteWiki

class NoteWikiTest: XCTestCase {
    private static let initOnce: () = {
        HeliumLogger.use()
    }()

    override func setUp() {
        NoteWikiTest.initOnce
    }

    override func tearDown() {
    }

    func performServerTest(asyncTasks: (XCTestExpectation) -> Void...) {
        do {
            let app = App()
            try app.postInit()
            let router = app.router
            Kitura.addHTTPServer(onPort: 8080, with: router)
            Kitura.start()
        } catch {
            XCTFail("Failed to create server")
            return
        }

        let requestQueue = DispatchQueue(label: "Request queue")

        for (index, asyncTask) in asyncTasks.enumerated() {
            let expectation = self.expectation(index)
            requestQueue.async {
                asyncTask(expectation)
            }
        }

        waitExpectation(timeout: 10) { error in
            // blocks test until request completes
            Kitura.stop()
            XCTAssertNil(error)
        }
    }

    func performRequest(_ method: String,
                        path: String,
                        expectation: XCTestExpectation,
                        headers: [String: String]? = nil,
                        requestModifier: ((ClientRequest) -> Void)? = nil,
                        callback: @escaping (ClientResponse) -> Void) {
        var allHeaders = [String: String]()
        if  let headers = headers {
            for  (headerName, headerValue) in headers {
                allHeaders[headerName] = headerValue
            }
        }
        if allHeaders["Content-Type"] == nil {
            allHeaders["Content-Type"] = "text/plain"
        }
        let options: [ClientRequest.Options] =
            [.method(method), .hostname("localhost"), .port(8080), .path(path), .headers(allHeaders)]
        let req = HTTP.request(options) { response in
            guard let response = response else {
                XCTFail("response object is nil")
                expectation.fulfill()
                return
            }
            callback(response)
        }
        if let requestModifier = requestModifier {
            requestModifier(req)
        }
        req.end()
    }
    func expectation(_ index: Int) -> XCTestExpectation {
        let expectationDescription = "\(type(of: self))-\(index)"
        return self.expectation(description: expectationDescription)
    }

    func waitExpectation(timeout t: TimeInterval, handler: XCWaitCompletionHandler?) {
        self.waitForExpectations(timeout: t, handler: handler)
    }



    typealias BodyChecker =  (String) -> Void

    func checkResponse(response: ClientResponse,
                       expectedResponseText: String? = nil,
                       expectedStatusCode: HTTPStatusCode = HTTPStatusCode.OK,
                       bodyChecker: BodyChecker? = nil) {
        XCTAssertEqual(response.statusCode, expectedStatusCode, "No success status code returned")
        if let optionalBody = try? response.readString(), let body = optionalBody {
            if let expectedResponseText = expectedResponseText {
                XCTAssertEqual(body, expectedResponseText, "mismatch in body")
            }
            bodyChecker?(body)
        } else {
            XCTFail("No response body")
        }
    }

    
}
