target :production, 'www-data@.screenconcept.ch:/home/www-data/apps/alfredmueller_web_production', rails_env: 'production'
target :staging, 'www-data@.screenconcept.ch:/home/www-data/apps/alfredmueller_web_staging', rails_env: 'staging'
rvm :rvmrc
rake 'post_deploy'
