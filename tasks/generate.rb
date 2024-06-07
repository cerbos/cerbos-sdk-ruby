# frozen_string_literal: true

require "rake/file_utils"

module Tasks
  module Generate
    ROOT_PATH = File.expand_path("../lib/cerbos/protobuf", __dir__)

    class << self
      include FileUtils

      def call
        clean
        generate
        postprocess
      end

      private

      def clean
        rm_rf ROOT_PATH
      end

      def generate
        sh "buf", "generate", "--include-imports", "--output", ROOT_PATH
      end

      def postprocess
        # Nest generated modules under Cerbos::Protobuf
        Dir.glob "#{ROOT_PATH}/**/*.rb" do |file_path|
          contents = File.read(file_path)

          contents.gsub! %r{(?<=^require ')[^']+(?=')} do |require_path|
            case require_path
            when "grpc", %r{^google/protobuf($|/)}
              require_path
            else
              "cerbos/protobuf/#{require_path}"
            end
          end

          contents.gsub! %r{(?<=^module )|(?<=, ::)|(?<=, stream\(::)}, "Cerbos::Protobuf::"

          File.write file_path, contents
        end
      end
    end
  end
end
