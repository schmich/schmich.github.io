def dep(task, *args)
  Rake::Task[task].invoke(*args)
end

desc 'Publish to schmich.github.io'
task :publish => :build do
  source = '_site'
  target = 'publish'

  puts 'Publishing to schmich.github.io.'
  Dir["#{target}/*"].each(&method(:rm_rf))

  if !Dir.exists?(source)
    abort "#{source} does not exist, aborting."
  end

  cp_r "#{source}/.", target

  cd target do
    sh 'git add .'
    sh 'git add -u'

    message = "Publish at #{Time.now.utc}"
    sh "git commit -m \"#{message}\""

    sh "git push origin master --force"
  end
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
