# frozen_string_literal: true

module CerbosOutputNewClassHandler
  def process
    if statement[1].call? && statement[1][0][0] == s(:const, "Output") && statement[1][2] == s(:ident, "new_class")
      process_output_new_class(statement)
    else
      super
    end
  end

  private

  def process_output_new_class(statement)
    proxy = P(namespace, statement[0].source)
    output_class = YARD::CodeObjects::ClassObject.new(proxy.namespace, proxy.name)
    register output_class

    attributes = extract_parameters(statement[1])

    attributes.each do |attribute|
      register YARD::CodeObjects::MethodObject.new(output_class, attribute, :instance) do |method|
        output_class.attributes[:instance][attribute] = SymbolHash[read: method, write: nil]
      end
    end

    parse_block statement[1].block[1], namespace: output_class unless statement[1].block.nil?

    output_class.child(name: :from_protobuf, scope: :class)&.visibility = :private
  end
end

YARD::Handlers::Ruby::ConstantHandler.include CerbosOutputNewClassHandler
