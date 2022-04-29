# frozen_string_literal: true

RSpec.describe Cerbos::Output::CheckResources::Result::ValidationError do
  subject(:validation_error) { described_class.new(path: "/foo", message: "bar", source: source) }

  context "when source is principal" do
    let(:source) { :SOURCE_PRINCIPAL }

    it { is_expected.to be_from_principal }
    it { is_expected.not_to be_from_resource }
  end

  context "when source is resource" do
    let(:source) { :SOURCE_RESOURCE }

    it { is_expected.to be_from_resource }
    it { is_expected.not_to be_from_principal }
  end
end
