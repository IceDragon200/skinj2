#
# skinj2/lib/skinj2/interpreter/default.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
module Skinj2
  class DefaultInterpreter < InterpreterBase

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

    ## :nodoc:
    # define
    inst :define do
      vlog { |io| io.puts("DEFINE: #{param[:name]}") }
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
      vlog { |io| io.puts("INCLUDE: #{param[:filename]}") }
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
    end

  end
end
