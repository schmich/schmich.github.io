def dep(task, *args)
  Rake::Task[task].invoke(*args)
end

desc 'Start server'
task :start do
  sh 'jekyll serve --watch'
end

desc 'Build site'
task :build do
  sh 'jekyll build'
end

desc 'Start server'
task :default => :start
