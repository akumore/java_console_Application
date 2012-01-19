# Setup

* Make sure you have Ruby 1.9.3 with the gemset `alfred_mueller` running.
* Install mongodb: `brew install mongodb`. Make sure you install mongodb > 2.0, run `brew update` if necessary.
* QT is needed for capybara-webkit. You can install it with `brew install qt`
* Install mmode to handle scrcpt2 maintenance mode: `gem install mmode`
* Add the remote repo on scrcpt2 to deploy: `bundle exec blazing update staging`
* Run `bundle install`

# Deployment

Make sure your public key is available on the staging server in `/home/usr/alfred_mueller/.ssh/authorized_keys2`

* `mmode enable alfred_mueller`: enable the maintenance mode on the server, so nine does not get bugged
* `git push <staging|production> <git ref>` push the code
* `mmode disable alfred_mueller`: disable the maintenance mode on the server

# Environments

## Staging

The app runs on the screenconcept2 server:

Home: `/home/usr/alfred_mueller/public_html`

Web: [alfred_mueller.scrcpt2.nine.ch](http://alfred_mueller.scrcpt2.nine.ch/)

## Production
Not yet set.