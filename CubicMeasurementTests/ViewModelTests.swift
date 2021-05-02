import XCTest
@testable import CubicMeasurement

final class ViewModelTests: XCTestCase {
    
    private var mockServiceStateDelegate: MockServiceDelegate!
    private var mockService: MockService!
    private var viewModel: ViewModel!
    
    override func setUp() {
        super.setUp()
        mockServiceStateDelegate = MockServiceDelegate()
        mockService = MockService()
        
    }
    
    override func tearDown() {
        super.tearDown()
        mockServiceStateDelegate = nil
        mockService = nil
        viewModel = nil
    }
    
   func testLoadingState() {
    viewModel = ViewModel()
    mockService.equipment = Equipments(objects: [Objects(category: "Air Conditioners", weight: 70.0, size: Size(width: 40.0, length: 40.0, height: 50.0))], next: "hi")
    viewModel.fetchData(service: mockService, uri: "")
    
    XCTAssertEqual(viewModel.state, .loading)
    
    }
    
    func testLoadingStateText() {
        viewModel = ViewModel()
        viewModel.fetchData(service: mockService, uri: "")
        
        XCTAssertEqual(viewModel.text, "Loading")
    }
    
    func testSuccessStateText() {
        viewModel = ViewModel()
        mockService.equipment = Equipments(objects: [Objects(category: "Air Conditioners", weight: 70.0, size: Size(width: 40.0, length: 40.0, height: 50.0))], next: nil)
        viewModel.fetchData(service: mockService, uri: "MockURI")
      
        XCTAssertEqual(viewModel.text, "Average Weight: 20.00")
    }
    
    func testSuccessStateEmptyObjects() {
        viewModel = ViewModel()
        mockService.equipment = Equipments(objects: [], next: nil)
        viewModel.fetchData(service: mockService, uri: "MockURI")
      
        XCTAssertEqual(viewModel.text, "Average Weight: 0.00")
    }
        
    func testFailureStateText() {
        viewModel = ViewModel()
        mockService.error = NSError(domain: "Domain", code: 0, userInfo: nil)
        viewModel.fetchData(service: mockService, uri: "MockURI")
      
        XCTAssertEqual(viewModel.text, "Failure")
    }
    
}

private final class MockServiceDelegate: ServiceDelegate {
    
    var didLodingCalled: Bool = false
    func didLoad(viewModel: ViewModel) {
        didLodingCalled = true
    }
    var didFailCalled: Bool = false
    func didFail(viewModel: ViewModel) {
        didFailCalled = true
    }
    var didSucceedCalled: Bool = false
    func didSucceed(viewModel: ViewModel) {
        didFailCalled = true
    }
}

private final class MockService: ServiceCallDelegate {
    
    var equipment: Equipments?
    var error: NSError?
    func makeServiceCall(to uri: String, completion: @escaping (Result<Equipments, NSError>) -> Void) {
        if let equipment = equipment {
            completion(.success(equipment))
        }
        
        if let error = error {
            completion(.failure(error))
        }
    }
    
    
}
