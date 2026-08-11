/// Extends ``SemanticVersion`` with conformance to `LosslessStringConvertible`
extension SemanticVersion: LosslessStringConvertible {

    /// A `Regex` from [Semantic Versioning 2.0.0](http://semver.org).
    ///
    /// The spec's recommended pattern, with each `\d` transcribed as `[0-9]`: Swift's `\d`
    /// matches any Unicode decimal digit, where the Semantic Versioning grammar permits ASCII
    /// digits only.
    ///
    /// `Regex` does not conform to `Sendable`, so the property is marked `nonisolated(unsafe)`.
    /// Access is safe: the value is immutable after its once-only initialisation, `wholeMatch`
    /// is non-mutating, and the standard library synchronises the internal lazy compilation of
    /// the matcher. Verified clean under the Thread Sanitizer with concurrent first use.
    nonisolated(unsafe) private static let re =
    /^(?<major>0|[1-9][0-9]*)\.(?<minor>0|[1-9][0-9]*)\.(?<patch>0|[1-9][0-9]*)(?:-(?<prerelease>(?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9][0-9]*|[0-9]*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildMetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?$/

    /// The maximum length in UTF-8 bytes of a `String` accepted by the parser.
    ///
    /// The initialiser is reachable from `Codable` decoding of untrusted input,
    /// so the length is bounded before the regular expression runs. This caps the
    /// work performed on a single value and any opportunity for the matcher to
    /// backtrack pathologically. Bytes are counted rather than `Character`s:
    /// combining sequences let a small number of grapheme clusters carry an
    /// arbitrarily large payload, and `utf8.count` is O(1) where `count` walks
    /// the whole string. The limit is far larger than any practical version
    /// string.
    private static let maxDescriptionLength = 256

    /// Initialise a ``SemanticVersion`` from a `String` value
    ///
    /// If the `String` value passed is not a valid Semantic Versioning string, then a `nil` will
    /// be returned. A `nil` is also returned for inputs longer than 256 UTF-8 bytes, or whose
    /// major, minor, or patch numbers exceed `UInt.max` (a platform-dependent width; 64 bits on
    /// modern Apple platforms).
    ///
    /// - Parameter description: A `String` to attempt to represent as a ``SemanticVersion``.
    public init?(_ description: String) {

        guard description.utf8.count <= SemanticVersion.maxDescriptionLength else { return nil }

        guard
            let match = try? SemanticVersion.re.wholeMatch(in: description),
            let major = UInt(match.major),
            let minor = UInt(match.minor),
            let patch = UInt(match.patch)
        else { return nil }

        self.major = major
        self.minor = minor
        self.patch = patch

        prerelease = match.prerelease?
            .split(separator: ".", omittingEmptySubsequences: false)
            .map(String.init) ?? []
        buildMetadata = match.buildMetadata?
            .split(separator: ".", omittingEmptySubsequences: false)
            .map(String.init) ?? []

    }
    
    /// A `String` representation conforming to [Semantic Versioning 2.0.0](http://semver.org).
    public var description: String {
        
        var result = "\(major).\(minor).\(patch)"
        
        if !prerelease.isEmpty {
            result += "-" + prerelease.joined(separator: ".")
        }
        
        if !buildMetadata.isEmpty {
            result += "+" + buildMetadata.joined(separator: ".")
        }
        
        return result
        
    }
    
}
