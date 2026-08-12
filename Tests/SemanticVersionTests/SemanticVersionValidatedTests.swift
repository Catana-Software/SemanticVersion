import Foundation
import XCTest

// Deliberately NOT `@testable`: this suite exercises the public surface, so it
// fails to compile if the validating API stops being public.
import SemanticVersion

final class SemanticVersionValidatedTests: XCTestCase {

    func testValidatedAcceptsValidComponents() {

        let version = SemVer.validated(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: ["alpha", "1"],
            buildMetadata: ["exp", "sha", "5114f85"]
        )

        XCTAssertEqual(version?.description, "1.2.3-alpha.1+exp.sha.5114f85")

    }

    func testValidatedMatchesMemberwiseInitialiser() {

        let validated = SemVer.validated(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: ["alpha", "1"],
            buildMetadata: ["build", "99"]
        )

        let memberwise = SemVer(
            major: 1,
            minor: 2,
            patch: 3,
            prerelease: ["alpha", "1"],
            buildMetadata: ["build", "99"]
        )

        XCTAssertEqual(validated, memberwise)
        XCTAssertEqual(validated?.buildMetadata, memberwise.buildMetadata)

    }

    func testValidatedRejectsInvalidPrereleaseIdentifiers() {

        // Each of these traps the memberwise initialiser, so it must return nil here.
        let invalidIdentifiers = ["", "alpha.1", "a b", "01", "007", "a_b", "5\u{0663}", "\u{FF13}"]

        for identifier in invalidIdentifiers {

            XCTAssertNil(
                SemVer.validated(
                    major: 1,
                    minor: 0,
                    patch: 0,
                    prerelease: [identifier],
                    buildMetadata: []
                ),
                identifier
            )

        }

    }

    func testValidatedRejectsInvalidBuildMetadataIdentifiers() {

        let invalidIdentifiers = ["", "a.b", "a b", "a_b", "5\u{0663}"]

        for identifier in invalidIdentifiers {

            XCTAssertNil(
                SemVer.validated(
                    major: 1,
                    minor: 0,
                    patch: 0,
                    prerelease: [],
                    buildMetadata: [identifier]
                ),
                identifier
            )

        }

    }

    func testValidatedAllowsLeadingZeroesInBuildMetadataOnly() {

        XCTAssertNotNil(
            SemVer.validated(major: 1, minor: 0, patch: 0, prerelease: [], buildMetadata: ["001"])
        )

        XCTAssertNil(
            SemVer.validated(major: 1, minor: 0, patch: 0, prerelease: ["001"], buildMetadata: [])
        )

    }

    func testValidatedOutputAlwaysReparses() {

        let version = SemVer.validated(
            major: 0,
            minor: 0,
            patch: 0,
            prerelease: ["0", "-", "0a", "alpha-1"],
            buildMetadata: ["00", "-", "build"]
        )

        let reparsed = SemVer(version!.description)

        XCTAssertEqual(reparsed, version)
        XCTAssertEqual(reparsed?.buildMetadata, version?.buildMetadata)

    }

    func testPublicPredicatesAreReachable() {

        XCTAssertTrue(SemanticVersion.isValidPrereleaseIdentifier("alpha-1"))
        XCTAssertFalse(SemanticVersion.isValidPrereleaseIdentifier("alpha.1"))

        XCTAssertTrue(SemanticVersion.isValidBuildMetadataIdentifier("001"))
        XCTAssertFalse(SemanticVersion.isValidBuildMetadataIdentifier(""))

    }

    func testParsedComponentsAreAlwaysAcceptedByValidated() {

        // The two construction paths must agree: anything the parser can emit
        // must be constructible without tripping the precondition.
        let versionStrings = [
            "1.2.3",
            "1.2.3-alpha.1+exp.sha.5114f85",
            "0.0.0-0",
            "1.0.0--1",
            "1.0.0-0a.-.Z9",
            "1.0.0+00.01.001",
            "1.0.0-99999999999999999999999"
        ]

        for versionString in versionStrings {

            let parsed = SemVer(versionString)!

            let revalidated = SemVer.validated(
                major: parsed.major,
                minor: parsed.minor,
                patch: parsed.patch,
                prerelease: parsed.prerelease,
                buildMetadata: parsed.buildMetadata
            )

            XCTAssertEqual(revalidated, parsed, versionString)

        }

    }

    func testUntrustedPayloadComponentsAreHandledSafely() throws {

        // The scenario the validating API exists for: components arriving from
        // an untrusted source rather than as a complete version string.
        struct Payload: Codable {

            let major: UInt
            let prerelease: [String]

        }

        let hostile = #"{"major": 1, "prerelease": ["alpha.1"]}"#
        let payload = try JSONDecoder().decode(Payload.self, from: Data(hostile.utf8))

        XCTAssertNil(
            SemVer.validated(
                major: payload.major,
                minor: 0,
                patch: 0,
                prerelease: payload.prerelease,
                buildMetadata: []
            )
        )

    }

}
