#
# skinj2/test/test-suite.rb
#   dc 25/04/2013
#   dm 25/04/2013
$: << File.dirname(__FILE__)
$: << File.join(Dir.getwd, "..", "lib")
require 'test/unit'
require 'skinj2'

class Skinj2Test < Test::Unit::TestCase

  def test_syntax
    data = Skinj2.str_to_list(File.read('data/test01.txt'))
    Skinj2::DefaultSyntax.tokenize(data)
  end

  def test_interpreter
    data = Skinj2.str_to_list(File.read('data/test01.txt'))
    tokenlist = Skinj2::DefaultSyntax.tokenize(data)
    interpreter = Skinj2::DefaultInterpreter.new
    #interpreter.vlog = STDOUT
    interpreter.setup(tokenlist)
    interpreter.run
    File.write("data/test01.txt.skj2", interpreter.render)
  end

end
