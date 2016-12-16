module Casset
  class Dsl
    def self.load(filename = 'Cassetfile')
      Dsl.new do
        instance_eval File.read(filename), filename
      end
    end

    def initialize(dirname = nil, &block)
      FileUtils.mkdir_p dirname unless dirname.nil?
      @dirname = dirname

      puts "[#{dirname}]" unless dirname.nil?
      instance_eval &block if block_given?
    end

    def dir(dirname, &block)
      Dsl.new @dirname.nil? ? dirname : File.join(@dirname, dirname), &block
    end

    def info
      p self
    end
  end
end

require_relative 'dsl/xcassets'
