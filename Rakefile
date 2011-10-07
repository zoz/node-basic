require 'rake/clean'
require 'appscript'
include Appscript

clientFiles = FileList['src/client/*.coffee']
serverFiles = FileList['src/server/*.coffee']
sharedFiles = FileList['src/shared/*.coffee']
sassFiles = FileList['src/sass/*.scss']

generatedFiles = FileList['client/**/*.js', 'server/**/*.js']

CLIENTDIR = 'build/client'
SERVERDIR = 'build/server'
TMPDIR = 'tmp'
LOGDIR = 'tmp/log'

ALLFILES = (clientFiles + serverFiles + sharedFiles + sassFiles).push(TMPDIR).push(CLIENTDIR).push(SERVERDIR).push(LOGDIR)
DEPFILES = [].push(TMPDIR).push(LOGDIR)

TOUCHFILE = File.join(TMPDIR, 'raketouchfile.txt')

CLEAN.include(generatedFiles, SERVERDIR, CLIENTDIR, TOUCHFILE)
CLOBBER.include("tmp/log/*", "tmp/*")

directory CLIENTDIR
directory SERVERDIR
directory TMPDIR
directory LOGDIR

sassFiles.each do |srcfile|
  objfile = File.join(CLIENTDIR, File.basename(srcfile).ext('css'))
  DEPFILES.push objfile
  file objfile => [srcfile, CLIENTDIR] do
    sh "sass #{srcfile} #{objfile}"
  end
end

clientFiles.each do |srcfile|
  objfile = File.join(CLIENTDIR, File.basename(srcfile).ext('js'))
  DEPFILES.push objfile
  file objfile => [srcfile, CLIENTDIR] do
    sh "coffee -c -b -o #{CLIENTDIR} #{srcfile}" 
  end
end

serverFiles.each do |srcfile|
  objfile = File.join(SERVERDIR, File.basename(srcfile).ext('js'))
  DEPFILES.push objfile
  file objfile => [srcfile, SERVERDIR] do
    sh "coffee -c -b -o #{SERVERDIR} #{srcfile}" 
  end
end

sharedFiles.each do |srcfile|
  objfile = File.join(SERVERDIR, File.basename(srcfile).ext('js'))
  DEPFILES.push objfile
  file objfile => [srcfile, SERVERDIR] do
    sh "coffee -c -b -o #{SERVERDIR} #{srcfile}" 
  end
  objfile = File.join(CLIENTDIR, File.basename(srcfile).ext('js'))
  DEPFILES.push objfile
  file objfile => [srcfile, CLIENTDIR] do
    sh "coffee -c -b -o #{CLIENTDIR} #{srcfile}" 
  end
end

desc "compile files"
task :default => DEPFILES do
end

def pid_server()
  out = %x{ps -A | grep 'node-server.js$' | grep -v grep | awk '{print $1}'}
  return out
end

task :isrunning do
 puts pid_server()
end

task :kill do
  pid = pid_server()
  if not pid.empty?
    puts "killing #{pid}"
    %x{kill -9 #{pid}}
  end
end

task :browser do
  app("Google Chrome").activate()
  sleep 0.02
  app("System Events").keystroke("r", {:using=>:command_down})
end

task :runserver do
  %x[mv tmp/log/server.log tmp/log/server-last.log]

  cmd = "node build/server/node-server.js 2>&1 | tee tmp/log/server.log"
  pout = IO.popen cmd

  line = pout.gets
  if not (/node started/ =~ line)
    puts "ERROR STARTING SERVER"
    print line
    print pout.readlines.join
    exit
  end

end

desc "compile files, kill old node server process, start node, refresh browser"
task :run  => TOUCHFILE do
  pid = pid_server()
  if pid.empty?
    Rake::Task['runserver'].invoke
  end
  Rake::Task['browser'].invoke
end

file TOUCHFILE => DEPFILES do
  Rake::Task['kill'].invoke
  Rake::Task['runserver'].invoke
  sh "touch #{TOUCHFILE}"
end

