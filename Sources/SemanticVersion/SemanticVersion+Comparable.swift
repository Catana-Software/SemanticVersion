import Foundation

/// Extends ``SemanticVersion`` with `Comparable` conformance
extension SemanticVersion: Comparable {
    
    /// Global less than operator
    ///
    /// This function attempts to represent the spec at [Semantic Versioning 2.0.0](http://semver.org).
    ///
    /// - Parameter lhs: A ``SemanticVersion`` instance.
    /// - Parameter rhs: A ``SemanticVersion`` instance.
    ///
    /// - Returns: A truthy value if the `lhs` is considered less than `rhs`, as a Semantic Version.
    public static func <(lhs: SemanticVersion, rhs: SemanticVersion) -> Bool {
        
        guard lhs.major == rhs.major else { return lhs.major < rhs.major }
        guard lhs.minor == rhs.minor else { return lhs.minor < rhs.minor }
        guard lhs.patch == rhs.patch else { return lhs.patch < rhs.patch }
        guard lhs.isPrerelease else { return false }
        guard rhs.isPrerelease else { return true }
        
        return lhs
            .prerelease
            .lexicographicallyPrecedes(rhs.prerelease) { lpr, rpr in
            
            if lpr == rpr { return false }
            
            switch (UInt(lpr), UInt(rpr)) {
                
            case let (l?, r?):
                return l < r
                
            case (nil, nil):
                return lpr < rpr
                
            case (_?, nil):
                return true
                
            case (nil, _?):
                return false
                
            }
            
        }
        
    }
    
}
