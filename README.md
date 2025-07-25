# Cerbos Ruby SDK

[![Gem](https://img.shields.io/gem/v/cerbos?style=flat-square)](https://rubygems.org/gems/cerbos)
&ensp;
[![Documentation](https://img.shields.io/badge/yard-docs-blue?style=flat-square)](https://www.rubydoc.info/gems/cerbos)

[Cerbos](https://cerbos.dev) helps you super-charge your authorization implementation by writing context-aware access control policies for your application resources.
Author access rules using an intuitive YAML configuration language, use your Git-ops infrastructure to test and deploy them, and make simple API requests to the Cerbos policy decision point (PDP) server to evaluate the policies and make dynamic access decisions.

The Cerbos Ruby SDK makes it easy to interact with the [Cerbos PDP](https://www.cerbos.dev/product-cerbos-pdp) and [Cerbos Hub](https://www.cerbos.dev/product-cerbos-hub) from your Ruby applications.

## Prerequisites

- Cerbos 0.16+
- Ruby 3.2+

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

### Cerbos PDP

```ruby
require "cerbos"

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

For more details, [see the `Cerbos::Client` documentation](https://www.rubydoc.info/gems/cerbos/Cerbos/Client).

### Cerbos Hub [policy stores](https://docs.cerbos.dev/cerbos-hub/policy-stores)

```ruby
require "cerbos"

client = Cerbos::Hub::Stores::Client.new(
  client_id: ENV.fetch("CERBOS_HUB_CLIENT_ID"),
  client_secret: ENV.fetch("CERBOS_HUB_CLIENT_SECRET")
)

response = client.modify_files(
  store_id: ENV.fetch("CERBOS_HUB_STORE_ID"),
  operations: [
    {add_or_update: {path: "foo.yaml", contents: File.binread("path/to/foo.yaml")}},
    {delete: "bar.yaml"}
  ]
)

puts response.new_store_version
```

For more details, [see the `Cerbos::Hub::Stores::Client` documentation](https://www.rubydoc.info/gems/cerbos/Cerbos/Hub/Stores/Client).

## Further reading

- [API reference](https://www.rubydoc.info/gems/cerbos/Cerbos)
- [Cerbos documentation](https://docs.cerbos.dev)
- [Cerbos Hub documentation](https://docs.cerbos.dev/cerbos-hub/)

## Get help

- [Join the Cerbos community on Slack](http://go.cerbos.io/slack)
- [Email us at help@cerbos.dev](mailto:help@cerbos.dev)
