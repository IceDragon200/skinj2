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
    lexi :comment, /\/\/(.*)/i

    ##
    # define NAME or define NAME, VALUE
    lexi :define,  /DEFINE\s+(?<name>\S+)(?:\s*,\s*(?<value>))?/i do |matchdata|
      { name: matchdata[:name], value: (matchdata[:value] || true) }
    end

    ##
    # eval ruby
    lexi :eval,    /EVAL\s+(?<code>)/i

    ##
    # halt
    lexi :halt,    /HALT/i

    ##
    # include filename
    lexi :include, /INCLUDE\s+(?<path>)/i

    ##
    # jump label
    lexi :jump,    /JUMP\s+(?<label>.+)/i

    ##
    # label name
    lexi :label,   /LABEL\s+(?<name>.+)/i

    ##
    # log string
    lexi :log,     /LOG\s+(?<string>)/i

    ##
    # undef name
    lexi :undef,   /UNDEF\s+(?<name>\S+)/i

  end
end
