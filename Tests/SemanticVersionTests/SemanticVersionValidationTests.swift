import XCTest

@testable import SemanticVersion

final class SemanticVersionValidationTests: XCTestCase {

    func testValidPrereleaseIdentifiers() {

        let validIdentifiers = [
            "0", "9", "42", "999999", "99999999999999999999999",
            "a", "alpha", "alpha-1", "0a", "00a", "01-", "0-0",
            "-", "--", "-1", "20190121"
        ]

        for identifier in validIdentifiers {
            XCTAssertTrue(SemanticVersion.isValidPrereleaseIdentifier(identifier), identifier)
        }

    }

    func testInvalidPrereleaseIdentifiers() {

        let invalidIdentifiers = [
            "", "00", "01", "001",
            "alpha.1", "a b", " ", "a_b", "a+b", "(1)",
            "béta", "蛤", "😄", "5\u{0663}", "\u{0663}", "5\u{FF13}"
        ]

        for identifier in invalidIdentifiers {
            XCTAssertFalse(SemanticVersion.isValidPrereleaseIdentifier(identifier), identifier)
        }

    }

    func testValidBuildMetadataIdentifiers() {

        // Unlike pre-release identifiers, leading zeroes are permitted.
        let validIdentifiers = ["0", "00", "01", "001", "0a", "alpha", "-", "-1", "20190121"]

        for identifier in validIdentifiers {
            XCTAssertTrue(SemanticVersion.isValidBuildMetadataIdentifier(identifier), identifier)
        }

    }

    func testInvalidBuildMetadataIdentifiers() {

        let invalidIdentifiers = ["", "a.b", "a b", " ", "a_b", "béta", "😄", "5\u{0663}"]

        for identifier in invalidIdentifiers {
            XCTAssertFalse(SemanticVersion.isValidBuildMetadataIdentifier(identifier), identifier)
        }

    }

    func testNumericIdentifierClassification() {

        XCTAssertTrue(SemanticVersion.isNumericIdentifier("0"))
        XCTAssertTrue(SemanticVersion.isNumericIdentifier("42"))
        XCTAssertTrue(SemanticVersion.isNumericIdentifier("99999999999999999999999"))

        XCTAssertFalse(SemanticVersion.isNumericIdentifier(""))
        XCTAssertFalse(SemanticVersion.isNumericIdentifier("4a"))
        XCTAssertFalse(SemanticVersion.isNumericIdentifier("-1"))

        // Non-ASCII digits are not numeric identifiers.
        XCTAssertFalse(SemanticVersion.isNumericIdentifier("5\u{0663}"))
        XCTAssertFalse(SemanticVersion.isNumericIdentifier("\u{FF13}"))

    }

}
