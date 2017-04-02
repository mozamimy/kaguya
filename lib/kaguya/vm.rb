# frozen_string_literal: true

require 'pp'

module Kaguya
  class VM
    # @param [Array] iseq
    def initialize(iseq)
      @iseq = iseq
      @pc = 0
      @left_stack = [0]
      @right_stack = []
    end

    def run
      loop do
        instruction = fetch(@pc)
        execute(instruction)
      end
    end

    private

    # @param [Integer] pc
    # @return [Integer]
    def fetch(pc)
      @iseq[pc]
    end

    # @param [Array] instruction
    def execute(instruction)
      case instruction[0]
      when :forward
        if @right_stack.size < 1
          @left_stack.push(0)
        else
          @left_stack.push(@right_stack.pop)
        end
        @pc += 1
      when :backward
        @right_stack.push(@left_stack.pop)
        @pc += 1
      when :increment
        @left_stack.push(@left_stack.pop + 1)
        @pc += 1
      when :decrement
        @left_stack.push(@left_stack.pop - 1)
        @pc += 1
      when :output
        value = @left_stack.pop
        STDOUT.print(value.chr)
        @left_stack.push(value)
        @pc += 1
      when :input
        @left_stack.pop
        @left_stack.push(STDIN.getc.ord)
        @pc += 1
      when :branch_ifzero
        value = @left_stack.pop
        @left_stack.push(value)
        if value.zero?
          @pc += instruction[1]
        else
          @pc += 1
        end
      when :branch_unlesszero
        value = @left_stack.pop
        @left_stack.push(value)
        if !value.zero?
          @pc += instruction[1]
        else
          @pc += 1
        end
      when :leave
        exit 0
      else
        raise "Unknown instruction #{instruction[0]}"
      end
    rescue => e
      pp @left_stack
      pp @right_stack
      raise(e)
    end
  end
end
