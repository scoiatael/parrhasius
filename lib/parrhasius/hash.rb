# frozen_string_literal: true

require 'ffi'

module Parrhasius
  module Hash # rubocop:todo Style/Documentation
    extend FFI::Library
    ffi_lib File.expand_path('../parrhasius.so', __dir__)

    class ExtHashReturn < FFI::Struct
      layout :value, :string,
             :error, :string
    end

    attach_function :ExtHash, [:string], ExtHashReturn.by_value

    class CallErr < StandardError; end

    module_function

    def call(filename)
      h = ExtHash(filename)
      raise CallErr, "on #{filename}: #{h[:error]}" unless h[:error].nil?

      h[:value]
    end
  end
end
