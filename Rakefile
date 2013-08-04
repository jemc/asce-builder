
task :default => [:build_all]



def relative_path(p)
  File.expand_path(p, File.dirname(__FILE__))
end

$upstream_git_path     = 'git@github.com:rails/rails.git'
$pristine_git          = 'rails.git'
$pristine_git_path     = relative_path $pristine_git
$pristine_git_lib_path = File.join($pristine_git_path,'activesupport','lib')
$pristine_git_core_ext_path = \
               File.join($pristine_git_lib_path,'active_support','core_ext')

$dest          = 'activesupport-core-ext'
$dest_path     = relative_path $dest
$dest_lib_path = File.join($dest_path,'lib')

$release_config       = 'cfg/releases'
$release_config_path  = relative_path $release_config
$tracer_rb            = 'cfg/trace_requires.rb'
$tracer_rb_path       = relative_path $tracer_rb

$version_file = 'RAILS_VERSION'
$version_file_path = File.join($pristine_git_path, $version_file)
$gemspec_file = 'activesupport/activesupport.gemspec'
$gemspec_file_path = File.join($pristine_git_path, $gemspec_file)


$require_list    = []
$additional_list = []

$verbose = true



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
    $require_list = Marshal.load(`ruby '#{$tracer_rb_path}' '#{$pristine_git_lib_path}'`)
  end
  
  def rake_copy
    core_requires = Dir[File.join("#{$pristine_git_core_ext_path}",'**','*')]\
                    .reject {|x| File.directory?(x) }
    rake_gemspec
    rake_trace_requires
    for path in (core_requires+$require_list+$additional_list).uniq.sort
      newdir = File.dirname(path.gsub($pristine_git_lib_path, $dest_lib_path)
                                .gsub($pristine_git_path, $dest_path))
      puts path.gsub($pristine_git_path,'') if $verbose
      `mkdir -p #{newdir}`
      `cp #{path} #{newdir}`
    end
  end
  
  def checkout (release)
    `cd #{$pristine_git_path}; git checkout #{release} -f; sleep 1.0`
  end
  
  def rake_gemspec
    gemspec = File.read($gemspec_file_path)
    gemspec.gsub!(/(s.name\s*=\s*)'activesupport'/, '\1\'activesupport-core-ext\'')
    gemspec.gsub!(/[^\n]*'minitest'[^\n]*\n/, '')
    
    version = File.read($version_file_path).strip
    gemspec.gsub!(/^\s*(version\s*=\s*)([^\n]*\n)/, '\1\''+version+'\''+"\n")
    
    gemspec.gsub!(/(s.(?:summary|description)\s*=\s*)'[^']*'/, '\1'+\
      "'Only the core extensions of activesupport, "\
      "extracted directly from the Rails framework'")
    
    wd = Dir.getwd
    Dir.chdir(File.dirname($gemspec_file_path))
    $additional_list = eval(gemspec.match(/s.files\s*=\s*(.*)\n/)[1])
      .reject {|x| x=~/(\.rb$)/ or x=~/^lib/}
      .map {|x| File.expand_path(x)}
    p $additional_list
    Dir.chdir(wd)
    
    `mkdir -p #{$dest_path}`
    `touch #{File.join($dest_path, 'activesupport-core-ext.gemspec')}`
    
    File.write(File.join($dest_path, 'activesupport-core-ext.gemspec'), gemspec)
    
    gemspec
    nil
  end
  
  def rake_build
    puts "\nBuilding gem..."
    `cd #{$dest_path}; gem build 'activesupport-core-ext.gemspec'; mv *.gem #{File.dirname(__FILE__)}`
  end
  
  def rake_clean
    `rm -rf #{$dest_path}`
  end
  
  def rake_clean_pristine
    `rm -rf #{$pristine_git}`
  end
  
  def rake_build_all
    
    rake_clone
    rake_fetch_releases
    for release in rake_chosen_releases
      checkout release
      rake_clean
      rake_gemspec
      rake_copy
      rake_build
    end
    
  nil end
  
end
