# frozen_string_literal: true

require 'ffi'

module Parrhasius
  module Hash
    extend FFI::Library
    ffi_lib File.expand_path('../parrhasius.so', __dir__)

    attach_function :ExtHash, [:string], :string

    class CallErr < StandardError; end

    module_function

    def call(filename)
      h = ExtHash(filename)
      raise CallErr, h[1..-1] if h.start_with?('E')

      h[1..-1] # Else it starts with "V"
    end
  end
end
