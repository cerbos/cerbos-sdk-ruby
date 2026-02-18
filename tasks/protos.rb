# frozen_string_literal: true

require "parallel"
require "rake/file_utils"

module Tasks
  module Protos
    BUF_MODULES = [
      ["buf.build/cerbos/cerbos-api"],
      ["--exclude-imports", "buf.build/cerbos/cloud-api"],
      ["buf.build/grpc/grpc"]
    ].freeze

    ROOT_PATH = File.expand_path("../proto", __dir__)

    class << self
      include FileUtils

      def call
        clean

        Parallel.each BUF_MODULES, in_threads: BUF_MODULES.size do |buf_module|
          export buf_module
        end
      end

      private

      def clean
        rm_rf ROOT_PATH
      end

      def export(buf_module)
        sh "buf", "export", "--output=#{ROOT_PATH}", *buf_module
      end
    end
  end
end
