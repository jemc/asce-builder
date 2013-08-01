
task :default => [:fetch]

def relative_path(p)
  File.expand_path(p, File.dirname(__FILE__))
end

$upstream_git_path = 'git@github.com:rails/rails.git'
$pristine_git      = 'rails.git'
$pristine_git_path = relative_path $pristine_git

$release_config       = 'cfg/releases'
$release_config_path  = relative_path $release_config

def git(cmd, *flags)
  gitflags = "--git-dir #{File.join($pristine_git, '.git')}"
  gitcmd   = "git #{gitflags} #{cmd}"
  if flags.include? :pipe
    `#{gitcmd}`
  else
    exec "#{gitcmd}"
  end
end

def git_clone
  exec "git clone '#{$upstream_git_path}' '#{$pristine_git}'" \
    unless File.directory? $pristine_git_path \
    and    File.directory? File.join($pristine_git_path, '.git')
end

# def git_refs
#   ary = (git "show-ref", :pipe).scan(/([^ ]+) ([^\n]+)\n/)
#                                .map{ |a| a.reverse }
#                                .sort
  
#   # Add ability to easily select matching branches with method_missing
#   class << ary
#     def stable
#       self.matching(/remotes.*stable/)
#     end
#     def matching(re)
#       self.select{|x| x[0]=~re}
#     end
#     def method_missing(meth, *args, &block)
#       result = self.matching(/#{meth}/)
#       result.empty? ? super : result
#     end
#   end
  
#   ary
# end

def git_branches
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

def git_releases
  result = git_branches.stable.reverse
end

def chosen_git_releases
  `touch #{$release_config_path}` unless File.file? $release_config_path
  File.read($release_config_path).split(/\r?\n/) & git_releases
end

task :fetch do
  p chosen_git_releases
  for release in git_releases
    puts "fetch #{release.split('/').join(' ')}"
  end
end

task :releases         do puts git_releases         end

task :chosen_releases  do puts chosen_git_releases  end

task :ignored_releases do puts ignored_git_releases end

task :checkout do
  git "fetch   origin 4-0-stable #{git_refs.stable.last[0]}"
  git "checkout #{git_refs.stable.last[0]}"
end

# task :hg_convert do
#   puts "hg convert #{$pristine_git} #{$dest_hg}"\
#        " --filemap file.map --splicemap splice.map"
# end

$require_list = []

module Kernel
  def require_and_note(string)
    $require_list << string
    require_original(string)
  end

  alias_method :require_original, :require
  alias_method :require, :require_and_note

end

def file_requires(str, prefix="#{$pristine_git_path}/activesupport/lib")
  path = File.join(prefix, str)+'.rb'
  puts File.read path
end

task :analyze do
  lib_dir = File.join($pristine_git_path,'activesupport','lib')
  $LOAD_PATH.unshift(lib_dir)
  # begin
  require 'active_support/core_ext'
  # rescue; end
  $require_list.map! { |p| File.expand_path(p, lib_dir) }
               .select! { |p| File.file? p }
  
  puts $require_list
end