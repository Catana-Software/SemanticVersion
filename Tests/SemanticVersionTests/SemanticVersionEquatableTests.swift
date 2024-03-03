import XCTest
import SemanticVersion

final class SemanticVersionEquatableTests: XCTestCase {
    
    func valid(major: UInt, minor: UInt, patch: UInt, rest: String) -> String {
        return "\(major).\(minor).\(patch)\(rest)"
    }
    
    func testKnownEqual() {
        
        let equalVersionPairs: [(SemVer, SemVer)] = [
            (0, 0, ""),
            (0, 1, ""),
            (1, 0, ""),
            (0, 0, "-alpha.0"),
            (0, 0, "-beta.0"),
            (0, 0, "-boo"),
        ]
            .map { valid(major: .random(in: 0...1_000), minor: $0.0, patch: $0.1, rest: $0.2) }
            .map { (SemVer($0)!, SemVer($0)!) }
        
        for equalVersionPair in equalVersionPairs {
            
            XCTAssertEqual(equalVersionPair.0, equalVersionPair.1)
            
        }
        
    }
    
    func testKnownInEqual() {
        
        let inEqualVersionPairs: [(SemVer, SemVer)] = [
            ("3.0.0",           "3.0.0-alpha.0"),
            ("3.0.0",           "3.0.1"),
            ("3.0.0",           "3.1.0"),
            ("4.0.0",           "3.0.0"),
            ("3.0.0-alpha.0",   "3.0.0-alpha.5"),
            ("3.0.0-alpha.0",   "3.0.0-beta.0"),
            ("3.0.0-alpha.0",   "3.0.0-boo"),
            ("3.0.0",           "3.1.1"),
            ("3.0.0-alpha.0",   "3.0.1-alpha.1")
        ].map { (SemVer($0)!, SemVer($1)!) }
        
        for pair in inEqualVersionPairs {
            
            XCTAssertNotEqual(pair.0, pair.1)
            XCTAssertNotEqual(pair.0.hashValue, pair.1.hashValue)
            
        }
        
    }
    
    func testInEqualMinor() {
        
        XCTAssertNotEqual(SemVer("1.100.3"), SemVer("1.101.3"))
        
    }
    
    func testInEqualPrerelease() {
        
        XCTAssertNotEqual(SemVer("1.100.3-rc.1"), SemVer("1.100.3-rc.2"))
        XCTAssertNotEqual(SemVer("1.100.3-rc.1"), SemVer("1.100.3-rc.1.2.3"))
        XCTAssertNotEqual(SemVer("1.100.3-alpha"), SemVer("1.100.3-beta"))
        XCTAssertNotEqual(SemVer("1.100.3-rc.a"), SemVer("1.100.3-rc.1"))
        
    }
    
    func testInEqualBuildmetadata() {
        
        XCTAssertEqual(SemVer("1.101.345-rc.1+build.sha.111"), SemVer("1.101.345-rc.1+build.sha.112"))
        
    }
    
}
