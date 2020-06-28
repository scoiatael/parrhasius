require 'logger'

LOGGER = Logger.new(STDOUT)
module Parrhasius
    module Log
        class << self
            [:debug, :info, :warn].each do |item|
                define_method(item) do |*args|
                    LOGGER.send(item, *args)
                end
            end
        end
    end
end