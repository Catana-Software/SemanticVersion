public typealias SemVer = SemanticVersion

/// A version conforming to [Semantic Versioning 2.0.0](http://semver.org).
///
/// > Important: This implementation does not support prefixing version strings
public struct SemanticVersion {
    
    /// The MAJOR version.
    public let major: UInt
    
    /// The MINOR version.
    public let minor: UInt
    
    /// The PATCH version.
    public let patch: UInt
    
    /// The pre-release identifiers
    public let prerelease: [String]
    
    /// The build metadata. Metadata is ignored for hashing and equality operations
    public let buildMetadata: [String]
    
    /// A Boolean value indicating whether the version is pre-release version
    public var isPrerelease: Bool {
        return !prerelease.isEmpty
    }
    
    /// Initialise a ``SemanticVersion`` from its individual components.
    ///
    /// Invalid identifiers are treated as a programming error and trap. For identifiers that are
    /// not known to be valid, such as those decoded from a payload or supplied by a user, use
    /// ``validated(major:minor:patch:prerelease:buildMetadata:)`` instead, which returns a `nil`.
    ///
    /// - Parameters:
    ///   - major: The MAJOR version.
    ///   - minor: The MINOR version.
    ///   - patch: The PATCH version.
    ///   - prerelease: The pre-release identifiers.
    ///   - buildMetadata: The build metadata identifiers. Ignored for equality, hashing and ordering.
    ///
    /// - Precondition: Every element of `prerelease` is a non-empty string of ASCII alphanumerics
    ///   and hyphens, without leading zeroes if it comprises only digits.
    ///
    /// - Precondition: Every element of `buildMetadata` is a non-empty string of ASCII
    ///   alphanumerics and hyphens.
    public init(
        major: UInt,
        minor: UInt,
        patch: UInt,
        prerelease: [String],
        buildMetadata: [String]
    ) {

        precondition(
            prerelease.allSatisfy(SemanticVersion.isValidPrereleaseIdentifier),
            "A pre-release identifier must be a non-empty string of ASCII alphanumerics and " +
            "hyphens, without leading zeroes if it comprises only digits. Use " +
            "SemanticVersion.validated(major:minor:patch:prerelease:buildMetadata:) for " +
            "identifiers that are not known to be valid"
        )

        precondition(
            buildMetadata.allSatisfy(SemanticVersion.isValidBuildMetadataIdentifier),
            "A build metadata identifier must be a non-empty string of ASCII alphanumerics and " +
            "hyphens. Use SemanticVersion.validated(major:minor:patch:prerelease:buildMetadata:) " +
            "for identifiers that are not known to be valid"
        )

        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease
        self.buildMetadata = buildMetadata

    }

    /// Initialise a ``SemanticVersion`` from components that are not known to be valid.
    ///
    /// Prefer this to ``init(major:minor:patch:prerelease:buildMetadata:)`` whenever the
    /// identifiers originate outside your own code, such as a decoded payload, a query parameter,
    /// or a user supplied value. The memberwise initialiser treats an invalid identifier as a
    /// programming error and traps, including in release builds; this returns a `nil` instead.
    ///
    /// Parsing a whole version string with ``init(_:)`` needs no such care, as that initialiser
    /// is failable and validates the entire string.
    ///
    /// - Parameters:
    ///   - major: The MAJOR version.
    ///   - minor: The MINOR version.
    ///   - patch: The PATCH version.
    ///   - prerelease: The pre-release identifiers.
    ///   - buildMetadata: The build metadata identifiers. Ignored for equality, hashing and ordering.
    ///
    /// - Returns: A ``SemanticVersion``, or a `nil` if any identifier is invalid.
    public static func validated(
        major: UInt,
        minor: UInt,
        patch: UInt,
        prerelease: [String],
        buildMetadata: [String]
    ) -> SemanticVersion? {

        guard
            prerelease.allSatisfy(isValidPrereleaseIdentifier),
            buildMetadata.allSatisfy(isValidBuildMetadataIdentifier)
        else { return nil }

        return SemanticVersion(
            major: major,
            minor: minor,
            patch: patch,
            prerelease: prerelease,
            buildMetadata: buildMetadata
        )

    }

    /// Determine whether a string is a valid pre-release identifier.
    ///
    /// A valid pre-release identifier is a non-empty string of ASCII alphanumerics and hyphens
    /// that, when it comprises only digits, has no leading zeroes.
    ///
    /// Use this to check identifiers before passing them to
    /// ``init(major:minor:patch:prerelease:buildMetadata:)``.
    ///
    /// - Parameter identifier: A single pre-release identifier.
    ///
    /// - Returns: A truthy value if the identifier is valid.
    public static func isValidPrereleaseIdentifier(_ identifier: String) -> Bool {

        guard isValidBuildMetadataIdentifier(identifier) else { return false }

        let hasLeadingZero = identifier.utf8.count > 1 &&
        identifier.utf8.first == UInt8(ascii: "0")

        return !hasLeadingZero || !isNumericIdentifier(identifier)

    }

    /// Determine whether a string is a valid build metadata identifier.
    ///
    /// A valid build metadata identifier is a non-empty string of ASCII alphanumerics and hyphens.
    /// Unlike a pre-release identifier, it may carry leading zeroes.
    ///
    /// Use this to check identifiers before passing them to
    /// ``init(major:minor:patch:prerelease:buildMetadata:)``.
    ///
    /// - Parameter identifier: A single build metadata identifier.
    ///
    /// - Returns: A truthy value if the identifier is valid.
    public static func isValidBuildMetadataIdentifier(_ identifier: String) -> Bool {

        return !identifier.isEmpty && identifier.utf8.allSatisfy { byte in

            return (byte >= UInt8(ascii: "0") && byte <= UInt8(ascii: "9")) ||
            (byte >= UInt8(ascii: "A") && byte <= UInt8(ascii: "Z")) ||
            (byte >= UInt8(ascii: "a") && byte <= UInt8(ascii: "z")) ||
            byte == UInt8(ascii: "-")

        }

    }

    /// Determine whether an identifier is a numeric identifier.
    ///
    /// A numeric identifier comprises only ASCII digits. Identifiers are checked on construction
    /// never to include leading zeroes, so this also implies that a longer numeric identifier
    /// represents a larger value. The byte-wise check is deliberate: `Character.isNumber` matches
    /// non-ASCII digits, which the Semantic Versioning grammar excludes.
    ///
    /// - Parameter identifier: A single pre-release identifier.
    ///
    /// - Returns: A truthy value if every character is an ASCII digit.
    static func isNumericIdentifier(_ identifier: String) -> Bool {

        return !identifier.isEmpty &&
        identifier.utf8.allSatisfy { $0 >= UInt8(ascii: "0") && $0 <= UInt8(ascii: "9") }

    }

}

extension SemanticVersion: Sendable {}
