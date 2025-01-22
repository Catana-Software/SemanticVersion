import SemanticVersion
import XCTest

final class SemanticLosslessStringConvertibleTests: XCTestCase {
    
    func testKnownValueConstructor() {
        
        let ver = SemVer("1.452.368-rc.alpha.11.log-test+sha.exp.5114f85.20190121")!
        
        XCTAssertEqual(ver.major, 1)
        XCTAssertEqual(ver.minor, 452)
        XCTAssertEqual(ver.patch, 368)
        XCTAssertEqual(ver.prerelease.count, 4)
        XCTAssertEqual(ver.prerelease[0], "rc")
        XCTAssertEqual(ver.prerelease[1], "alpha")
        XCTAssertEqual(ver.prerelease[2], "11")
        XCTAssertEqual(ver.prerelease[3], "log-test")
        XCTAssertEqual(ver.buildMetadata.count, 4)
        XCTAssertEqual(ver.buildMetadata[0], "sha")
        XCTAssertEqual(ver.buildMetadata[1], "exp")
        XCTAssertEqual(ver.buildMetadata[2], "5114f85")
        XCTAssertEqual(ver.buildMetadata[3], "20190121")
        
    }
    
    func testStringConvertible() {
        
        let value = "1.101.345-rc.alpha.11+build.sha.111.extended"
        
        let ver = SemVer(value)
        
        XCTAssertEqual(ver?.description, value)
        
    }
    
}
