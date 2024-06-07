## [Unreleased]

### Changed

- Use `attr` for principal and resource attributes ([#157](https://github.com/cerbos/cerbos-sdk-ruby/pull/157))

  This makes the API consistent with policy expressions.
  `attributes` is still supported for backwards compatibility, but is now deprecated.

## [0.8.0] - 2024-01-12

### Added

- `grpc_metadata` option to `Cerbos::Client` constructor and request methods to add gRPC metadata (a.k.a. HTTP headers) to requests to the policy decision point ([#132](https://github.com/cerbos/cerbos-sdk-ruby/pull/132))

## [0.7.0] - 2023-06-07

### Added

- Support for user-defined policy rule outputs ([#100](https://github.com/cerbos/cerbos-sdk-ruby/pull/100))

  Requires a policy decision point server running Cerbos 0.27+.

### Removed

- Support for Ruby 2.7 ([#90](https://github.com/cerbos/cerbos-sdk-ruby/pull/90))

## [0.6.1] - 2023-03-23

### Removed

- Unused generated code ([#83](https://github.com/cerbos/cerbos-sdk-ruby/pull/83))

## [0.6.0] - 2022-07-01

### Added

- Support for schema validation in `Cerbos::Client#plan_resources` ([#32](https://github.com/cerbos/cerbos-sdk-ruby/pull/32))

  Requires a policy decision point server running Cerbos 0.19+.
  `Cerbos::Output::PlanResources#validation_errors` will always return an empty array if the client is connected to an earlier version of Cerbos.

  As a result, `Cerbos::Output::CheckResources::Result::ValidationError` has moved to `Cerbos::Output::ValidationError`.
  Attempting to access the class via the old namespace will print a deprecation warning and return the new class.

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

[Unreleased]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.8.0...HEAD
[0.8.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/cerbos/cerbos-sdk-ruby/compare/4481009e9dec2e1e6a2df8ea2f828690ceabbefc...v0.1.0
