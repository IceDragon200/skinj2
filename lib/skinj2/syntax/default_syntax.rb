#
# skinj2/lib/skinj2/syntax/default.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
module Skinj2
  module DefaultSyntax

    extend Syntax

    set_inst_entry '#-'

    ##
    # assert ruby_code
    lexi :assert,  /ASSERT\s+(?<condition>.+)/i

    ##
    # build filename
    lexi :build,   /BUILD\s+(?<filename>.+)/i

    ##
    # // comment
    lexi :comment, /\/\/(?<comment>.*)/i

    ##
    # define NAME or define NAME VALUE
    lexi :define,  /DEFINE\s+(?<name>\S+)(?:\s+(?<value>.+))?/i do |matchdata|
      { name: matchdata[:name], value: (matchdata[:value] || true) }
    end

    ##
    # echo string
    lexi :echo,    /ECHO\s+(?<string>.*)/i

    ##
    # eval ruby
    lexi :eval,    /EVAL\s+(?<code>.+)/i

    ##
    # halt
    lexi :halt,    /HALT/i

    ##
    # include filename
    lexi :include, /INCLUDE\s+(?<filename>.+)/i

    ##
    # jump label
    lexi :jump,    /JUMP\s+(?<label>.+)/i

    ##
    # label name
    lexi :label,   /LABEL\s+(?<name>.+)/i

    ##
    # log string
    lexi :log,     /LOG\s+(?<string>.+)/i

    ##
    # undef name
    lexi :undef,   /UNDEF\s+(?<name>\S+)/i

    ##
    # idepth
    #   increment the current sandbox depth
    lexi :idepth, /IDEPTH/i

    ##
    # ddepth
    #   decrement the current sandbox depth
    lexi :ddepth, /DDEPTH/i

  end
  module DefaultSyntaxCLike
    extend Syntax
    include DefaultSyntax
    set_inst_entry '#'
  end
end
