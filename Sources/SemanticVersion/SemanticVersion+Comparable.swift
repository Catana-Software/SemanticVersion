/// Extends ``SemanticVersion`` with `Comparable` conformance
extension SemanticVersion: Comparable {
    
    /// Global less than operator
    ///
    /// This function attempts to represent the spec at [Semantic Versioning 2.0.0](http://semver.org).
    ///
    /// - Parameters:
    ///   - lhs: A ``SemanticVersion`` instance.
    ///   - rhs: A ``SemanticVersion`` instance.
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

                let lhsIsNumeric = isNumericIdentifier(lpr)
                let rhsIsNumeric = isNumericIdentifier(rpr)

                switch (lhsIsNumeric, rhsIsNumeric) {

                case (true, true):
                    // Numeric identifiers compare numerically. The spec places
                    // no upper bound on their length, so a `UInt` conversion can
                    // overflow; comparing by digit count avoids that. As leading
                    // zeroes are disallowed, the identifier with more digits is
                    // always the larger number, and identifiers with an equal
                    // number of digits compare correctly lexically. Identifiers
                    // are validated ASCII, so `utf8.count` is the digit count
                    // and avoids a grapheme walk.
                    return lpr.utf8.count == rpr.utf8.count
                        ? lpr < rpr
                        : lpr.utf8.count < rpr.utf8.count

                case (false, false):
                    return lpr < rpr

                case (true, false):
                    return true

                case (false, true):
                    return false

                }

            }

    }

}
