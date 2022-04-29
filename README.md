# Cerbos Ruby SDK

[![Gem](https://img.shields.io/gem/v/cerbos?style=flat-square)](https://rubygems.org/gems/cerbos)
&ensp;
[![Documentation](https://img.shields.io/badge/yard-docs-blue?style=flat-square)](https://www.rubydoc.info/gems/cerbos)

[Cerbos](https://cerbos.dev) helps you super-charge your authorization implementation by writing context-aware access control policies for your application resources.
Author access rules using an intuitive YAML configuration language, use your Git-ops infrastructure to test and deploy them, and make simple API requests to the Cerbos policy decision point (PDP) server to evaluate the policies and make dynamic access decisions.

The Cerbos Ruby SDK makes it easy to interact with the Cerbos PDP from your Ruby applications.

## Prerequisites

- Cerbos 0.16+
- Ruby 2.7+

## Installation

Install the gem and add it to your application's Gemfile by running

```console
$ bundle add cerbos
```

If you're not using Bundler to manage dependencies, install the gem by running

```console
$ gem install cerbos
```

### Note for M1 Mac users

Unfortunately, the `grpc` gem currently ships a `universal-darwin` native gem which doesn't actually work on `arm64-darwin` platforms ([grpc/grpc#29100](https://github.com/grpc/grpc/issues/29100)).
If you install the precompiled gem on an M1 Mac, you'll get a `LoadError` including the message "incompatible architecture (have 'x86_64', need 'arm64e')" when you attempt to load the `cerbos` gem.

Until that issue is resolved, you can work around it by compiling native extensions from source.
Configure Bundler to do so by running

```console
$ bundle config set --local force_ruby_platform true
```

## Example usage

```ruby
client = Cerbos::Client.new("localhost:3593", tls: false)

decision = client.check_resource(
  principal: {
    id: "user@example.com",
    roles: ["USER"],
  },
  resource: {
    kind: "document",
    id: "1",
    attributes: {
      owner: "author@example.com"
    }
  },
  actions: ["view", "edit"]
)

decision.allow?("view") # => true
decision.allow?("edit") # => false
```

For more details, [see the `Client` documentation](https://www.rubydoc.info/gems/cerbos/Cerbos/Client).
