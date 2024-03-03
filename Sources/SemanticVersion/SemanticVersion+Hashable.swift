import Foundation

/// Extends ``SemanticVersion`` with `Hashable` conformance
extension SemanticVersion: Hashable {
    
    /// Hash a ``SemanticVersion`` into the `Hasher` instance provided
    ///
    /// Buildmeta is ignored for equality and hashing purposes, so this
    /// function will return the same result, regardless of any build metadata
    /// set on the instance
    ///
    /// - Parameter hasher: The `Hasher` instance.
    public func hash(into hasher: inout Hasher) {
        
        hasher.combine(major)
        hasher.combine(minor)
        hasher.combine(patch)
        hasher.combine(prerelease)
        
    }
    
}
