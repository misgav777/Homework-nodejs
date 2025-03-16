# Contributing to nodejs-demoapp

Thank you for your interest in contributing to this project! This document provides guidelines and instructions for contributing.

## Commit Message Convention

This repository follows [Semantic Versioning](https://semver.org/) using automated tooling. Your commit messages directly influence the version number of the next release. Please follow these conventions:

### Commit Message Format

Each commit message consists of a **header**, an optional **body**, and an optional **footer**:

```
<type>(<optional scope>): <description>

<optional body>

<optional footer>
```

### Commit Types

The commit type determines how the version number is incremented:

| Type | Description | Version Impact |
|------|-------------|---------------|
| `feat` | A new feature | MINOR (e.g., 1.0.0 → 1.1.0) |
| `fix` | A bug fix | PATCH (e.g., 1.0.0 → 1.0.1) |
| `docs` | Documentation only changes | No version change |
| `style` | Changes that don't affect code functionality (white-space, formatting, etc.) | No version change |
| `refactor` | Code changes that neither fix a bug nor add a feature | No version change |
| `perf` | Code changes that improve performance | No version change |
| `test` | Adding missing tests or correcting existing tests | No version change |
| `chore` | Changes to the build process or auxiliary tools | No version change |

### Breaking Changes

Breaking changes should be indicated in one of two ways:

1. Adding an exclamation mark after the type: `feat!: introduce a breaking change`
2. Adding a `BREAKING CHANGE:` footer:
   ```
   feat: change API response format
   
   BREAKING CHANGE: The response format has changed from XML to JSON
   ```

Both methods will trigger a MAJOR version increment (e.g., 1.0.0 → 2.0.0).

### Examples

#### Minor Feature (MINOR version bump)
```
feat: add user authentication API
```

#### Bug Fix (PATCH version bump)
```
fix: prevent crash when input is empty
```

#### Breaking Change (MAJOR version bump)
```
feat!: redesign user interface
```
or
```
feat: change API structure

BREAKING CHANGE: The API endpoints have been completely restructured
```

#### No Version Change
```
docs: update installation instructions
```

## Pull Requests

1. Fork the repository
2. Create a feature branch from the main branch
3. Make your changes
4. Run tests and linting
5. Create a pull request to the main branch

All PRs should include appropriate tests and follow the commit message conventions.

## Testing

Before submitting a PR, please ensure that:
1. All existing tests pass
2. New tests are added for new functionality
3. The application builds successfully

## Code of Conduct

Please be respectful and considerate of others. We welcome contributions from everyone.