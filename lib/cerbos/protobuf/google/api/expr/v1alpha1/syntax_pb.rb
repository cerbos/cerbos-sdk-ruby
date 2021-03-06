# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: google/api/expr/v1alpha1/syntax.proto

require 'google/protobuf'

require 'google/protobuf/duration_pb'
require 'google/protobuf/struct_pb'
require 'google/protobuf/timestamp_pb'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_file("google/api/expr/v1alpha1/syntax.proto", :syntax => :proto3) do
    add_message "google.api.expr.v1alpha1.ParsedExpr" do
      optional :expr, :message, 2, "google.api.expr.v1alpha1.Expr", json_name: "expr"
      optional :source_info, :message, 3, "google.api.expr.v1alpha1.SourceInfo", json_name: "sourceInfo"
    end
    add_message "google.api.expr.v1alpha1.Expr" do
      optional :id, :int64, 2, json_name: "id"
      oneof :expr_kind do
        optional :const_expr, :message, 3, "google.api.expr.v1alpha1.Constant", json_name: "constExpr"
        optional :ident_expr, :message, 4, "google.api.expr.v1alpha1.Expr.Ident", json_name: "identExpr"
        optional :select_expr, :message, 5, "google.api.expr.v1alpha1.Expr.Select", json_name: "selectExpr"
        optional :call_expr, :message, 6, "google.api.expr.v1alpha1.Expr.Call", json_name: "callExpr"
        optional :list_expr, :message, 7, "google.api.expr.v1alpha1.Expr.CreateList", json_name: "listExpr"
        optional :struct_expr, :message, 8, "google.api.expr.v1alpha1.Expr.CreateStruct", json_name: "structExpr"
        optional :comprehension_expr, :message, 9, "google.api.expr.v1alpha1.Expr.Comprehension", json_name: "comprehensionExpr"
      end
    end
    add_message "google.api.expr.v1alpha1.Expr.Ident" do
      optional :name, :string, 1, json_name: "name"
    end
    add_message "google.api.expr.v1alpha1.Expr.Select" do
      optional :operand, :message, 1, "google.api.expr.v1alpha1.Expr", json_name: "operand"
      optional :field, :string, 2, json_name: "field"
      optional :test_only, :bool, 3, json_name: "testOnly"
    end
    add_message "google.api.expr.v1alpha1.Expr.Call" do
      optional :target, :message, 1, "google.api.expr.v1alpha1.Expr", json_name: "target"
      optional :function, :string, 2, json_name: "function"
      repeated :args, :message, 3, "google.api.expr.v1alpha1.Expr", json_name: "args"
    end
    add_message "google.api.expr.v1alpha1.Expr.CreateList" do
      repeated :elements, :message, 1, "google.api.expr.v1alpha1.Expr", json_name: "elements"
    end
    add_message "google.api.expr.v1alpha1.Expr.CreateStruct" do
      optional :message_name, :string, 1, json_name: "messageName"
      repeated :entries, :message, 2, "google.api.expr.v1alpha1.Expr.CreateStruct.Entry", json_name: "entries"
    end
    add_message "google.api.expr.v1alpha1.Expr.CreateStruct.Entry" do
      optional :id, :int64, 1, json_name: "id"
      optional :value, :message, 4, "google.api.expr.v1alpha1.Expr", json_name: "value"
      oneof :key_kind do
        optional :field_key, :string, 2, json_name: "fieldKey"
        optional :map_key, :message, 3, "google.api.expr.v1alpha1.Expr", json_name: "mapKey"
      end
    end
    add_message "google.api.expr.v1alpha1.Expr.Comprehension" do
      optional :iter_var, :string, 1, json_name: "iterVar"
      optional :iter_range, :message, 2, "google.api.expr.v1alpha1.Expr", json_name: "iterRange"
      optional :accu_var, :string, 3, json_name: "accuVar"
      optional :accu_init, :message, 4, "google.api.expr.v1alpha1.Expr", json_name: "accuInit"
      optional :loop_condition, :message, 5, "google.api.expr.v1alpha1.Expr", json_name: "loopCondition"
      optional :loop_step, :message, 6, "google.api.expr.v1alpha1.Expr", json_name: "loopStep"
      optional :result, :message, 7, "google.api.expr.v1alpha1.Expr", json_name: "result"
    end
    add_message "google.api.expr.v1alpha1.Constant" do
      oneof :constant_kind do
        optional :null_value, :enum, 1, "google.protobuf.NullValue", json_name: "nullValue"
        optional :bool_value, :bool, 2, json_name: "boolValue"
        optional :int64_value, :int64, 3, json_name: "int64Value"
        optional :uint64_value, :uint64, 4, json_name: "uint64Value"
        optional :double_value, :double, 5, json_name: "doubleValue"
        optional :string_value, :string, 6, json_name: "stringValue"
        optional :bytes_value, :bytes, 7, json_name: "bytesValue"
        optional :duration_value, :message, 8, "google.protobuf.Duration", json_name: "durationValue"
        optional :timestamp_value, :message, 9, "google.protobuf.Timestamp", json_name: "timestampValue"
      end
    end
    add_message "google.api.expr.v1alpha1.SourceInfo" do
      optional :syntax_version, :string, 1, json_name: "syntaxVersion"
      optional :location, :string, 2, json_name: "location"
      repeated :line_offsets, :int32, 3, json_name: "lineOffsets"
      map :positions, :int64, :int32, 4
      map :macro_calls, :int64, :message, 5, "google.api.expr.v1alpha1.Expr"
    end
    add_message "google.api.expr.v1alpha1.SourcePosition" do
      optional :location, :string, 1, json_name: "location"
      optional :offset, :int32, 2, json_name: "offset"
      optional :line, :int32, 3, json_name: "line"
      optional :column, :int32, 4, json_name: "column"
    end
  end
end

module Cerbos::Protobuf::Google
  module Api
    module Expr
      module V1alpha1
        ParsedExpr = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.ParsedExpr").msgclass
        Expr = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr").msgclass
        Expr::Ident = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.Ident").msgclass
        Expr::Select = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.Select").msgclass
        Expr::Call = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.Call").msgclass
        Expr::CreateList = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.CreateList").msgclass
        Expr::CreateStruct = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.CreateStruct").msgclass
        Expr::CreateStruct::Entry = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.CreateStruct.Entry").msgclass
        Expr::Comprehension = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Expr.Comprehension").msgclass
        Constant = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.Constant").msgclass
        SourceInfo = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.SourceInfo").msgclass
        SourcePosition = ::Google::Protobuf::DescriptorPool.generated_pool.lookup("google.api.expr.v1alpha1.SourcePosition").msgclass
      end
    end
  end
end
