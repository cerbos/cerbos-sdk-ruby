# frozen_string_literal: true

RSpec.describe Cerbos::Output::PlanResources do
  subject(:plan_resources) do
    described_class.new(
      request_id: "42",
      kind: kind,
      condition: Cerbos::Output::PlanResources::Expression::Value.new(value: true),
      validation_errors: [],
      metadata: nil
    )
  end

  context "when always allowed" do
    let(:kind) { :KIND_ALWAYS_ALLOWED }

    it { is_expected.to be_always_allowed }
    it { is_expected.not_to be_conditional }
    it { is_expected.not_to be_always_denied }
  end

  context "when always denied" do
    let(:kind) { :KIND_ALWAYS_DENIED }

    it { is_expected.to be_always_denied }
    it { is_expected.not_to be_always_allowed }
    it { is_expected.not_to be_conditional }
  end

  context "when conditional" do
    let(:kind) { :KIND_CONDITIONAL }

    it { is_expected.to be_conditional }
    it { is_expected.not_to be_always_allowed }
    it { is_expected.not_to be_always_denied }
  end
end
