# frozen_string_literal: true

RSpec.describe Cerbos::Output::CheckResources::Result do
  subject(:result) do
    described_class.new(
      resource: instance_double(Cerbos::Output::CheckResources::Result::Resource),
      actions: {
        "yes" => :EFFECT_ALLOW,
        "no" => :EFFECT_DENY,
        "yup" => :EFFECT_ALLOW,
        "nah" => :EFFECT_DENY,
        "yeah" => :EFFECT_ALLOW
      },
      validation_errors: [],
      metadata: nil
    )
  end

  describe "#allow?" do
    subject(:allow) { result.allow?(action) }

    context "when the action is allowed" do
      let(:action) { "yes" }

      it { is_expected.to be(true) }
    end

    context "when the action is denied" do
      let(:action) { "no" }

      it { is_expected.to be(false) }
    end

    context "when the action is not present" do
      let(:action) { "unknown" }

      it { is_expected.to be_nil }
    end
  end

  describe "#allowed_actions" do
    it "returns a list of allowed actions" do
      expect(result.allowed_actions).to eq(["yes", "yup", "yeah"])
    end
  end
end
