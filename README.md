# Setup

* Make sure you have Ruby 1.9.3 with the gemset `alfred_mueller` running.
* Install mongodb: `brew install mongodb`. Make sure you install mongodb > 2.0, run `brew update` if necessary.
* QT is needed for capybara-webkit. You can install it with `brew install qt`
* Install mmode to handle scrcpt2 maintenance mode: `gem install mmode`
* Add the remote repo on scrcpt2 to deploy: `bundle exec blazing update staging`
* Run `bundle install`
* Copy `config/mongoid.yml.example` to `config/mongoid.yml` and customize it

# Deployment

Make sure your public key is available on the production server in `/home/usr/alfred_mueller/.ssh/authorized_keys` and
on the staging server in `/home/usr/amstaging/.ssh/authorized_keys`

* `mmode enable <amstaging|alfred_mueller>`: enable the maintenance mode on the server, so nine does not get bugged
* `git push <staging|production> <git ref>` push the code
* `mmode disable <amstaging|alfred_mueller>`: disable the maintenance mode on the server

# Environments

## Development

Make sure you have a running instance of MongoDB before starting the rails server.
If not, start it by calling `mongod` in your terminal.

## Staging
The app runs on the screenconcept2 server:

* Home: `/home/usr/amstaging/public_html`
* Web: [staging.alfredmueller.screenconcept.ch](http://staging.alfredmueller.screenconcept.ch)
* CMS test admin account: admin@screenconcept.ch / bambus

## Production
The app runs on the screenconcept2 server:

* Home: `/home/usr/alfred_mueller/public_html`
* Web: [production.alfredmueller.screenconcept.ch](http://production.alfredmueller.screenconcept.ch)
* CMS admin account: admin@screenconcept.ch / ****** (ask Immanuel, Thomas or Melinda)

###Special Thin webserver configuration is required in staging and production environments:

* Staging: edit /home/usr/amstaging/.nine/ruby/1.9.3-p0@alfred_mueller/amstaging.yml
* Production: edit /home/usr/alfred_mueller/.nine/ruby/1.9.3-p0@alfred_mueller/alfred_mueller.yml
* add the following parameters:
    * no-epoll: true
    * threaded: true


# Environment setups

In order for RVM to work with the whenever gem, we have to write a `.rvmrc` with the contents of `rvm_trust_rvmrcs_flag=1` in our user home.

# Pitfalls

## PDF Generation

* Thin is freezing when generating PDFs using PDFKit. As an workaround we have to run Thin in threaded mode.
* This seems to be a bug in Thin.

## Performance

* Thin is very slow when running Ruby 1.9 in threaded mode with 'epoll' enabled. Therefore it has to be disabled!
* Response times of Mongolab (currently used for database hosting) are very high, around 100ms for each database access. Don't use it in production.
