import Foundation

/// Extends ``SemanticVersion`` with `Equatable` conformance
extension SemanticVersion: Equatable {
    
    /// Global equality function
    ///
    /// In semantic versioning, build metadata is ignored for equality
    ///
    /// - Parameter lhs: A ``SemanticVersion`` instance.
    /// - Parameter rhs: A ``SemanticVersion`` instance.
    ///
    /// - Returns: A truthy value if the ``SemanticVersion`` passed are considered equal.
    public static func ==(lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        return lhs.major == rhs.major &&
        lhs.minor == rhs.minor &&
        lhs.patch == rhs.patch &&
        lhs.prerelease == rhs.prerelease
    }
    
}

