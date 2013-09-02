
$require_list = []
$pristine_git_lib_path = ARGV[0]

# Patch kernel require to detect as files get required, used in analyze method
module Kernel
  def require_and_note(string)
    $require_list << string
    require_original(string)
  end
  
  alias_method :require_original, :require
  alias_method :require, :require_and_note
  
end


$LOAD_PATH.unshift($pristine_git_lib_path)
$require_list = []

# require the parent file which loads child files
require 'active_support/core_ext'
# some additional parts of activesupport that prove troublesome if left out
require 'active_support/json'


$require_list.uniq!
             .map! { |path| File.expand_path(path+'.rb', $pristine_git_lib_path) }
             .select! { |path| File.file? path }
             .sort!

puts Marshal.dump($require_list)