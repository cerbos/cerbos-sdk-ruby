# frozen_string_literal: true

RSpec.describe Cerbos::Output do
  describe ".new_class" do
    subject(:new_class) do
      described_class.new_class(:foo, :bar) do
        def self.a_class_method
          :implemented
        end

        def an_instance_method
          :implemented
        end
      end
    end

    let(:instance) { new_class.new(foo: 1, bar: 2) }
    let(:matching_instance) { new_class.new(foo: 1, bar: 2) }
    let(:different_instance) { new_class.new(foo: 2, bar: 1) }

    it "implements attribute readers" do
      expect(instance).to have_attributes(foo: 1, bar: 2)
    end

    it "implements #==", :aggregate_failures do
      expect(instance == matching_instance).to be(true)
      expect(instance == different_instance).to be(false)
    end

    it "implements #eql?", :aggregate_failures do
      expect(instance.eql?(matching_instance)).to be(true)
      expect(instance.eql?(different_instance)).to be(false)
    end

    it "implements #hash", :aggregate_failures do
      expect(instance.hash).to be_an(Integer)
      expect(instance.hash).to eq(matching_instance.hash)
      expect(instance.hash).not_to eq(different_instance.hash)
    end

    it "implements custom class methods" do
      expect(new_class.a_class_method).to eq(:implemented)
    end

    it "implements custom instance methods" do
      expect(instance.an_instance_method).to eq(:implemented)
    end
  end
end
