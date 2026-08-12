# Semantic Version

For the complete spec visit https://semver.org. The information below is extracted from that page for reference within this project

## Introduction

Given a version number MAJOR.MINOR.PATCH, increment the:

1. MAJOR version when you make incompatible API changes
1. MINOR version when you add functionality in a backwards compatible manner
1. PATCH version when you make backwards compatible bug fixes

Additional labels for pre-release and build metadata are available as extensions to the MAJOR.MINOR.PATCH format.

## Installation

To use the SemanticVersion library in a SwiftPM project, add the following line to the dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/rase-rocks/SemanticVersion.git", from: "1.0.0"),
```

Include "SemanticVersion" as a dependency for your executable target and finally, add `import SemanticVersion` to your source code.

## Usage

### Instantiate from string literal

The main type of this project, `SemanticVersion` conforms to both `Codable` and `LosslessStringConvertible`. Under the hood, both are achieved by the `LosslessStringConvertible` implementation.

All of which is to say that a `SemanticVersion` can be instantiated from a string:

```swift
let version = SemVer("14.4.1")
// version?.major == 14
// version?.minor == 4
// version?.patch == 1
```

The initialiser is failable and returns `nil` for any string that is not a valid Semantic Versioning string. It also returns `nil` for inputs longer than 256 UTF-8 bytes, or whose major, minor, or patch numbers exceed `UInt.max`.

### Codable conformance

`SemanticVersion` encodes/decodes with a string representation, so when used with a text based encoding, such as JSON, it forms a drop in replacement for an existing implementation that represents version information as a string conforming to SemVer 2.0.0.

For this example the starting point is a simple type representing a book, with a name and version.

```swift
struct Book: Equatable, Codable {
    let name: String
    let version: SemVer
}
```

As the properties of `Book` both also conform to `Equatable` and `Codable`, nothing extra is needed.

```swift
let book = Book(
    name: "Alice in Wonderland",
    version: SemVer("14.4.1")!
)

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let data = try encoder
    .encode(book)

let string = String(
    data: data,
    encoding: .utf8
)!

print(string)

let decoded = try JSONDecoder()
    .decode(Book.self, from: data)

// decoded == book
```

**Note** The usage of forced unwrapping in this documentation is for brevity and not suitable for production code.

The console output of the `print` line will resemble this:

```json
{
  "name" : "Alice in Wonderland",
  "version" : "14.4.1"
}
```

### Comparison

A major motivating factor in SemVer is to allow comparison of version strings. `SemanticVersion` attempts to provide a native Swift implementation of the comparison in the specification at https://semver.org.

The comparision operators are provided to enable specification compliant checks:

```swift
let fourteenFourOne = SemVer("14.4.1")!
let fourteenFourTwo = SemVer("14.4.2")!

// fourteenFourOne < fourteenFourTwo ✅
// fourteenFourTwo > fourteenFourOne ✅
```

For more detailed usage examples and how this implementation handles prerelease and build meta data see the [unit tests](https://github.com/rase-rocks/SemanticVersion/blob/main/Tests/SemanticVersionTests/SemanticVersionComparableTests.swift).

**Note** In accordance with the specification, build metadata is ignored for equality, hashing and ordering. This means two versions that differ only by build metadata (for example `1.0.0+a` and `1.0.0+b`) compare as equal, even though their string representations — and therefore their encoded forms, differ. If you need to distinguish them, compare their `description` values directly.

### Constructing from individual components

A `SemanticVersion` can also be built from its parts rather than parsed from a string. Identifiers must be valid: non-empty strings of ASCII alphanumerics and hyphens, and, for pre-release identifiers, without leading zeroes if they comprise only digits. The memberwise initialiser treats an invalid identifier as a programming error and traps, in release builds as well as debug:

```swift
// ✅ valid
let version = SemVer(
    major: 1, minor: 2, patch: 3,
    prerelease: ["alpha", "1"],
    buildMetadata: ["exp", "sha", "5114f85"]
)

// ❌ traps: "alpha.1" is one identifier containing a separator
let invalid = SemVer(
    major: 1, minor: 2, patch: 3,
    prerelease: ["alpha.1"],
    buildMetadata: []
)
```

When the identifiers do not come from your own code, such as a decoded payload, a query parameter, or a user supplied value, use `validated(major:minor:patch:prerelease:buildMetadata:)`, which returns `nil` rather than trapping:

```swift
guard let version = SemVer.validated(
    major: payload.major, minor: payload.minor, patch: payload.patch,
    prerelease: payload.prerelease,
    buildMetadata: payload.buildMetadata
) else {
    throw MyError.invalidVersion
}
```

Individual identifiers can be checked ahead of time with `SemanticVersion.isValidPrereleaseIdentifier(_:)` and `SemanticVersion.isValidBuildMetadataIdentifier(_:)`.

**Note** This care is only needed when building from components. Parsing a whole version string with `SemVer(_:)` is always failable and never traps, so decoding untrusted JSON is safe: an invalid version string surfaces as a `DecodingError`.

## Contributing

A guide to contributing to this project can be found at [CONTRIBUTING.md](https://github.com/rase-rocks/SemanticVersion/blob/main/CONTRIBUTING.md).

The code style and conventions used in this project can be found at [CODESTYLE.md](https://github.com/rase-rocks/SemanticVersion/blob/main/CODESTYLE.md).

## License

All content is licensed under the terms of the [MIT open source license](https://github.com/rase-rocks/SemanticVersion/blob/main/LICENSE.txt).
