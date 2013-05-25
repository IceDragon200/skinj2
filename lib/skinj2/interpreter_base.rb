#
# skinj2/lib/skinj2/interpreter.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
module Skinj2
  class InterpreterBase

    class LabelError < Exception ; end

    ## instance_variables
    attr_reader :depth  # Integer
    attr_reader :parent # Interpreter
    attr_writer :vlog   # IO

    ##
    # initialize
    def initialize(depth=0, parent=nil)
      @depth  = depth
      @parent = parent
    end

    ##
    # instruction
    def instruction
      self.class.instruction
    end

    ##
    # setup(Array<Token> tokenlist)
    def setup(tokenlist)
      @index  = 0
      @list   = tokenlist
      @result = []
      setup_label_table
      self
    end

    ##
    # setup_label_table
    def setup_label_table
      @label_table = {}
      @list.each_with_index do |itm, i|
        @label_table[itm[1][:name]] = i if itm[0] == :label
      end
    end

    ##
    # label_index(String label) -> Integer
    def label_index(label)
      raise(LabelError,
            "invalid label #{label}") unless @label_table.has_key?(label)
      @label_table[label]
    end

    ##
    # set_index(Integer new_index)
    def set_index(new_index)
      @index = new_index
    end

    ##
    # interrupt
    def interrupt
      @interrupt = true
    end

    ##
    # terminate
    #   terminates the interpreter and cancels rendering
    def terminate
      @terminated = true
    end

    ##
    # push(String string)
    #   Pushes the string unto the result stack
    def push(string)
      @result.push(string)
    end

    ##
    # item
    #   returns the current element in the list
    def item
      @list[@index]
    end

    ##
    # token
    #   returns the current token
    def token
      item[0]
    end

    ##
    # param
    #   returns the current param
    def param
      item[1]
    end

    ##
    # run
    def run
      @terminated = false
      @interrupt  = false
      while @index < @list.size
        (inst_name = instruction[token]) ? send(inst_name) : push(param)
        break if @interrupt || @terminate
        @index += 1
      end
      @result.clear if @terminate
      self
    end

    ##
    # render
    #   Renders the result as a single string
    def render
      @result.join("\n")
    end

    ##
    # vlog { |io| write_something_to_io } -> IO
    #   Verbose log IO, the block will only be executed if the IO exists
    def vlog
      yield @vlog if @vlog
      @vlog
    end

    ##
    # ::instruction -> Hash<Symbol instruction_symbol, String method_name>
    def self.instruction
      @instruction ||= {}
    end

    ##
    # ::inst
    #   Create a new Interpreter instruction
    def self.inst(name, &func)
      define_method(self.instruction[name] = "inst_#{name}".to_sym, &func)
    end

    private :instruction

  end
end

require 'skinj2/interpreter/default_interpreter.rb'
