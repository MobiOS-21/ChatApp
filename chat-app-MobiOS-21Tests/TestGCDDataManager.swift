//
//  TestGCDDataManager.swift
//  chat-app-MobiOS-21Tests
//
//  Created by Александр Дергилёв on 11.12.2021.
//

import XCTest
@testable import chat_app_MobiOS_21

class TestGCDDataManager: XCTestCase {
    private let userProfile: ProfileModel = ProfileModel(userName: "test", userDecription: "test", userAvater: Data())
    
    func testWriteProfile() {
        let expectation = expectation(description: "AsyncExpectation")
        let fileManagerMock = ProfileFileManagerMock()
        let gcd = GCDDataService(fileManager: fileManagerMock)
        
        gcd.saveData(profile: userProfile) { status in
            switch status {
            case .success:
                expectation.fulfill()
            case .error:
                XCTFail("Save error")
            }
        }
        waitForExpectations(timeout: 3) { _ in
            // Assets
            XCTAssertEqual(fileManagerMock.numberOfCalls, 1)
            XCTAssertEqual(fileManagerMock.currentProfile?.userName, self.userProfile.userName)
        }
    }
    
    func testWriteAndReadProfile() {
        let expectation = expectation(description: "AsyncExpectation")
        let fileManagerMock = ProfileFileManagerMock()
        let gcd = GCDDataService(fileManager: fileManagerMock)
        
        gcd.saveData(profile: userProfile) { status in
            switch status {
            case .success:
                break
            case .error:
                XCTFail("Save error")
            }
        }
        
        gcd.readData { status in
            switch status {
            case .success:
                expectation.fulfill()
            case .error:
                XCTFail("Read error")
            }
        }
        
        waitForExpectations(timeout: 3) { _ in
            // Assets
            XCTAssertEqual(fileManagerMock.numberOfCalls, 2)
            XCTAssertEqual(fileManagerMock.currentProfile?.userName, self.userProfile.userName)
        }
    }
}
