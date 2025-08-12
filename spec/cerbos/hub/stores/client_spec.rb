# frozen_string_literal: true

RSpec.describe Cerbos::Hub::Stores::Client, :hub do
  subject(:client) { described_class.new(client_id:, client_secret:, target:, grpc_metadata:) }

  let(:client_id) { ENV.fetch("CERBOS_HUB_STORES_CLIENT_ID") }
  let(:client_secret) { ENV.fetch("CERBOS_HUB_STORES_CLIENT_SECRET") }
  let(:target) { URI.parse(ENV.fetch("CERBOS_HUB_API_ENDPOINT")).then { |uri| "#{uri.host}:#{uri.port}" } }
  let(:grpc_metadata) { {} }
  let(:store_id) { ENV.fetch("CERBOS_HUB_STORE_ID") }

  it "round-trips files" do
    a, b, hidden, schema = *["a.yaml", "b.json", ".hidden.yaml", "_schemas/a.json"].map { |path| Cerbos::Hub::Stores::File.new(path:, contents: File.binread(File.expand_path("policies/#{path}", __dir__))) }

    response = client.replace_files(
      store_id:,
      files: [a, b, hidden],
      allow_unchanged: true
    )

    expect(response).to be_a(Cerbos::Hub::Stores::Output::ReplaceFiles).and(have_attributes(
      new_store_version: a_value > 0,
      ignored_files: [hidden.path]
    ))

    current_store_version = response.new_store_version
    ignored_files = response.ignored_files

    response = client.replace_files(
      store_id:,
      files: [a, b, hidden],
      allow_unchanged: true
    )

    expect(response).to eq(Cerbos::Hub::Stores::Output::ReplaceFiles.new(
      new_store_version: current_store_version,
      ignored_files: [hidden.path],
      changed: false
    ))

    expect {
      client.replace_files(
        store_id:,
        files: [a, b, hidden]
      )
    }.to raise_error { |error|
      expect(error).to be_a(Cerbos::Hub::Stores::Error::OperationDiscarded).and(have_attributes(
        current_store_version:,
        ignored_files:
      ))
    }

    response = client.list_files(store_id:, filter: {path: {equals: a.path}})

    expect(response).to eq(Cerbos::Hub::Stores::Output::ListFiles.new(
      store_version: current_store_version,
      files: [a.path]
    ))

    response = client.get_files(store_id:, files: [a.path])

    expect(response).to eq(Cerbos::Hub::Stores::Output::GetFiles.new(
      store_version: current_store_version,
      files: [a]
    ))

    response = client.modify_files(
      store_id:,
      condition: {store_version_must_equal: current_store_version},
      operations: [
        {add_or_update: a},
        {add_or_update: schema},
        {delete: b.path}
      ]
    )

    expect(response).to eq(Cerbos::Hub::Stores::Output::ModifyFiles.new(
      new_store_version: current_store_version + 1,
      changed: true
    ))

    current_store_version = response.new_store_version

    response = client.modify_files(
      store_id:,
      operations: [{delete: b.path}],
      allow_unchanged: true
    )

    expect(response).to eq(Cerbos::Hub::Stores::Output::ModifyFiles.new(
      new_store_version: current_store_version,
      changed: false
    ))

    expect {
      client.modify_files(
        store_id:,
        operations: [{delete: b.path}]
      )
    }.to raise_error { |error|
      expect(error).to be_a(Cerbos::Hub::Stores::Error::OperationDiscarded).and(have_attributes(
        current_store_version:,
        ignored_files: []
      ))
    }

    zip = Zip::OutputStream.write_buffer do |out|
      [a, b, hidden].each do |file|
        out.put_next_entry file.path
        out.write file.contents
      end
    end

    response = client.replace_files(
      store_id:,
      zipped_contents: zip.string
    )

    expect(response).to eq(Cerbos::Hub::Stores::Output::ReplaceFiles.new(
      new_store_version: current_store_version + 1,
      ignored_files: [hidden.path],
      changed: true
    ))
  end
end
