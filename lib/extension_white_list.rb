#
# Used to control error message formatting 
# when used in a Carrierwave Uploader
# See extension_white_list in any Uploader Model 
#
class ExtensionWhiteList < Array
  def inspect
    join ', '
  end
end