#  Welcome to the SemanticVersion contributing guide

## New contributor guide

To get an overview of the project, checkout the README.

## General principles

### TDD

```
Red -> Green -> Refactor
```

The basic development process follows the idea:

1. Make failing unit test
1. Make unit test pass
1. Refactor if necessary

### Documentation

DocC and Markdown are the documentations used across this project. Comments in code are only required when there is something about a line/approach that might not be explained in the DocC documentation, or might not be obvious why that choice was made from the code alone. Before inserting such comments, think "does the need for this comment mean this code is not as readable as it could be".

In general this project prefers readability over minor performance "optimisation". The release optimisation settings will often do a better job at optimising, but in known circumstances this is not the case, and probably after a careful analysis of the trade offs and documentation of the rationale, such a micro optimisation may be acceptable.

If the code looks "Swifty" then it is probably already compliant with these guidelines.  

## SwiftLint

Coming to this project soon... SwiftLint!

## Style Guide

A style guide can be found at the root of this project.

## Bug reporting

**If you find a security vulnerability, do NOT open an issue. Email rob@rase.rocks instead.**

Any security issues should be submitted directly to rob@rase.rocks. In order to determine whether you are dealing with a security issue, ask yourself these two questions:

* Can I access something that's not mine, or something I shouldn't have access to?
* Can I disable something for other people?

If the answer to either of those two questions are "yes", then you're probably dealing with a security issue. Note that even if you answer "no" to both questions, you may still be dealing with a security issue, so if you're unsure, just email us at rob@rase.rocks.

### How to submit a bug report

Bugs are tracked as GitHub issues. Create an issue on the repository and provide the following information:

Explain the problem and include additional details to help maintainers reproduce the problem:

* Use a clear and descriptive title for the issue to identify the problem.
* Describe the exact steps which reproduce the problem in as many details as possible.
* Describe the behavior you observed after following the steps and point out what exactly is the problem with that behavior.
* Explain which behavior you expected to see instead and why.
* Include screenshots and animated GIFs which show you following the described steps and clearly demonstrate the problem. If you use the keyboard while following the steps, record the GIF with the Keybinding Resolver shown.
* If the problem is related to performance or memory, include a CPU profile capture with your report.
* If the problem wasn't triggered by a specific action, describe what you were doing before the problem happened and share more information using the guidelines below.

Provide more context by answering these questions:

* Did the problem start happening recently
* If the problem started happening recently, can you reproduce the problem in an older version of SemanticVersion? What's the most recent version in which the problem doesn't happen?
* Can you reliably reproduce the issue? If not, provide details about how often the problem happens and under which conditions it normally happens.

Include details about your configuration and environment:

* Which version of SemanticVersion are you using?
* Which OS / device are you running on?
* Are you using a device setup that is beyond; single user, single device? For example, are you running multiple monitors, separate audio outputs or multiple devices 


