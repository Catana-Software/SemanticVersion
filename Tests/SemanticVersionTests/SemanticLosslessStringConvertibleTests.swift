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

    func testOverlongStringReturnsNil() {

        // Inputs beyond the parser's length bound are rejected before the regular
        // expression runs, bounding the work done on untrusted input.
        let longPrerelease = String(repeating: "a", count: 1_000)

        XCTAssertNil(SemVer("1.2.3-\(longPrerelease)"))

    }

    func testLengthBoundBoundary() {

        // "1.2.3-" is 6 bytes, so 250 further bytes sit exactly on the 256-byte
        // bound and 251 sit one past it.
        let atBound = "1.2.3-" + String(repeating: "a", count: 250)
        let pastBound = "1.2.3-" + String(repeating: "a", count: 251)

        XCTAssertNotNil(SemVer(atBound))
        XCTAssertNil(SemVer(pastBound))

    }

    func testLengthBoundIsCountedInBytes() {

        // A combining sequence packs many bytes into a single `Character`. The
        // length bound counts bytes, so a short-looking payload of this kind is
        // rejected without ever reaching the regular expression.
        let cluster = "e" + String(repeating: "\u{0301}", count: 40)
        let input = "1.2.3-" + String(repeating: cluster, count: 100)

        XCTAssertLessThanOrEqual(input.count, 256)
        XCTAssertGreaterThan(input.utf8.count, 256)
        XCTAssertNil(SemVer(input))

    }

    func testVersionNumberBounds() {

        let max = String(UInt.max)

        XCTAssertEqual(SemVer("\(max).0.0")?.major, UInt.max)

        // One decimal digit past `UInt.max` overflows the conversion and is
        // rejected with a `nil`, not a trap.
        XCTAssertNil(SemVer("\(max)0.0.0"))
        XCTAssertNil(SemVer("1.\(max)0.0"))
        XCTAssertNil(SemVer("1.0.\(max)0"))

    }

    func testNonASCIIDigitsAreRejected() {

        // Swift's `\d` matches any Unicode decimal digit; the parser must only
        // accept the ASCII digits the Semantic Versioning grammar allows.
        // U+0663 is ARABIC-INDIC DIGIT THREE, U+FF13 is FULLWIDTH DIGIT THREE.
        XCTAssertNil(SemVer("1.0.0-5\u{0663}"))
        XCTAssertNil(SemVer("1.0.0-\u{0663}a"))
        XCTAssertNil(SemVer("1.0.0-5\u{FF13}"))
        XCTAssertNil(SemVer("1\u{0663}.0.0"))
        XCTAssertNil(SemVer("1.0.0-1\u{0663}"))

    }

    func testMemberwiseRoundTrip() {

        let version = SemVer(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: ["alpha", "1"],
            buildMetadata: ["exp", "sha", "5114f85"]
        )

        XCTAssertEqual(SemVer(version.description), version)

    }

    func testPlausibleRoundTrip() {

        for _ in 0..<1_000 {

            let version = SemVer.plausible()
            let reparsed = SemVer(version.description)

            XCTAssertEqual(reparsed, version, version.description)
            XCTAssertEqual(reparsed?.buildMetadata, version.buildMetadata, version.description)

        }

    }

}
