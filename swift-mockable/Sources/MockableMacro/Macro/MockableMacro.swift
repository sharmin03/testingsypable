import SwiftSyntax
import SwiftSyntaxMacros

public enum MockableMacro: PeerMacro {
    private static let extractor = Extractor()
    private static let mockGenerator = MockGenerator()

    public static func expansion(
        of node: AttributeSyntax,
        providingPeersOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let protocolDeclaration = try extractor.extractProtocolDeclaration(from: declaration)

        let mockClassDeclaration = mockGenerator.classDeclaration(for: protocolDeclaration)

        return [DeclSyntax(mockClassDeclaration)]
    }
}




/*
protocol BookingParametersManager: AnyObject {
  var bookingParametersDirectoryPublisher: AnyPublisher<BookingParametersDirectory, Never> { get }
  var bookingParametersDirectory: BookingParametersDirectory { get }
}


// sourcery: mock_inline
class MockBookingParametersManager: BookingParametersManager {
  // sourcery:inline:MockBookingParametersManager.mock
  // swiftlint:disable all


  // MARK: - Booking parameters directory publisher

  var invokedBookingParametersDirectoryPublisherGetter = false
  var invokedBookingParametersDirectoryPublisherGetterCount = 0
  var invokedBookingParametersDirectoryPublisherGetterExpectation: XCTestExpectation?
  var invokedBookingParametersDirectoryPublisherGetterExpectations = [XCTestExpectation]()
  var stubbedBookingParametersDirectoryPublisherGetterBody: (() -> AnyPublisher<BookingParametersDirectory, Never>)?
  var stubbedBookingParametersDirectoryPublisherResult: AnyPublisher<BookingParametersDirectory, Never>!

  var bookingParametersDirectoryPublisher: AnyPublisher<BookingParametersDirectory, Never> {
    get {
      invokedBookingParametersDirectoryPublisherGetter = true
      invokedBookingParametersDirectoryPublisherGetterCount += 1
      invokedBookingParametersDirectoryPublisherGetterExpectation?.fulfill()
      invokedBookingParametersDirectoryPublisherGetterExpectations.isEmpty ? () : invokedBookingParametersDirectoryPublisherGetterExpectations.removeFirst().fulfill()
      return stubbedBookingParametersDirectoryPublisherGetterBody?() ?? stubbedBookingParametersDirectoryPublisherResult
    }
  }


  // MARK: - Booking parameters directory

  var invokedBookingParametersDirectoryGetter = false
  var invokedBookingParametersDirectoryGetterCount = 0
  var invokedBookingParametersDirectoryGetterExpectation: XCTestExpectation?
  var invokedBookingParametersDirectoryGetterExpectations = [XCTestExpectation]()
  var stubbedBookingParametersDirectoryGetterBody: (() -> BookingParametersDirectory)?
  var stubbedBookingParametersDirectoryResult: BookingParametersDirectory!

  var bookingParametersDirectory: BookingParametersDirectory {
    get {
      invokedBookingParametersDirectoryGetter = true
      invokedBookingParametersDirectoryGetterCount += 1
      invokedBookingParametersDirectoryGetterExpectation?.fulfill()
      invokedBookingParametersDirectoryGetterExpectations.isEmpty ? () : invokedBookingParametersDirectoryGetterExpectations.removeFirst().fulfill()
      return stubbedBookingParametersDirectoryGetterBody?() ?? stubbedBookingParametersDirectoryResult
    }
  }


  // MARK: - Reset mock

  func resetMock() {
    invokedBookingParametersDirectoryPublisherGetter = false
    invokedBookingParametersDirectoryPublisherGetterCount = 0
    invokedBookingParametersDirectoryPublisherGetterExpectation = nil
    invokedBookingParametersDirectoryPublisherGetterExpectations = [XCTestExpectation]()
    stubbedBookingParametersDirectoryPublisherResult = nil
    invokedBookingParametersDirectoryGetter = false
    invokedBookingParametersDirectoryGetterCount = 0
    invokedBookingParametersDirectoryGetterExpectation = nil
    invokedBookingParametersDirectoryGetterExpectations = [XCTestExpectation]()
    stubbedBookingParametersDirectoryResult = nil
  }
  // sourcery:end
}



protocol OfferDetailsInteracting: Interacting {
  func handleViewDidLoad(_ request: OfferDetailsModel.ViewDidLoad.Request)
  func handleClose(_ request: OfferDetailsModel.Close.Request)
}

// sourcery:mock_inline
class MockOfferDetailsInteractor: OfferDetailsInteracting {
  // sourcery:inline:MockOfferDetailsInteractor.mock
  // swiftlint:disable all


  // MARK: - View did load

  var invokedHandleViewDidLoad = false
  var invokedHandleViewDidLoadCount = 0
  var invokedHandleViewDidLoadParameters: (request: OfferDetailsModel.ViewDidLoad.Request, Void)?
  var invokedHandleViewDidLoadParameterList: [(request: OfferDetailsModel.ViewDidLoad.Request, Void)] = [(request: OfferDetailsModel.ViewDidLoad.Request, Void)]()
  var invokedHandleViewDidLoadExpectation: XCTestExpectation?
  var invokedHandleViewDidLoadExpectations = [XCTestExpectation]()
  var stubbedHandleViewDidLoadResult: Void = ()
  var stubbedHandleViewDidLoadBody: ((_ request: OfferDetailsModel.ViewDidLoad.Request) -> Void)?

  func handleViewDidLoad(_ request: OfferDetailsModel.ViewDidLoad.Request) {
    invokedHandleViewDidLoad = true
    invokedHandleViewDidLoadCount += 1
    invokedHandleViewDidLoadParameters = (request: request, ())
    invokedHandleViewDidLoadParameterList.append((request: request, ()))
    invokedHandleViewDidLoadExpectation?.fulfill()
    invokedHandleViewDidLoadExpectations.isEmpty ? () : invokedHandleViewDidLoadExpectations.removeFirst().fulfill()
    if let body = stubbedHandleViewDidLoadBody {
      return body(request)
    } else {
      return stubbedHandleViewDidLoadResult
    }
  }


  // MARK: - Close

  var invokedHandleClose = false
  var invokedHandleCloseCount = 0
  var invokedHandleCloseParameters: (request: OfferDetailsModel.Close.Request, Void)?
  var invokedHandleCloseParameterList: [(request: OfferDetailsModel.Close.Request, Void)] = [(request: OfferDetailsModel.Close.Request, Void)]()
  var invokedHandleCloseExpectation: XCTestExpectation?
  var invokedHandleCloseExpectations = [XCTestExpectation]()
  var stubbedHandleCloseResult: Void = ()
  var stubbedHandleCloseBody: ((_ request: OfferDetailsModel.Close.Request) -> Void)?

  func handleClose(_ request: OfferDetailsModel.Close.Request) {
    invokedHandleClose = true
    invokedHandleCloseCount += 1
    invokedHandleCloseParameters = (request: request, ())
    invokedHandleCloseParameterList.append((request: request, ()))
    invokedHandleCloseExpectation?.fulfill()
    invokedHandleCloseExpectations.isEmpty ? () : invokedHandleCloseExpectations.removeFirst().fulfill()
    if let body = stubbedHandleCloseBody {
      return body(request)
    } else {
      return stubbedHandleCloseResult
    }
  }


  // MARK: - Reset mock

  func resetMock() {
    invokedHandleViewDidLoad = false
    invokedHandleViewDidLoadCount = 0
    invokedHandleViewDidLoadParameters = nil
    invokedHandleViewDidLoadParameterList = [(request: OfferDetailsModel.ViewDidLoad.Request, Void)]()
    invokedHandleViewDidLoadExpectation = nil
    invokedHandleViewDidLoadExpectations = [XCTestExpectation]()
    stubbedHandleViewDidLoadResult = ()
    stubbedHandleViewDidLoadBody = nil
    invokedHandleClose = false
    invokedHandleCloseCount = 0
    invokedHandleCloseParameters = nil
    invokedHandleCloseParameterList = [(request: OfferDetailsModel.Close.Request, Void)]()
    invokedHandleCloseExpectation = nil
    invokedHandleCloseExpectations = [XCTestExpectation]()
    stubbedHandleCloseResult = ()
    stubbedHandleCloseBody = nil
  }


  // sourcery:end
}

*/
