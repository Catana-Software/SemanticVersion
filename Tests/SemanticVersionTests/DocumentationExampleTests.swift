import SemanticVersion
import XCTest

final class DocumentationExampleTests: XCTestCase {
    
    struct Book: Equatable, Codable {
        let name: String
        let version: SemVer
    }

    func testStringLiteral() {
        
        let version = SemVer("14.4.1")
        
        XCTAssertEqual(version?.major, 14)
        XCTAssertEqual(version?.minor, 4)
        XCTAssertEqual(version?.patch, 1)
        
    }
    
    func testCodable() throws {
        
        let book = Book(name: "Alice in Wonderland", 
                        version: SemVer("14.4.1")!)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let data = try encoder
            .encode(book)
        
        let string = String(data: data,
                            encoding: .utf8)!
        
        print(string)
        
        let decoded = try JSONDecoder()
            .decode(Book.self, from: data)
        
        XCTAssertEqual(decoded, book)
        
    }
    
    func testComparison() {
        
        let fourteenFourOne = SemVer("14.4.1")!
        let fourteenFourTwo = SemVer("14.4.2")!
        
        XCTAssertTrue(fourteenFourOne < fourteenFourTwo)
        XCTAssertTrue(fourteenFourTwo > fourteenFourOne)
        
    }

}
