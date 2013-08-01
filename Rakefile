
task :default => [:releases]

$upstream_git_path = 'git@github.com:rails/rails.git'
$pristine_git      = 'rails.git'
$pristine_git_path = File.expand_path($pristine_git, File.dirname(__FILE__))

def git(cmd, *flags)
  gitflags = "--git-dir #{File.join($pristine_git, '.git')}"
  gitcmd   = "git #{gitflags} #{cmd}"
  if flags.include? :pipe
    `#{gitcmd}`
  else
    exec "#{gitcmd}"
  end
end

def git_branches
  ary = (git "show-ref", :pipe).scan(/([^ ]+) ([^\n]+)\n/)
                               .map{ |a| a.reverse }
                               .sort
  
  # Add ability to easily select matching branches with method_missing
  class << ary
    def stable
      self.matching(/remotes.*stable/)
    end
    def matching(re)
      self.select{|x| x[0]=~re}
    end
    def method_missing(meth, *args, &block)
      result = self.matching(/#{meth}/)
      result.empty? ? super : result
    end
  end
  
  ary
end

def git_clone
  exec "git clone '#{$upstream_git_path}' '#{$pristine_git}'" \
    unless File.directory? $pristine_git_path \
    and    File.directory? File.join($pristine_git_path, '.git')
end

def git_releases
  git_branches.stable.map { |x| x[0].match(/(.-.)-stable/)[1] }
end

# git "checkout master"
# git "pull #{git_branches.stable.last[0]}"

task :releases do
  puts git_branches.matching(/remotes.*stable/)
                   .map { |x| x[0].match(/(.-.)-stable/)[1] }
end

task :checkout do
  git "checkout #{git_branches.stable.last[0]}"
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