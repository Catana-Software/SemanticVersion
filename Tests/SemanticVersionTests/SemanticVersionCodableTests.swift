import SemanticVersion
import XCTest

final class SemanticVersionCodableTests: XCTestCase {
    
    let invalidVersionStrings = [
        // insufficient elements
        "",
        "1", ".1", "1.", ".",
        "1.1", "1.1.", "1..1", ".1.1", "1..", "..",
        "1.1-alpha", "1.1.-alpha", "1.1.1.-alpha",
        "1.1+42", "1.1.+42",
        "1.1.1-alpha..0",
        "1.1.1+a..1",
        // too many elements
        "1.1.1.1", "1.1.1.1.1",
        // empty components
        "1.1.1-", "1.1.1+",
        "1.1.1-+123", "1.1.1-beta+",
        // leading zeroes
        "01.1.1", "001.1.1", "1.01.1", "1.01.1", "1.1.01", "1.1.001",
        "1.1.1-01", "1.1.1-001",
        "1.1.1-alpha.01", "1.1.1-alpha.001",
        // invalid character
        "-1.1.1", "1.-1.1", "1.1.-1",
        "a.b.c", "1.a.b", "1.1.a", "1.a.1", "a.1.1",
        "*.1.1", "1.#.1", "1.1.^", "1_000_000.1.1",
        "1.1.1 ", "1.1.1- 1", "1.1.1-a ",
        "1.1.1-*", "1.1.1-alpha.#", "1.1.1-1.^.1",
        "1.1.1+h*23", "1.1.1-(1)", "1.1.1-1_000_000",
        "1.2.3-naïve", "1.2.3-蛤.foo", "1.2.3+😄.foo",
        "1.1.1-alpha.0+a#1", "1.1.1+ ", "1.1.1+hello world",
        // non-ASCII digits
        "1.0.0-5\u{0663}", "1.0.0-\u{0663}a", "1.0.0-5\u{FF13}", "1\u{0663}.0.0",
        // version numbers beyond UInt.max
        "18446744073709551616.0.0", "1.18446744073709551616.0", "1.0.18446744073709551616",
    ]
    
    func testCodingInvalidStringThrows() throws {
        
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        
        for invalidVersionString in invalidVersionStrings {
            
            let data = try encoder.encode(invalidVersionString)
            
            XCTAssertThrowsError(try decoder.decode(SemanticVersion.self, from: data))
            
        }
        
    }
    
    func testInvalidStrings() {
        
        for invalidVersionString in invalidVersionStrings {
            
            XCTAssertNil(SemVer(invalidVersionString), invalidVersionString)
            
        }
        
    }
    
}
