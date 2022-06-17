# frozen_string_literal: true

RSpec.describe Cerbos::Output::CheckResources do
  subject(:check_resources) { described_class.new(request_id: "42", results: results) }

  describe "#allow?" do
    subject(:allow) { check_resources.allow?(resource: {kind: "document", id: resource_id}, action: action) }

    let(:results) do
      [
        Cerbos::Output::CheckResources::Result.new(
          resource: Cerbos::Output::CheckResources::Result::Resource.new(
            kind: "document",
            id: "found",
            policy_version: "default",
            scope: ""
          ),
          actions: {
            "allowed" => :EFFECT_ALLOW,
            "denied" => :EFFECT_DENY
          },
          validation_errors: [],
          metadata: nil
        )
      ]
    end

    context "when the resource is found" do
      let(:resource_id) { "found" }

      context "when the action is allowed" do
        let(:action) { "allowed" }

        it { is_expected.to be(true) }
      end

      context "when the action is denied" do
        let(:action) { "denied" }

        it { is_expected.to be(false) }
      end

      context "when the action is not present" do
        let(:action) { "unknown" }

        it { is_expected.to be_nil }
      end
    end

    context "when the resource is not found" do
      let(:resource_id) { "not_found" }
      let(:action) { "any" }

      it { is_expected.to be_nil }
    end
  end

  describe "#allow_all?" do
    subject(:allow_all) { check_resources.allow_all?(kind: "document", id: resource_id) }

    let(:results) do
      [
        Cerbos::Output::CheckResources::Result.new(
          resource: Cerbos::Output::CheckResources::Result::Resource.new(
            kind: "document",
            id: "found",
            policy_version: "default",
            scope: ""
          ),
          actions: actions,
          validation_errors: [],
          metadata: nil
        )
      ]
    end

    context "when the resource is found" do
      let(:resource_id) { "found" }

      context "when all actions are allowed" do
        let(:actions) do
          {
            "allowed" => :EFFECT_ALLOW,
            "also_allowed" => :EFFECT_ALLOW
          }
        end

        it { is_expected.to be(true) }
      end

      context "when some actions are denied" do
        let(:actions) do
          {
            "allowed" => :EFFECT_ALLOW,
            "denied" => :EFFECT_DENY
          }
        end

        it { is_expected.to be(false) }
      end
    end

    context "when the resource is not found" do
      let(:resource_id) { "not_found" }
      let(:actions) { {} }

      it { is_expected.to be_nil }
    end
  end

  describe "#find_result" do
    subject(:find_result) { check_resources.find_result(resource) }

    let(:results) do
      [
        *build_results(id: "kind_and_id", policy_versions: ["default"], scopes: [""]),
        *build_results(id: "policy_version", policy_versions: ["1", "2"], scopes: [""]),
        *build_results(id: "scope", policy_versions: ["default"], scopes: ["alpha", "beta"]),
        *build_results(id: "policy_version_and_scope", policy_versions: ["1", "2"], scopes: ["alpha", "beta"])
      ].shuffle
    end

    context "with kind and id" do
      let(:resource) { {kind: "document", id: "kind_and_id"} }

      it "finds a matching result" do
        expect(find_result).to eq(build_result(**resource, policy_version: "default", scope: ""))
      end
    end

    context "with kind, id, and policy version" do
      let(:resource) { {kind: "document", id: "policy_version", policy_version: "1"} }

      it "finds a matching result" do
        expect(find_result).to eq(build_result(**resource, scope: ""))
      end
    end

    context "with kind, id, and scope" do
      let(:resource) { {kind: "document", id: "scope", scope: "alpha"} }

      it "finds a matching result" do
        expect(find_result).to eq(build_result(**resource, policy_version: "default"))
      end
    end

    context "with kind, id, policy version, and scope" do
      let(:resource) { {kind: "document", id: "policy_version_and_scope", policy_version: "1", scope: "alpha"} }

      it "finds a matching result" do
        expect(find_result).to eq(build_result(**resource))
      end
    end

    context "with an input resource" do
      let(:resource) { Cerbos::Input::Resource.new(**attributes) }

      let(:attributes) { {kind: "document", id: "policy_version_and_scope", policy_version: "1", scope: "alpha"} }

      it "finds a matching result" do
        expect(find_result).to eq(build_result(**attributes))
      end
    end

    def build_results(id:, policy_versions:, scopes:)
      ["document", "image"].flat_map do |kind|
        policy_versions.flat_map do |policy_version|
          scopes.flat_map do |scope|
            build_result(kind: kind, id: id, policy_version: policy_version, scope: scope)
          end
        end
      end
    end

    def build_result(**resource)
      Cerbos::Output::CheckResources::Result.new(
        resource: Cerbos::Output::CheckResources::Result::Resource.new(**resource),
        actions: {},
        validation_errors: [],
        metadata: nil
      )
    end
  end

  describe "#validation_errors" do
    subject(:validation_errors) { check_resources.validation_errors }

    let(:results) do
      [
        Cerbos::Output::CheckResources::Result.new(
          resource: Cerbos::Output::CheckResources::Result::Resource.new(
            kind: "document",
            id: "1",
            policy_version: "default",
            scope: ""
          ),
          actions: {"allowed" => :EFFECT_ALLOW},
          validation_errors: [
            Cerbos::Output::ValidationError.new(
              path: "/country/alpha2",
              message: "does not match pattern '[A-Z]{2}'",
              source: :SOURCE_PRINCIPAL
            )
          ],
          metadata: nil
        ),
        Cerbos::Output::CheckResources::Result.new(
          resource: Cerbos::Output::CheckResources::Result::Resource.new(
            kind: "document",
            id: "2",
            policy_version: "default",
            scope: ""
          ),
          actions: {"allowed" => :EFFECT_ALLOW},
          validation_errors: [
            Cerbos::Output::ValidationError.new(
              path: "/country/alpha2",
              message: "does not match pattern '[A-Z]{2}'",
              source: :SOURCE_PRINCIPAL
            ),
            Cerbos::Output::ValidationError.new(
              path: "/owner",
              message: "expected string, but got number",
              source: :SOURCE_RESOURCE
            )
          ],
          metadata: nil
        )
      ]
    end

    it "lists validation errors from results" do
      expect(validation_errors).to eq([
        Cerbos::Output::ValidationError.new(
          path: "/country/alpha2",
          message: "does not match pattern '[A-Z]{2}'",
          source: :SOURCE_PRINCIPAL
        ),
        Cerbos::Output::ValidationError.new(
          path: "/owner",
          message: "expected string, but got number",
          source: :SOURCE_RESOURCE
        )
      ])
    end
  end
end
