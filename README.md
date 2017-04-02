# Kaguya

Kaguya is an implementation of Brainf\*\*k by Ruby.

This implementation consits of following elements,

- Tiny parser
- Tiny compiler
- Tiny virtual stack machine

## Installation

```
$ gem install kaguya
```

## Usage

```
$ kaguya helloworld.bf
```

An option `--debug` helps you to see AST and instruction sequence.

```
$ kaguya --debug helloworld.bf
```

## Technical components

### Parser

https://github.com/mozamimy/kaguya/blob/master/lib/kaguya/parser.rb

The parser parses a BF script one charactor at a time. Errors can be raised by the parser if the script contains invalid corresponding of `[` and `]` or invalid charactors.

Only the root node and `while` nodes have children.

### Virtual machine

Kaguya VM has a two stacks (left\_stack, right\_stack) and has following 9 instructions,

- `forward`: Forward stack, if right\_stack is empty then push 0 to left\_stack else move top of right\_stack to left\_stack.
- `backward`: Backward stack, top data of left\_stack is poped and pushed to right\_stack.
- `increment`: Increment top of left\_stack.
- `decrement`: Decrement top of left\_stack.
- `output`: Output top of left\_stack to standard I/O.
- `input`: Input a value from standard I/O and push it to left\_stack.
- `branch_ifzero N`: Jump to an instruction at `PC - N` if top of left\_stack is 0.
- `branch_unlesszero N`: Jump to an instruction at `PC - N` unless top of left\_stack is 0.
- `leave`: Exit

### Compiler

Kaguya compiler compiles an AST generated by the parser to an instruction sequence for Kaguya VM.

### Example

```
[20:17:51]mozamimy@queen:kaguya (master) (-'x'-).oO(
> cat example/useless.bf
>>+[<>[+-]]
[20:17:53]mozamimy@queen:kaguya (master) (-'x'-).oO(
> be exe/kaguya --debug example/useless.bf
=== AST ===
#<Kaguya::AST::Node:0x007fd755a3f8c0
 @children=
  [#<Kaguya::AST::Node:0x007fd755a3f780
    @children=[],
    @parent=#<Kaguya::AST::Node:0x007fd755a3f8c0 ...>,
    @type=:forward>,
   #<Kaguya::AST::Node:0x007fd755a3f500
    @children=[],
    @parent=#<Kaguya::AST::Node:0x007fd755a3f8c0 ...>,
    @type=:forward>,
   #<Kaguya::AST::Node:0x007fd755a3f230
    @children=[],
    @parent=#<Kaguya::AST::Node:0x007fd755a3f8c0 ...>,
    @type=:increment>,
   #<Kaguya::AST::Node:0x007fd755a3f028
    @children=
     [#<Kaguya::AST::Node:0x007fd755a3edd0
       @children=[],
       @parent=#<Kaguya::AST::Node:0x007fd755a3f028 ...>,
       @type=:backward>,
      #<Kaguya::AST::Node:0x007fd755a3e7e0
       @children=[],
       @parent=#<Kaguya::AST::Node:0x007fd755a3f028 ...>,
       @type=:forward>,
      #<Kaguya::AST::Node:0x007fd755a3e5b0
       @children=
        [#<Kaguya::AST::Node:0x007fd755a3e3f8
          @children=[],
          @parent=#<Kaguya::AST::Node:0x007fd755a3e5b0 ...>,
          @type=:increment>,
         #<Kaguya::AST::Node:0x007fd755a3e1f0
          @children=[],
          @parent=#<Kaguya::AST::Node:0x007fd755a3e5b0 ...>,
          @type=:decrement>],
       @parent=#<Kaguya::AST::Node:0x007fd755a3f028 ...>,
       @type=:while>],
    @parent=#<Kaguya::AST::Node:0x007fd755a3f8c0 ...>,
    @type=:while>],
 @parent=nil,
 @type=:root>
=== ISEQ ===
[[:forward, nil],
 [:forward, nil],
 [:increment, nil],
 [:branch_ifzero, 8],
 [:backward, nil],
 [:forward, nil],
 [:branch_ifzero, 4],
 [:increment, nil],
 [:decrement, nil],
 [:branch_unlesszero, -2],
 [:branch_unlesszero, -6],
 [:leave, nil]]
=== RUN ===
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mozamimy/kaguya.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
