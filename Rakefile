
task :default => [:git_read]

$upstream_git_path = 'git@github.com:rails/rails.git'
$pristine_git      = 'rails.git'
$pristine_git_path = File.expand_path($pristine_git, File.dirname(__FILE__))
$dest_hg           = 'rails.hg'
$dest_hg_path      = File.expand_path($dest_hg, File.dirname(__FILE__))

def git(cmd, *flags)
  gitflags = "--git-dir #{File.join($pristine_git, '.git')}"
  gitcmd   = "git #{gitflags} #{cmd}"
  if flags.include? :pipe
    `#{gitcmd}`
  else
    exec "#{gitcmd}"
  end
end

task :git_clone do
  exec "git clone '#{$upstream_git_path}' '#{$pristine_git}'" \
    unless File.directory? $pristine_git_path \
    and    File.directory? File.join($pristine_git_path, '.git')
end

task :git_read do
  ref_hash = {}
  (git "show-ref", :pipe).scan(/([^ ]+) ([^\n]+)\n/)
                         .each{ |a| ref_hash[a[1]] = a[0] }
  p ref_hash.select{|k,v| k=~/remote/ and k=~/stable/ }
  p ref_hash.keys.size
  p ref_hash.keys.uniq.size
  p ref_hash.values.size
  p ref_hash.values.uniq.size
end

task :hg_convert do
  puts "hg convert #{$pristine_git} #{$dest_hg}"\
       " --filemap file.map --splicemap splice.map"
end