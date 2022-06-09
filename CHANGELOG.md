## [Unreleased]
No notable changes.

## [0.5.0] - 2022-06-09
### Added
- Allow symbol keys in nested attributes hashes ([#28](https://github.com/cerbos/cerbos-sdk-ruby/pull/28))

## [0.4.0] - 2022-06-03
### Added
- `on_validation_error` option to `Cerbos::Client#initialize` ([#22](https://github.com/cerbos/cerbos-sdk-ruby/pull/22))

### Changed
- Minor documentation fixes ([#21](https://github.com/cerbos/cerbos-sdk-ruby/pull/21))

## [0.3.0] - 2022-05-13
### Added
- More helper methods ([#11](https://github.com/cerbos/cerbos-sdk-ruby/pull/11))
  - `Cerbos::Client#allow?` for checking a single action on a resource
  - `Cerbos::Output::CheckResources#allow_all?` and `Cerbos::Output::CheckResources::Result#allow_all?` for checking if all input actions were allowed

## [0.2.0] - 2022-05-12
### Changed
- Increased `grpc` version requirement to 1.46+ to avoid [installing a native gem compiled for `x86_64-darwin` on `arm64-darwin`](https://github.com/grpc/grpc/issues/29100) ([#8](https://github.com/cerbos/cerbos-sdk-ruby/pull/8))

## [0.1.0] - 2022-05-12
### Added
- Initial implementation of `Cerbos::Client` ([#2](https://github.com/cerbos/cerbos-sdk-ruby/pull/2))

[Unreleased]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.5.0...HEAD
[0.5.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/4481009e9dec2e1e6a2df8ea2f828690ceabbefc...v0.1.0
