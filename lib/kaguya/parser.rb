# frozen_string_literal: true

module Kaguya
  class Parser
    # @param [IO] input
    def initialize(input)
      @input = input
    end

    # @return [AST::Node]
    def parse
      root = AST::Node.new(type: :root, parent: nil)
      current_node = root
      context_level = 0

      @input.each_char do |ch|
        case ch
        when '>'
          AST::Node.new(type: :forward, parent: current_node)
        when '<'
          AST::Node.new(type: :backward, parent: current_node)
        when '+'
          AST::Node.new(type: :increment, parent: current_node)
        when '-'
          AST::Node.new(type: :decrement, parent: current_node)
        when '.'
          AST::Node.new(type: :output, parent: current_node)
        when ','
          AST::Node.new(type: :input, parent: current_node)
        when '['
          context_level += 1
          current_node = AST::Node.new(type: :while, parent: current_node)
        when ']'
          context_level -= 1
          current_node = current_node.parent
        when ' ', "\n", "\r"
          # read next charactor
        else
          raise "Invalid charactor `#{ch}`."
        end
      end

      if context_level != 0
        raise 'Invalid brace correspondence.'
      end

      root
    end
  end
end
