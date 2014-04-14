target :production, 'www-data@c3.screenconcept.ch:/home/www-data/apps/alfredmueller_web_production', rails_env: 'production'
target :staging, 'www-data@c3.screenconcept.ch:/home/www-data/apps/alfredmueller_web_staging', rails_env: 'staging'

env_scripts '/home/www-data/bin/rbenv.sh'
rake 'post_deploy'
