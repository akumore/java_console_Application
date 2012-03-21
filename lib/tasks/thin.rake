namespace :thin do
  desc 'restart thin servers'
  task :restart do
    if Rails.env.production?
      `rvm-shell ruby-1.9.3-p0@alfred_mueller -c 'thin -C /home/usr/alfred_mueller/.nine/ruby/1.9.3@alfred_mueller/alfred_mueller.yml -O restart'`
    else
      `rvm-shell ruby-1.9.3-p0@alfred_mueller -c 'thin -C /home/usr/amstaging/.nine/ruby/1.9.3@alfred_mueller/amstaging.yml -O restart'`     
    end
  end
end