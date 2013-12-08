#
# skinj2/lib/skinj2.rb
#   by IceDragon
#   dc 24/05/2013
#   dm 24/05/2013
module Skinj2

  ##
  # ::str_to_list(String str) -> Array<String>
  #   Grabs each line in the string and removes the new line character
  def self.str_to_list(str)
    str.each_line.map { |l| l.delete("\n") }
  end

end
