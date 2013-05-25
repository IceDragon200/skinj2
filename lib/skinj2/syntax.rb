#
# skinj2/lib/skinj2/syntax.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
# A Skinj syntax, is essentially a Skinj Lexer / Tokenizer
module Skinj2
  module Syntax

    ##
    # set_inst_entry(new_str)
    def set_inst_entry(new_str)
      @inst_entry = new_str
    end

    ##
    # syntax -> Array
    def syntax
      @syntax ||= []
    end

    ##
    # lexi(Symbol sym, Regexp regexp)
    # lexi(Symbol sym, Regexp regexp) { |matchdata| Hash }
    #   :data is a reserved symbol for anything else that isn't a Skinj token.
    #   NOTE malformed instructions will be ignored
    def lexi(sym, regexp, &func)
      default_func = ->(matchdata) do
        Hash[matchdata.names.map { |n| [n.to_sym, matchdata[n]] }]
      end
      self.syntax.push([sym, regexp, func || default_func])
    end

    ##
    # tokenize(Array<String> list)
    #   tokenizes the array of strings
    def tokenize(list)
      list.map do |str|
        newstr = str.dup
        if newstr.gsub(/\A\s+/, '').start_with?(@inst_entry)
          token = nil
          syntax.each do |(symbol, regexp, tokenfix)|
            if mtchdata = str.match(regexp)
              token = [symbol, tokenfix.(mtchdata)]
              break
            end
          end
          token
        else
          [:data, newstr]
        end
      end
    end

  end
end

require 'skinj2/syntax/default_syntax.rb'
