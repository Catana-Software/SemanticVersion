import SemanticVersion
import XCTest

class SemanticVersionTests: XCTestCase {
    
    let count = 5
    
    func testCoding() throws {
        
        let version = SemVer.plausible()
        let encoded = try JSONEncoder().encode(version)
        let decoded = try JSONDecoder().decode(SemVer.self, from: encoded)
        
        XCTAssertEqual(decoded, version)
        
    }
    
    func testEquality() {
        
        XCTAssertNotEqual(SemVer.plausible(),
                          SemVer.plausible())
        
    }
    
    func testHashable() {
        
        XCTAssertNotEqual(SemVer.plausible().hashValue,
                          SemVer.plausible().hashValue)
        
    }
    
}

extension SemanticVersion {
    
    /// Generate a valid version value, including `UInt.max`, but preferring
    /// a more reasonable `0..<9999>` range
    static func validVersion() -> UInt {
        
        let expectedRange: Range<UInt> = 0..<9999
        
        return [
            .max,
            UInt.random(in: expectedRange),
            UInt.random(in: expectedRange)
        ].randomElement()!
        
    }
    
    static func validVersionIdentifier() -> String {
        return [
            "0",
            "0a",
            "0-",
            "42",
            "999999",
            "build",
            "alpha",
            "prerelease",
            "-bar-",
            "-",
            "-1"
        ].randomElement()!
    }
    
    static func plausible() -> SemanticVersion {
        
        let randomIdentifiers = { maxCount in
            return (0..<Int.random(in: 0..<maxCount))
                .map { _ in return validVersionIdentifier() }
        }
        
        return SemanticVersion(major: validVersion(),
                               minor: validVersion(),
                               patch: validVersion(),
                               prerelease: randomIdentifiers(5),
                               buildMetadata: randomIdentifiers(5))
        
    }
    
}
