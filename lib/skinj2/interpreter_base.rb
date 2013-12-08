#
# skinj2/lib/skinj2/interpreter.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
module Skinj2
  class InterpreterBase

    class LabelError < Exception ; end
    class NegativeDepth < RuntimeError ; end

    ### class_variables
    @@interpreters = {} # Hash<String name, InterpreterBase* interpreter_class>

    ### instance_variables
    attr_reader :depth         # Integer
    attr_reader :parent        # Interpreter
    attr_reader :result        # Array<String> : current string stack
    attr_reader :variables     # Array<Hash<String, String>>
    attr_reader :sandbox_depth # Integer
    attr_accessor :syntax      # Syntax
    attr_accessor :vlog        # IO
    attr_accessor :my_path     # String : Path
    attr_reader :in_file       # String : Current file being processed

    ##
    # in_file=(String new_filename)
    def in_file=(new_filename)
      @in_file = new_filename
      set_variable("%_skj_file_%", new_filename)
    end

    ##
    # initialize
    def initialize(depth=0, parent=nil)
      @syntax = DefaultSyntax # just for sub interpreters
      @depth  = depth
      @parent = parent
      @vlog   = nil    # Verbose log output
      @variables = []
      @sandbox_depth = 0
      @my_path = [Dir.getwd]
      @in_file = nil
    end

    ##
    # path
    def path
      if @parent
        return @my_path | @parent.my_path
      else
        return @my_path
      end
    end

    ##
    # mk_sub_interpreter
    #   create a new sub-interpreter from the current
    def mk_sub_interpreter
      intp = self.class.new(@depth + 1, self)
      intp.syntax = @syntax
      intp.vlog = @vlog
      return intp
    end

    ##
    # increment_sandbox
    def increment_sandbox
      @sandbox_depth += 1
      @variables[@sandbox_depth] = {}
    end

    ##
    # decrement_sandbox
    def decrement_sandbox
      @variables[@sandbox_depth] = nil
      @sandbox_depth -= 1
      raise NegativeDepth, "sandbox_depth has been set below 0" if @sandbox_depth < 0
    end

    ##
    # get_variables_by_depth(depth)
    def get_variables_by_depth(depth=@sandbox_depth)
      @variables[depth] ||= {}
    end

    ##
    # each_variables_with_depth { |hsh, i| }
    def each_variables_with_depth
      @sandbox_depth.downto(0) do |i|
        if hsh = @variables[i]
          yield hsh, i
        end
      end
    end

    ##
    # get_variable(name)
    #   Retrieve the value of the defined variable (name)
    def get_variable(name)
      each_variables_with_depth do |hsh, i|
        return hsh.fetch(name) if hsh.key?(name)
      end
      return @parent && @parent.get_variable(name)
    end

    ##
    # set_variable(name)
    #   Sets the value of the variable (name)
    def set_variable(name, val)
      get_variables_by_depth[name] = val
    end

    ##
    # unset_variable(name)
    #   Deletes the variable (name)
    def unset_variable(name, all=true)
      each_variables_with_depth do |hsh, i|
        hsh.delete(name)
      end
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
    # setup_data(data)
    def setup_data(data)
      setup(syntax.tokenize(data))
    end

    ##
    # setup_file(filename)
    def setup_file(org_fn)
      wpth = path.find do |src_pth|
        pth = File.expand_path(org_fn, src_pth)
        File.exists?(pth)
      end
      if wpth
        fn = File.expand_path(org_fn, wpth)
        vlog { |io| io.puts("setup_file: found #{fn}") }
        stre = File.read(fn)
        data = Skinj2.str_to_list(stre)
        setup_data(data)
        self.in_file = fn
      else
        vlog { |io| io.puts("setup_file: not found #{org_fn}") }
        raise Errno::ENOENT, org_fn
      end
    end

    ##
    # setup_label_table
    def setup_label_table
      @label_table = {}
      @list.each_with_index do |hsh, i|
        if token = hsh[:token]
          @label_table[token[1][:name]] = i if token[0] == :label
        end
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

    ## TODO
    # ppush(String string)
    #   Replaces contents of the string with defined values if available
    def ppush(string)
      str = string.dup
      each_variables_with_depth do |hsh, i|
        hsh.each_pair do |k, v|
          str.gsub!(k, v)
        end
      end
      push(str)
    end

    ##
    # append(Array<String> array)
    def append(array)
      @result.concat(array)
    end

    ##
    # item
    #   returns the current element in the list
    def item
      @list[@index]
    end

    ##
    # line_raw -> String
    def line_raw
      item[:raw]
    end

    ##
    # line_no -> Integer
    def line_no
      item[:line]
    end

    ##
    # token
    #   returns the current token
    def token
      item[:token][0]
    end

    ##
    # param
    #   returns the current param
    def param
      item[:token][1]
    end

    ##
    # run
    def run
      @terminated = false
      @interrupt  = false
      begin
        while @index < @list.size
          if (inst_name = instruction[token])
            send(inst_name)
          else
            ppush(param) if param
          end
          break if @interrupt || @terminate
          @index += 1
        end
      rescue => ex
        STDERR.puts "!!! #{in_file}:#{line_no rescue -1} | skinj-error: (#{line_raw})"
        raise ex
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
    # ::inst(String|Symbol name) { do_stuff }
    #   Create a new Interpreter instruction
    def self.inst(name, &func)
      define_method(self.instruction[name] = "inst_#{name}".to_sym, &func)
    end

    ##
    # ::register(String name)
    #   Used in subclasses for registering interpreters for use in the command
    #   line tool
    def self.register(name)
      @@interpreters[name] = self
    end

    ##
    # ::get_interpreter(String name)
    def self.get_interpreter(name)
      return @@interpreters[name]
    end

    private :instruction
    private :get_variables_by_depth

  end
end

require 'skinj2/interpreter/default_interpreter'
