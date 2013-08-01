
task :default => [:copy]



def relative_path(p)
  File.expand_path(p, File.dirname(__FILE__))
end

$upstream_git_path     = 'git@github.com:rails/rails.git'
$pristine_git          = 'rails.git'
$pristine_git_path     = relative_path $pristine_git
$pristine_git_lib_path = File.join($pristine_git_path,'activesupport','lib')

$dest          = 'activesupport-core-ext'
$dest_path     = relative_path $dest
$dest_lib_path = File.join($dest_path,'lib')

$release_config       = 'cfg/releases'
$release_config_path  = relative_path $release_config




# Patch kernel require to detect as files get required, used in analyze method
module Kernel
  def require_and_note(string)
    $require_list ||= []
    $require_list << string
    require_original(string)
  end

  alias_method :require_original, :require
  alias_method :require, :require_and_note

end

def rake_methods
  the_methods = private_methods
  yield
  the_methods = private_methods - the_methods
  for method in the_methods
    eval("task :#{method.to_s.gsub(/rake_/,'')} do puts send(:#{method}) end")
  end
end
  
def git(cmd, *flags)
  gitflags = "--git-dir #{File.join($pristine_git, '.git')}"
  gitcmd   = "git #{gitflags} #{cmd}"
  if flags.include? :pipe
    `#{gitcmd}`
  else
    exec "#{gitcmd}"
  end
end


rake_methods do

  def rake_clone
    if  File.directory? $pristine_git_path \
    and File.directory? File.join($pristine_git_path, '.git')
      puts "Git repository exists in '#{$pristine_git}'"
    else
      exec "git clone '#{$upstream_git_path}' '#{$pristine_git}'"
    end
  end

  def rake_branches
    ary = (git "branch -r", :pipe).split(/\r?\n/).map { |x| x.gsub(/^\s*/,'') }
    
    # Add ability to easily select matching branches with method_missing
    class << ary
      def matching(re)
        self.select{|x| x=~re}
      end
      def method_missing(meth, *args, &block)
        result = self.matching(/#{meth}/)
        result.empty? ? super : result
      end
    end
    
    ary
  end

  def rake_releases
    result = rake_branches.stable.reverse
  end

  def rake_chosen_releases
    `touch #{$release_config_path}` unless File.file? $release_config_path
    File.read($release_config_path).split(/\r?\n/) & rake_releases
  end

  def rake_ignored_releases
    `touch #{$release_config_path}` unless File.file? $release_config_path
    rake_releases - File.read($release_config_path).split(/\r?\n/)
  end

  def rake_fetch_releases
    for release in rake_chosen_releases
      puts "Fetching #{release}"
      puts git "fetch #{release.split('/').join(' ')}", :pipe
    end
  nil end

  def rake_trace_requires
    $LOAD_PATH.unshift($pristine_git_lib_path)
    # begin
    $require_list = []
    require 'active_support/core_ext'
    
    $require_list.uniq!
                 .map! { |path| File.expand_path(path+'.rb', $pristine_git_lib_path) }
                 .select! { |path| File.file? path }
                 .sort!
    
    $require_list
  end
  
  def rake_copy
    for path in rake_trace_requires
      # `cp #{path} #{path.gsub($pristine_git_lib_path,$dest_lib_path)}`
      newdir = File.dirname(path.gsub($pristine_git_lib_path,$dest_lib_path))
      puts path.gsub($pristine_git_lib_path,'')
      `mkdir -p #{newdir}`
      `cp #{path} #{newdir}`
    end
    nil
  end
  
end
