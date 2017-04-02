# frozen_string_literal: true

require 'kaguya'
require 'optparse'
require 'pp'

module Kaguya
  class CLI
    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv.dup
      parser.parse!(@argv)
    end

    def run
      source_file = File.open(@argv[0], 'r')
      parser = Parser.new(source_file)
      ast = parser.parse

      if @debug
        puts '=== AST ==='
        pp ast
      end

      compiler = Compiler.new(ast)
      iseq = compiler.compile

      if @debug
        puts '=== ISEQ ==='
        pp iseq
        puts '=== RUN ==='
      end

      vm = VM.new(iseq)
      vm.run
    end

    private

    def parser
      @parser ||= OptionParser.new do |opts|
        opts.banner = 'kaguya'
        opts.version = Kaguya::VERSION
        opts.on('-d', '--debug') { |d| @debug = d }
      end
    end
  end
end
