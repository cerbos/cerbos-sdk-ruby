# Cerbos Ruby SDK

[![Gem](https://img.shields.io/gem/v/cerbos?style=flat-square)](https://rubygems.org/gems/cerbos)
&ensp;
[![Documentation](https://img.shields.io/badge/yard-docs-blue?style=flat-square)](https://www.rubydoc.info/gems/cerbos)

[Cerbos](https://cerbos.dev) helps you super-charge your authorization implementation by writing context-aware access control policies for your application resources.
Author access rules using an intuitive YAML configuration language, use your Git-ops infrastructure to test and deploy them, and make simple API requests to the Cerbos policy decision point (PDP) server to evaluate the policies and make dynamic access decisions.

The Cerbos Ruby SDK makes it easy to interact with the Cerbos PDP from your Ruby applications.

## Prerequisites

- Cerbos 0.16+
- Ruby 3.0+

## Installation

Install the gem and add it to your application's Gemfile by running

```console
$ bundle add cerbos
```

If you're not using Bundler to manage dependencies, install the gem by running

```console
$ gem install cerbos
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
    attr: {
      owner: "author@example.com"
    }
  },
  actions: ["view", "edit"]
)

decision.allow?("view") # => true
decision.allow?("edit") # => false
```

For more details, [see the `Client` documentation](https://www.rubydoc.info/gems/cerbos/Cerbos/Client).

## Further reading

- [API reference](https://www.rubydoc.info/gems/cerbos/Cerbos)
- [Cerbos documentation](https://docs.cerbos.dev)

## Get help

- [Join the Cerbos community on Slack](http://go.cerbos.io/slack)
- [Email us at help@cerbos.dev](mailto:help@cerbos.dev)
