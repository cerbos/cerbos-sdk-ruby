## [Unreleased]
No notable changes.

## [0.2.0] - 2022-05-12
### Changed
- Increased `grpc` version requirement to 1.46+ to avoid [installing a native gem compiled for `x86_64-darwin` on `arm64-darwin`](https://github.com/grpc/grpc/issues/29100) ([#8](https://github.com/cerbos/cerbos-sdk-ruby/pull/8))

## [0.1.0] - 2022-05-12
### Added
- Initial implementation of `Cerbos::Client` ([#2](https://github.com/cerbos/cerbos-sdk-ruby/pull/2))

[Unreleased]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.2.0...HEAD
[0.2.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/4481009e9dec2e1e6a2df8ea2f828690ceabbefc...v0.1.0
