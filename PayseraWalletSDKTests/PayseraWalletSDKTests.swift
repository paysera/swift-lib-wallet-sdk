import Foundation
import XCTest
import PayseraCommonSDK
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

class PrintLogger: PSLoggerProtocol {
    func log(level: PSLoggerLevel, message: String) {
        print("\(level) \(message)")
    }
    
    func log(level: PSLoggerLevel, message: String, request: URLRequest) {
        print("\(level) \(message)")
    }
    
    func log(level: PSLoggerLevel, message: String, response: HTTPURLResponse) {
        print("\(level) \(message)")
    }
    
    func log(level: PSLoggerLevel, message: String, response: HTTPURLResponse, error: PSApiError) {
        print("\(level) \(message)")
    }
}

class PayseraWalletSDKTests: XCTestCase {
    private var client: WalletAsyncClient!
    private var authClient: OAuthAsyncClient!
    private var token: String!
    
    override func setUp() {
        super.setUp()
        
        let userCredentials = PSCredentials()
        userCredentials.accessToken = "change_me"
        userCredentials.macKey = "change_me"
        
        self.client = ClientsFactory.createWalletAsyncClient(
            credentials: userCredentials,
            publicWalletApiClient: ClientsFactory.createPublicWalletApiClient(),
            serverTimeSynchronizationProtocol: ServerTimeSynchronizationManager()
        )
        
        let appCredentials = PSCredentials()
        appCredentials.accessToken = "change_me"
        appCredentials.macKey = "change_me"
        
        self.authClient = ClientsFactory.createOAuthClient(
            credentials: appCredentials,
            publicWalletApiClient: ClientsFactory.createPublicWalletApiClient(),
            serverTimeSynchronizationProtocol: ServerTimeSynchronizationManager()
        )
    }

    func testGetUser() {
        var object: PSUser?
        let expectation = XCTestExpectation(description: "")
        
        client
            .getCurrentUser()
            .done { user in
                object = user
                print(object)
            }.catch { error in
                print(error)
            }.finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
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
        let fields = ["*", "wallet"]
        
        client.getProjectsWithFields(fields).done { projects in
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
    
    func testLogin() {
        var object: PSCredentials?
        let expectation = XCTestExpectation(description: "")
        let scopes = ["logged_in"]
        let userData = PSUserLoginRequest()
        userData.username = "change_me"
        userData.password = "change_me"
        userData.scopes = scopes
        userData.grantType = "password"
        authClient.loginUser(userData).done { res in
            object = res
        }.catch { error in
            print(error)
        }.finally { expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testGetProjectTransactions() {
        var object: [PSTransaction]?
        let expectation = XCTestExpectation(description: "")
        var parameters: [String: Any] = ["status": "confirmed,rejected,revoked"]
        parameters["limit"] = 100
        
        client.getProjectTransactions(id: 52487221, parameters: parameters).done { transactions in
            object = transactions.items
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testCreateTransactionInProject() {
        var object: PSTransaction?
        let expectation = XCTestExpectation(description: "")
        
        let payment = PSPayment()
        payment.price = 1
        payment.currency = "EUR"
        payment.paymentDescription = "aaa"
        let transaction = PSTransaction()
        transaction.payments = [payment]
        transaction.autoConfirm = false
        
        client.createTransactionInProject(transaction: transaction, projectId: 52487221, locationId: 7961).done { transaction in
            object = transaction
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testGetTransaction() {
        var object: PSTransaction?
        let expectation = XCTestExpectation(description: "")
        self.client.getTransaction(byKey: "change_me").done { transaction in
            object = transaction
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 3.0)
        XCTAssertNotNil(object)
    }
    
    func testConfirmTransaction() {
        var object: PSTransaction?
        let expectation = XCTestExpectation(description: "")
        
        self.client.getTransaction(byKey: "change_me").done { transaction in
            self.client.confirmTransaction(key: transaction.key, projectId: transaction.projectId!, locationId: transaction.locationId!).done { result in
                object = result
            }.catch { error in
                print(error)
            }.finally {expectation.fulfill()}
        }.catch { error in
            print(error)
        }
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(object)
    }
}
