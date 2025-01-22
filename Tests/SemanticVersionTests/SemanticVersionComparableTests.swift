import SemanticVersion
import XCTest

final class SemanticVersionComparableTests: XCTestCase {
    
    let sortedVersionStrings = [
        "0.0.1-alpha.0",
        "0.0.1",
        "0.0.2-alpha",
        "0.0.2-alpha.0",
        "0.0.2-alpha.0.1",
        "0.0.2",
        "0.0.3-aaa",
        "0.0.3-aaa.2",
        "0.0.3-aaa.11",
        "0.0.3-alpha.1",
        "0.1.0-alpha.3",
        "0.1.0-beta.2",
        "0.1.0-beta.3",
        "0.1.0-rc.1",
        "0.1.0",
        "1.0.0-1",
        "1.0.0-3",
        "1.0.0-11",
        "1.0.0-alpha.0",
        "1.0.0",
        "1.0.1",
        "1.1.0",
        "1.2.0",
        "2.0.0-1",
        "2.0.0--1",
        "2.0.0--2",
        "2.0.0-alpha.0"
    ]
    
    func testVersionComparison() {
        
        let sortedVersions = sortedVersionStrings
            .map { SemVer($0)! }
        
        for (v1, v2) in zip(sortedVersions, sortedVersions.dropFirst()) {
            XCTAssertLessThan(v1, v2)
        }
        
        let resorted = sortedVersions
            .shuffled()
            .sorted()
        
        XCTAssertEqual(sortedVersions, resorted)
        
    }
    
    func testCompareBasic() {
        
        // Compare Major
        XCTAssertLessThan(SemVer("1.100.0")!, SemVer("2.0.0")!)
        
        // Compare Minor
        XCTAssertLessThan(SemVer("1.99.231")!, SemVer("1.101.12344")!)
        
        // Compare Patch
        XCTAssertLessThan(SemVer("1.99.231")!, SemVer("1.99.12344")!)
        
        // Ignore build metadata
        XCTAssertEqual(SemVer("1.99.231+b")!, SemVer("1.99.231+a")!)
        
    }
    
    func testCompareWithPrerelease() {
        
        XCTAssertLessThan(SemVer("1.99.231-alpha")!, SemVer("1.99.231")!)
        
    }
    
    func testComparePrerelease() {
        
        // alphabetical order
        XCTAssertLessThan(SemVer("1.99.231-test.alpha")!, SemVer("1.99.231-test.beta")!)
        XCTAssertLessThan(SemVer("1.99.231-test.19b")!, SemVer("1.99.231-test.alpha")!)
        
        // numeric order
        XCTAssertLessThan(SemVer("1.99.231-test")!, SemVer("1.99.231-test.1.3")!)
        
        // numeric < non-numeric
        XCTAssertLessThan(SemVer("1.99.231-test.2")!, SemVer("1.99.231-test.19b")!)
        
        // smaller-set < larger-set
        XCTAssertLessThan(SemVer("1.99.231-alpha.beta")!, SemVer("1.99.231-alpha.beta.11")!)
        
        // Ignore build metatdata
        XCTAssertEqual(SemVer("1.99.231-alpha.bb")!, SemVer("1.99.231-alpha.bb+a")!)
        
    }
    
}
