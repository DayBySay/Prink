import XCTest
import LinkPresentation
@testable import Prink

final class PrinkTests: XCTestCase {
    func testOnMemoryRepositoryMetadataDefaultNil() {
        let repository: PrinkRepository = OnMemoryRepository()
        let result =  repository.metadata(url: URL(string: "https://example.com")!)
        XCTAssertEqual(result, nil)
    }
    
    func testOnMemoryRepositoryMetadataStore() {
        let repository: PrinkRepository = OnMemoryRepository()
        let metadata = LPLinkMetadata()
        let url = URL(string: "https://example.com")!
        metadata.url = url
        
        let b = repository.store(metadata: metadata)
        XCTAssertTrue(b)
        
        let result =  repository.metadata(url: url)
        XCTAssertEqual(result, metadata)
    }

    static var allTests = [
        ("testOnMemoryRepositoryMetadataDefaultNil", testOnMemoryRepositoryMetadataDefaultNil),
        ("testOnMemoryRepositoryMetadataStore", testOnMemoryRepositoryMetadataStore),
    ]
}
