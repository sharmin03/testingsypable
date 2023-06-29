import XCTest
@testable import TestingSpyable

final class MaxTests: XCTestCase {
    var mockChapterLead: MockChapterLead!
    var sut: Max!

    override func setUp() {
        super.setUp()
        mockChapterLead = MockChapterLead()
        sut = Max(chapterLead: mockChapterLead)
    }

    func testTask_handleDiscoveryDialogueCalled_withoutArguements() {
        
        sut.task()
       
        XCTAssertTrue(mockChapterLead.handleDiscoveryDialogueCalled)
    }
    
    func testTask_handleDiscoveryDialogueCalled_withArguements() {
        
        let date = Date()
        sut.taskWithDate(date: date)
       
        XCTAssertTrue(mockChapterLead.handleDiscoveryDialogueDateCalled)
        XCTAssertEqual(mockChapterLead.handleDiscoveryDialogueDateReceivedDate, date)
    }
    
//    func testhandleDiscoveryDialogue_forFuture_shouldReturnFalse() {
//
//        let secondsInPast: TimeInterval = 86400  // For example, 1 day in future
//
//        // Create the past date
//        let futureDate = Date(timeIntervalSinceNow: secondsInPast)
//
//        let returnedValue = sut.handleDiscoveryDialogue(date: futureDate)
//
//        XCTAssertTrue(mockChapterLead.handleDiscoveryDialogueDateCalled)
//        XCTAssertEqual(mockChapterLead.handleDiscoveryDialogueDateReturnValue, returnedValue)
//    }
}

