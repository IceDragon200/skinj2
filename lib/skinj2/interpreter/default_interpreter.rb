#
# skinj2/lib/skinj2/interpreter/default.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
module Skinj2
  class DefaultInterpreter < InterpreterBase

    def initialize(depth=0, parent=nil)
      super(depth, parent)
      self.syntax = Skinj2::DefaultSyntax
    end

    ##
    # assert
    #   Ensures that (condition) evaluates as true, otherwise aborts the
    #   operation
    inst :assert do
      vlog { |io| io.puts("ASSERT: #{param[:condition]}") }
      terminate unless eval(param[:condition]) rescue false
    end

    ##
    # build
    #   Takes the current rendered stack and writes it to (filename)
    inst :build do
      vlog { |io| io.puts("BUILD: #{param[:filename]}") }
      File.write(param[:filename], render)
    end

    ##
    # comment
    #   Does not affect the Skinj render process
    inst :comment do
      vlog { |io| io.puts("COMMENT: #{param[:comment]}") }
    end

    ##
    # define
    #   define an internal value within the current interpreter
    inst :define do
      vlog { |io| io.puts("DEFINE: #{param[:name]} #{param[:value]}") }
      set_variable(param[:name], param[:value])
    end

    ##
    # echo
    #   Prints the string through STDERR to the console
    inst :echo do
      vlog { |io| io.puts("ECHO: #{param[:string]}") }
      STDERR.puts param[:string]
    end

    ##
    # eval
    #   Evaluates (string) as a ruby program and renders the result
    inst :eval do
      vlog { |io| io.puts("EVAL: #{param[:code]}") }
      push(eval(param[:code]))
    end

    ##
    # halt
    inst :halt do
      vlog { |io| io.puts("HALT") }
      interrupt
    end

    ##
    # include
    #   File (filename) is loaded, the current Interpreter is duplicated and
    #   renders the file into the current result
    inst :include do
      #                         remove whitespace                  |remove quotes
      org_fn = param[:filename].gsub("\A\s+", "").gsub("\s+\z", "").delete('"').delete("'")
      vlog { |io| io.puts("INCLUDE: #{param[:filename]}") }
      intp = mk_sub_interpreter
      if in_file
        intp.my_path << File.expand_path(File.dirname(in_file), Dir.getwd)
      end
      intp.setup_file(org_fn)
      append(intp.run.result)
    end

    ##
    # jump
    #   Causes the interpreter to jump to a label, ignoring content in between
    #   the jump point
    inst :jump do
      vlog { |io| io.puts("JUMP: #{param[:label]}") }
      set_index(label_index(param[:label]))
    end

    ##
    # label
    #   First Order instruction, defines a label for the current context
    #   used for <jump> instruction
    inst :label do
      vlog { |io| io.puts("LABEL: #{param[:label]}") }
    end

    ##
    # log
    #   Prints information to the console, for debugging purposes, does not
    #   affect rendering
    inst :log do
      vlog { |io| io.puts("LOG: #{param[:string]}") }
      STDOUT.puts(param[:string])
    end

    ## :nodoc:
    # undef
    inst :undef do
      vlog { |io| io.puts("UNDEF: #{param[:name]}") }
      unset_variable(param[:name])
    end

    ##
    #
    inst :idepth do
      increment_sandbox
      vlog { |io| io.puts("IDEPTH: #{sandbox_depth}") }
    end

    ##
    # ddepth
    inst :ddepth do
      decrement_sandbox
      vlog { |io| io.puts("DDEPTH: #{sandbox_depth}") }
    end

    ##
    # null
    inst :null do
      vlog { |io| io.puts("NULL: ---") }
    end

    register('default')

  end
end
