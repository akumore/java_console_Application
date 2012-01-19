namespace :thin do
  desc 'restart thin servers'
  task :restart do
    `rvm-shell ruby-1.9.3-p0@alfred_mueller -c 'thin -C /home/usr/alfred_mueller/.nine/ruby/1.9.3@alfred_mueller/alfred_mueller.yml -O restart'`
  end
end