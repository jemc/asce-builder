
task :default => [:clone_upstream]

$upstream_git_path = 'git@github.com:rails/rails.git'
$pristine_git      = 'rails.git'
$pristine_git_path = File.expand_path($pristine_git, File.dirname(__FILE__))

task :clone_upstream do
  exec "git clone '#{$upstream_git_path}' '#{$pristine_git}'" \
    unless File.directory? $pristine_git_path \
    and    File.directory? File.join($pristine_git_path, '.git')
end
