#
# Blazing Configuration File
#
#
repository 'git@github.com:screenconcept/alflred_mueller.git'
target :staging, 'alfred_mueller@scrcpt2.nine.ch:/home/usr/alfred_mueller/public_html', :url => 'http://alfred_mueller.scrcpt2.nine.ch'

rvm :rvmrc
rvm_scripts '/opt/rvm/scripts/rvm'

recipe :precompile_assets
rake 'post_deploy RAILS_ENV=staging'