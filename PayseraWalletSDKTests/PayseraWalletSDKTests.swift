import XCTest
import PayseraAccountsSDK
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
        
        client.getProjects(fields).done { projects in
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
        
        let filter = PSTransactionFilter()
        filter.status = "confirmed,rejected,revoked"
        filter.from = String(format: "%.0f", Calendar.current.date(byAdding: .day, value: -14, to: Date())!.timeIntervalSince1970)
        filter.limit = 100
        filter.locationId = 0000
        filter.projectId = 0000
        
        client.getProjectTransactions(filter: filter).done { transactions in
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
        
        client.createTransaction(transaction: transaction, projectId: 52487221, locationId: 7961).done { transaction in
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
    
    func testDeleteTransaction() {
        var object: PSTransaction?
        let expectation = XCTestExpectation(description: "")
        
        self.client.deleteTransaction(key: "tc8Vmm6sregtdNWGdOvYJTgbatO1Ulcw").done { result in
            object = result
        }.catch { error in
            print(error)
        }.finally {expectation.fulfill()}
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(object)
    }
    
    func testRegisteringSubscriber() {
        let expectation = XCTestExpectation(description: "PSSubscriber should be created and given some id value")
        let subscriber = PSSubscriber()
        let recipient = PSSubscriberRecipient()
        recipient.identifier = "1337"
        subscriber.recipient = recipient
        subscriber.type = "firebase"
        subscriber.locale = "en"
        subscriber.privacyLevel = "low"
        subscriber.events = []
        
        XCTAssertNil(subscriber.id, "Initial subscriber shouldn't have any id")
        
        client
            .registerSubscriber(subscriber)
            .done { newSubscriber in
                XCTAssert(subscriber.recipient?.identifier == newSubscriber.recipient?.identifier, "Identifier should remain the same")
                XCTAssertNotNil(newSubscriber.id, "New subscriber should be given an ID")
            }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUpdatingSubscriber() {
        let originalLocale = "en"
        let updatedLocale = "lt"
        let expectation = XCTestExpectation(description: "PSSubscriber should be successfully updated")
        let subscriber = PSSubscriber()
        let recipient = PSSubscriberRecipient()
        recipient.identifier = "1337"
        subscriber.recipient = recipient
        subscriber.type = "firebase"
        subscriber.locale = originalLocale
        subscriber.privacyLevel = "low"
        subscriber.events = []
        
        client
            .registerSubscriber(subscriber)
            .compactMap { registeredSubscriber -> (PSSubscriber, Int)? in registeredSubscriber.id.map { (registeredSubscriber, $0) } }
            .then { (registeredSubscriber, registeredSubscriberID) -> Promise<(PSSubscriber, PSSubscriber)> in
                let modifiedSubscriber = registeredSubscriber.copy()!
                modifiedSubscriber.locale = updatedLocale
                return self.client.updateSubscriber(modifiedSubscriber, subscriberId: registeredSubscriberID).map { (registeredSubscriber, $0) }
            }
            .done { (registeredSubscriber, updatedSubscriber) in
                XCTAssert(registeredSubscriber.locale == originalLocale, "Original subscriber should have \(originalLocale) locale")
                XCTAssert(updatedSubscriber.locale == updatedLocale, "Updated subscriber should have new locale")
            }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetEvents() {
        var response: PSMetadataAwareResponse<PSEvent>?
        let expectation = XCTestExpectation(description: "Events according to given filter should be returned")
        let filter = PSEventsFilter()
        filter.limit = 5
        
        client
            .getEvents(filter: filter)
            .done { eventsResponse in response = eventsResponse }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testDeleteSubscriber() {
        var response: PSSubscriber?
        let expectation = XCTestExpectation(description: "After successful deletion of subscriber, disabled subscriber must be returned")
        let subscriberId = 1337
        
        client
            .deleteSubscriber(subscriberId: subscriberId)
            .done { subscriber in response = subscriber }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testDeleteSubscribers() {
        var response: [PSSubscriber]?
        let expectation = XCTestExpectation(description: "After successful deletion of subscribers, disabled subscribers must be returned")
        
        client
            .deleteSubscribers()
            .done { subscribers in response = subscribers }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }

    func testGetWalletStatements() {
        var response: PSMetadataAwareResponse<PSStatement>?
        let expectation = XCTestExpectation(description: "Statements must be non nil")
        let expectedStatementCount = 0 //insert me
        
        let walletId = 0 //insert me
        let filter = PSStatementFilter()
        filter.from = nil //insert me
        filter.to = nil //insert me
        filter.limit = nil //insert me
        filter.currency = nil //insert me
        filter.offset = nil //insert me
        client
            .getStatements(walletId: walletId, filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response?.items.count ?? 0, expectedStatementCount)
    }
    
    func testGettingCards() {
        var response: PSMetadataAwareResponse<PSCard>?
        let expectation = XCTestExpectation(description: "Cards according to the given filter should be returned")

        let filter = PSCardFilter()
        filter.userId = 1337
        filter.limit = 200
        filter.offset = 0
        
        client
            .getCards(filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testWalletDescriptionChange() {
        var response: PSWallet?
        let expectation = XCTestExpectation(description: "Wallet description should change")
        let walletId = 1337
        let newDescription = "I'm your father"
        
        client.getWallet(byId: walletId)
            .map { wallet -> String? in
                let oldDescription = wallet.accountInformation.accountDescription
                XCTAssertNotEqual(oldDescription, newDescription, "New wallet description should be different")
                return oldDescription
            }
            .then { oldDescription -> Promise<PSWallet> in
                self.client.changeWalletDescription(walletId: walletId, description: newDescription)
            }
            .done { updatedWallet in response = updatedWallet }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 10.0)
        XCTAssertEqual(response?.accountInformation.accountDescription, newDescription, "Account description should be equal to new description")
    }
    
    func testWalletDescriptionDeletion() {
        var response: PSWallet?
        let expectation = XCTestExpectation(description: "Wallet description should be deleted")
        let walletId = 1
        
        client.getWallet(byId: walletId)
            .get { wallet in
                XCTAssertNotNil(wallet.accountInformation.accountDescription, "Wallet should have a description")
            }
            .then { _ -> Promise<PSWallet> in
                self.client.deleteWalletDescription(walletId: walletId)
            }
            .done { updatedWallet in response = updatedWallet }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 10.0)
        XCTAssertNotNil(response?.accountInformation, "Wallet should contain account information")
        XCTAssertNil(response?.accountInformation.accountDescription, "Wallet description should be nil")
    }
    
    func testGetTransfer() {
        var response: PSTransfer?
        let expectation = XCTestExpectation(description: "Transfer should be returned")
        
        client
            .getTransfer(transferId: 346600911)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testTransferReservation() {
        var response: PSTransfer?
        let expectation = XCTestExpectation(description: "Transfer should be reserved")
        
        client
            .reserveTransfer(transferId: 346600911)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testTransferSigning() {
        var response: PSTransfer?
        let expectation = XCTestExpectation(description: "Transfer should be signed")
        
        client
            .signTransfer(transferId: 346600080)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testTransferCancellation() {
        var response: PSTransfer?
        let expectation = XCTestExpectation(description: "Transfer should be cancelled")
        
        client
            .cancelTransfer(transferId: 1)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testTransferUnlock() {
        var response: PSTransfer?
        let expectation = XCTestExpectation(description: "Transfer should be unlocked")
        
        client
            .unlockTransfer(transferId: 1, password: "l33t")
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testRegisterPhone() {
        var response: PSUser?
        let expectation = XCTestExpectation(description: "Phone should be assigned to the user")
        let userId = 1
        let phone = "37060000000"
        let scopes = ["confirmed_log_in_phone_code", "generator_phone_code"]
        
        client
            .sendPhoneVerificationCode(userId: userId, phone: phone, scopes: scopes)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testRegisterEmail() {
        var response: PSUser?
        let expectation = XCTestExpectation(description: "Email should be assigned to the user")
        let userId = 1
        let email = "l33t@gmail.com"
        
        client
            .sendEmailVerificationCode(userId: userId, email: email)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetPendingPayments() {
        var response: PSMetadataAwareResponse<PSPendingPayment>?
        let expectation = XCTestExpectation(description: "Pending payments should be returned")
        let walletId = 1
        let filter = PSBaseFilter()
        filter.offset = 0
        filter.limit = 10
        
        client
            .getPendingPayments(walletId: walletId, filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetReservationStatements() {
        var response: PSMetadataAwareResponse<PSReservationStatement>?
        let expectation = XCTestExpectation(description: "Reservation statements should be returned")
        let walletId = 1
        let filter = PSBaseFilter()
        filter.offset = 0
        filter.limit = 10
        
        client
            .getReservationStatements(walletId: walletId, filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testCancelPendingPayment() {
        var response: PSPendingPayment?
        let expectation = XCTestExpectation(description: "Pending payment should be cancelled")
        let walletId = 1
        
        client
            .cancelPendingPayment(walletId: walletId, pendingPaymentId: 2147785935)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGenerateCode() {
        var response: PSGeneratorResponse?
        let expectation = XCTestExpectation(description: "Generator should return a valid response")
        
        client
            .generateCode(scopes: ["confirmed_log_in"])
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testCreateGenerator() {
        var response: PSGenerator?
        let expectation = XCTestExpectation(description: "Generator should be created")
        let code = "000000"
        
        client
            .createGenerator(code: code)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetGenerator() {
        var response: PSGenerator?
        let expectation = XCTestExpectation(description: "Generator should be returned")
        let generatorId = 5861918
        
        client
            .getGenerator(generatorId: generatorId)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }

    func testProvidingUserPosition() {
        var response: PSUserPosition?
        let expectation = XCTestExpectation(description: "User position should be returned after successful submission")
        let position = PSUserPosition()
        position.latitude = 48.84913
        position.longitude = 2.33802
        position.type = "hidden"
        
        client
            .provideUserPosition(position)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(position.latitude, response?.latitude)
        XCTAssertEqual(position.longitude, response?.longitude)
        XCTAssertEqual(position.type, response?.type)
    }
    
    func testGetIdentificationRequests() {
        var response: PSMetadataAwareResponse<PSIdentificationRequest>?
        let expectation = XCTestExpectation(description: "Identification requests should be returned")
        let filter = PSIdentificationRequestsFilter()
        
        client
            .getIdentificationRequests(filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testCreateContactBook() {
        var response: PSContactBookResponse?
        let expectation = XCTestExpectation(description: "Contact book should be created")
        let request = PSContactBookRequest()
        
        client
            .createContactBook(request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response?.id)
    }
    
    func testAppendContactBook() {
        var response: PSContactBookResponse?
        let expectation = XCTestExpectation(description: "Contacts should be added to contact book")
        let contactBookId = 99149
        let request = PSContactBookRequest()
        request.emails = ["l33t@gmail.com"]
        request.emailHashes = ["81089566a41ab16bfc22e326247eb64ce8722a20"]
        
        client
            .appendContactBook(contactBookId: contactBookId, request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(contactBookId, response?.id, "Contact book id must be equal to updated book id")
    }
    
    func testDeleteFromContactBook() {
        let expectation = XCTestExpectation(description: "Contacts should be deleted")
        let contactBookId = 99149
        let request = PSContactBookRequest()
        request.emails = ["l33t@gmail.com"]
        request.emailHashes = ["81089566a41ab16bfc22e326247eb64ce8722a20"]
        
        client
            .deleteFromContactBook(contactBookId: contactBookId, request: request)
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCalculateCurrencyConversionWithFromAmount() {
        let expectation = XCTestExpectation(description: "Currency conversion should be calculated")
        var response: PSCurrencyConversion?
        
        let request = PSCurrencyConversion()
        request.fromCurrency = "EUR"
        request.toCurrency = "USD"
        request.fromAmountDecimal = "1.50"
        
        XCTAssertNil(response?.toAmountDecimal, "Response should not have toAmountDecimal set")
        
        client
            .calculateCurrencyConversion(request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response?.toAmountDecimal, "Response should have toAmountDecimal set")
    }
    
    func testCalculateCurrencyConversionWithToAmount() {
        let expectation = XCTestExpectation(description: "Currency conversion should be calculated")
        var response: PSCurrencyConversion?
        
        let request = PSCurrencyConversion()
        request.fromCurrency = "EUR"
        request.toCurrency = "USD"
        request.toAmountDecimal = "1.2"
        
        XCTAssertNil(response?.fromAmountDecimal, "Response should not have fromAmountDecimal set")
        
        client
            .calculateCurrencyConversion(request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response?.fromAmountDecimal, "Response should have fromAmountDecimal set")
    }
    
    func testCurrencyConversion() {
        let expectation = XCTestExpectation(description: "Currency conversion should be performed")
        var response: PSCurrencyConversionResponse?
        
        let request = PSCurrencyConversion()
        request.fromCurrency = "KZT"
        request.toCurrency = "INR"
        request.fromAmountDecimal = "0.1"
        request.accountNumber = "EVPXXXXXXXX"
        
        XCTAssertNil(response?.toAmountDecimal, "Response should not have toAmountDecimal set")
        
        client
            .convertCurrency(request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response?.toAmountDecimal, "Response should have toAmountDecimal set")
        XCTAssertNotNil(response?.date, "Response should have date set")
        XCTAssertNotNil(response?.id, "Response should have id set")
    }
    
    func testCurrencyConversionWithMinToAmount() {
        let expectation = XCTestExpectation(description: "Currency conversion should fail when min to amount is not satisfied")
        var error: PSApiError?
        
        let request = PSCurrencyConversion()
        request.fromCurrency = "KZT"
        request.toCurrency = "INR"
        request.fromAmountDecimal = "0.1"
        request.minToAmountDecimal = "0.1"
        request.accountNumber = "EVXXXXXXXXXX"
        
        client
            .convertCurrency(request: request)
            .done { _ in XCTFail("Conversion should fail") }
            .catch { error = $0 as? PSApiError }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(error, "Conversion should fail with an error")
        XCTAssertEqual(error?.description, "To amount is smaller than expected", "Appropriate error should be returned")
    }
    
    func testCurrencyConversionWithMaxFromAmount() {
        let expectation = XCTestExpectation(description: "Currency conversion should fail when max from amount is not satisfied")
        var error: PSApiError?
        
        let request = PSCurrencyConversion()
        request.fromCurrency = "KZT"
        request.toCurrency = "INR"
        request.toAmountDecimal = "0.1"
        request.maxFromAmountDecimal = "0.1"
        request.accountNumber = "EVXXXXXXXXXX"
        
        client
            .convertCurrency(request: request)
            .done { _ in XCTFail("Conversion should fail") }
            .catch { error = $0 as? PSApiError }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(error, "Conversion should fail with an error")
        XCTAssertEqual(error?.description, "From amount is larger than expected", "Appropriate error should be returned")
    }
    
    func testGetCodeInformation() {
        let expectation = XCTestExpectation(description: "Code information should be returned")
        var response: PSCodeInformation?
        let code = "PAYSERA*3500:COMPOSITE1"
        
        client
            .getCodeInformation(code: code)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testCreateCard() {
        let expectation = XCTestExpectation(description: "Card should be created")
        var response: PSCard?
        let userId = 1
        
        let account = PSCardAccount()
        account.number = "EVXXXXXXXXXX"
        account.order = 0
        
        let relation = PSCardRelation()
        relation.redirectBackUri = "test://card/related"
        
        let request = PSCardAccountRequest()
        request.accounts = [account]
        request.relation = relation
        
        client
            .createCard(userId: userId, request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetCard() {
        let expectation = XCTestExpectation(description: "Card should be returned")
        var response: PSCard?
        let cardId = 1164879
        
        client
            .getCard(cardId: cardId)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testDeleteCard() {
        let expectation = XCTestExpectation(description: "Card should be returned")
        let cardId = 1164879
        
        client
            .deleteCard(cardId: cardId)
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetTransfers() {
        let expectation = XCTestExpectation(description: "Transfers according to the given filter should be returned")
        var response: PSMetadataAwareResponse<PSTransfer>?
        let filter = PSTransferFilter()
        filter.creditAccountNumber = "EVPXXXXXXXXXXX"
        filter.limit = 20
        
        client
            .getTransfers(filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetUserServices() {
        let expectation = XCTestExpectation(description: "User services should be returned")
        var response: PSUserServiceResponse?
        let userId = 1
        
        client
            .getUserServices(userId: userId)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testEnableUserService() {
        let expectation = XCTestExpectation(description: "User service should be enabled")
        var response: PSUserService?
        let userId = 1
        let service = "affiliate"
        
        client
            .enableUserService(userId: userId, service: service)
            .done { response = $0 }
            .catch { error in
                XCTFail(error.localizedDescription)
            }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetConfirmations() {
        let expectation = XCTestExpectation(description: "Confirmations according to the given filter should be returned")
        var response: PSMetadataAwareResponse<PSConfirmation>?
        let filter = PSConfirmationFilter()
        filter.status = "waiting"
        
        client
            .getConfirmations(filter: filter)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testGetConfirmation() {
        let expectation = XCTestExpectation(description: "Confirmation with given identifier should be returned")
        var response: PSConfirmation?
        let identifier = "9ExARke12LrN4IY9gFv0mJUJ6LPUf2Jz"

        client
            .getConfirmation(identifier: identifier)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testRejectConfirmation() {
        let expectation = XCTestExpectation(description: "Confirmation should be rejected")
        var response: PSConfirmation?
        let identifier = "k1zrsWrH_88GVkimDC4ecbfmHbLGZBbu"
        
        client
            .getConfirmation(identifier: identifier)
            .get { confirmation in
                XCTAssertEqual(confirmation.status, "waiting", "Confirmation should be in waiting state before being rejected")
            }
            .then { _ in self.client.rejectConfirmation(identifier: identifier) }
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response?.status, "rejected", "Confirmation should be rejected")
    }
    
    func testConfirmConfirmation() {
        let expectation = XCTestExpectation(description: "Confirmation should be confirmed")
        var response: PSConfirmation?
        let identifier = "4cNYC1jog-Rmh9XVhz5GKZv6xJw1yGay"
        
        client
            .getConfirmation(identifier: identifier)
            .get { confirmation in
                XCTAssertEqual(confirmation.status, "waiting", "Confirmation should be in waiting state before being confirmed")
            }
            .then { _ in self.client.confirmConfirmation(identifier: identifier) }
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertEqual(response?.status, "confirmed", "Confirmation should be confirmed")
    }
    
    func testCreatingIdentificationRequest() {
        let expectation = XCTestExpectation(description: "Identification request should be created")
        var response: PSIdentificationRequest?
        let userId = 1
        
        client
            .createIdentificationRequest(userId: userId)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }

    func testCreatingIdentityDocument() {
        let expectation = XCTestExpectation(description: "Identity document should be created")
        var response: PSIdentityDocument?
        let request = PSIdentificationDocumentRequest()
        request.id = 4884446
        request.firstName = "Johny"
        request.lastName = "Appleseed"

        client
            .createIdentityDocument(request: request)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testSubmittingFacePhoto() {
        let expectation = XCTestExpectation(description: "Face photo should be uploaded")
        let requestId = 4884446
        let order = 0
        let imageData = Data()
        
        client
            .submitFacePhoto(requestId: requestId, order: order, data: imageData)
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSubmittingDocumentPhoto() {
        let expectation = XCTestExpectation(description: "Document photo should be uploaded")
        let documentId = 4536578
        let order = 0
        let imageData = Data()
        
        client
            .submitDocumentPhoto(documentId: documentId, order: order, data: imageData)
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testSubmittingIdentificationRequest() {
        let expectation = XCTestExpectation(description: "Identification request should be submitted")
        let requestId = 4884446
        
        client
            .submitIdentificationRequest(requestId: requestId)
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testUploadAvatar() {
        let expectation = XCTestExpectation(description: "Avatar should be uploaded")
        let imageData = Data()
        
        client
            .uploadAvatar(imageData: imageData)
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testDeleteAvatar() {
        let expectation = XCTestExpectation(description: "Avatar should be deleted")
        
        client
            .deleteAvatar()
            .done { _ in }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCreatingAuthToken() {
        let expectation = XCTestExpectation(description: "Auth token should be created")
        var response: PSAuthTokenResponse?
        
        client
            .createAuthToken()
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testCreatingTransfer() {
        let expectation = XCTestExpectation(description: "Transfer should be created")
        var response: PSTransfer?
        let transfer = PSTransfer()
        transfer.amount = PSMoney(amount: "0.01", currency: "EUR")
        
        transfer.payer = PSTransferPayer()
        transfer.payer.accountNumber = "EVP************"
        
        transfer.beneficiary = PSTransferBeneficiary()
        transfer.beneficiary?.name = "Name Surname"
        transfer.beneficiary?.type = "bank"
        transfer.beneficiary?.beneficiaryBankAccount = PSTransferBeneficiaryBankAccount()
        transfer.beneficiary?.beneficiaryBankAccount?.iban = "LT************"
        transfer.performAt = Date().timeIntervalSince1970 + 24 * 60 * 60
        transfer.purpose = PSTransferPurpose()
        transfer.purpose?.details = "Hello internet"

        client
            .createTransfer(transfer, isSimulated: false)
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response)
    }
    
    func testIssuingFirebaseToken() {
        let expectation = XCTestExpectation(description: "Firebase token should be issued")
        var response: PSFirebaseTokenResponse?
        
        client
            .issueFirebaseToken()
            .done { response = $0 }
            .catch { error in XCTFail(error.localizedDescription) }
            .finally { expectation.fulfill() }
        
        wait(for: [expectation], timeout: 5.0)
        XCTAssertNotNil(response?.token)
    }
}
