# frozen_string_literal: true

module Kaguya
  class Compiler
    # @param [AST::Node] ast
    def initialize(ast)
      @ast = ast
    end

    # @return [Array]
    def compile
      iseq = @ast.accept(self)
      iseq << [:leave, nil]
      iseq
    end

    # @param [AST::Node] node
    # @return [Array]
    def visit(node)
      iseq = []

      case node.type
      when :forward
        iseq << [:forward, nil]
      when :backward
        iseq << [:backward, nil]
      when :increment
        iseq << [:increment, nil]
      when :decrement
        iseq << [:decrement, nil]
      when :output
        iseq << [:output, nil]
      when :input
        iseq << [:input, nil]
      when :while
        sub_iseq = []

        node.children.each do |child|
          sub_iseq.concat(child.accept(self))
        end

        iseq << [:branch_ifzero, sub_iseq.size + 2]
        iseq.concat(sub_iseq)
        iseq << [:branch_unlesszero, -sub_iseq.size]
      when :root
        node.children.each do |child|
          iseq.concat(child.accept(self))
        end
      else
        raise 'Invalid node!'
      end

      iseq
    end
  end
end
