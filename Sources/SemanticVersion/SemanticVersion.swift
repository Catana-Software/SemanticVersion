import Foundation

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
    
    public init(major: UInt,
                minor: UInt,
                patch: UInt,
                prerelease: [String],
                buildMetadata: [String]) {
        
        self.major = major
        self.minor = minor
        self.patch = patch
        self.prerelease = prerelease
        self.buildMetadata = buildMetadata
        
    }
    
}
