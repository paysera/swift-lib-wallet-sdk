import Foundation
import XCTest
import PayseraWalletSDK
import PromiseKit
import JWTDecode
import ObjectMapper

class ServerTimeSynchronizationManager: ServerTimeSynchronizationProtocol {
    func getServerTimeDifference() -> TimeInterval {
        return 0
    }

    func serverTimeDifferenceRefreshed(diff: TimeInterval) {
    }
}

class PayseraWalletSDKTests: XCTestCase {
    private var client: WalletAsyncClient!
    private var token: String!
    
    override func setUp() {
        super.setUp()
        
        let credentials = PSCredentials()
        credentials.accessToken = "change_me"
        credentials.macKey = "change_me"
        
        self.client = ClientsFactory.createWalletAsyncClient(
            credentials: credentials,
            publicWalletApiClient: ClientsFactory.createPublicWalletApiClient(),
            serverTimeSynchronizationProtocol: ServerTimeSynchronizationManager()
        )
    }
    
    func testGetSpotInformation() {
        var object: PSSpot?
        let expectation = XCTestExpectation(description: "")
        
        client
            .checkIn(spotId: 8488, fields: ["*", "orders.transaction"])
            .done { spot in
                object = spot
            }.catch { error in
                print(error)
            }.finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testGetProjects() {
        var object: [PSProject]?
        let expectation = XCTestExpectation(description: "")
        
        client.getProjects().done { projects in
            object = projects
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testGetProjectLocations() {
        var object: [PSLocation]?
        let expectation = XCTestExpectation(description: "")
        let id = 52487221
        
        client.getProjectLocations(id: id).done { locations in
            object = locations
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testGetLocations() {
        var object: [PSLocation]?
        let expectation = XCTestExpectation(description: "")
        let locationRequest = PSGetLocationsRequest()
        
        client.getLocations(locationRequest: locationRequest).done { locations in
            object = locations.items
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
}
