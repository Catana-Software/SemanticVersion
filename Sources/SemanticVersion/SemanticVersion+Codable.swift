import Foundation

/// Extends ``SemanticVersion`` with `Codable` conformance
extension SemanticVersion: Codable {
    
    /// Construct a `DecodingError` to represent an invalid version string
    ///
    /// - Parameter container: The `SingleValueDecodingContainer` that was used in decoding.
    ///
    /// - Returns: A `DecodingError` representing an invalid version string.
    static func dataCorruptedError(in container: SingleValueDecodingContainer) -> DecodingError {
        return DecodingError
            .dataCorruptedError(in: container,
                                debugDescription: "Invalid semantic version")
    }
    
    /// Encodes a ``SemanticVersion`` with a single value container
    ///
    /// - Parameter encoder: The `Encoder` instance.
    ///
    /// - Throws: Rethrows encodig errors.
    public func encode(to encoder: Encoder) throws {
        
        var container = encoder.singleValueContainer()
        
        try container.encode(description)
        
    }
    
    /// Initialise a ``SemanticVersion`` from a `Decoder`
    ///
    /// - Parameter decoder: The `Decoder` with a single value container.
    ///
    /// - Throws: A `DecodingError` if an invalid version string is found, and rethrows decoding errors.
    public init(from decoder: Decoder) throws {
        
        let container = try decoder
            .singleValueContainer()
        
        let str = try container
            .decode(String.self)
        
        guard
            let version = SemVer(str)
        else { throw SemVer.dataCorruptedError(in: container) }
        
        self = version
        
    }
    
}

