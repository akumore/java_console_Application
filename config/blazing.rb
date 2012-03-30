#
# Blazing Configuration File
#
#
repository 'git@github.com:screenconcept/alflred_mueller.git'

target :production, 'alfred_mueller@scrcpt2.nine.ch:/home/usr/alfred_mueller/public_html', :url => 'http://production.alfredmueller.screenconcept.ch', :rails_env => 'production'
target :staging, 'amstaging@scrcpt2.nine.ch:/home/usr/amstaging/public_html', :url => 'http://staging.alfredmueller.screenconcept.ch', :rails_env => 'staging'

rvm :rvmrc
rvm_scripts '/opt/rvm/scripts/rvm'

rake 'post_deploy'