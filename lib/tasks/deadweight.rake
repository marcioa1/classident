require 'deadweight'

desc "run Deadweight CSS check ( requires script/server )"
task :deadweight do
  dw = Deadweight.new
  dw.stylesheets = ["/stylesheets/*.css"]
  dw.pages = ["/"]
  puts dw.run
end
