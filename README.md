[![Build Status](https://magnum.travis-ci.com/screenconcept/alfred-mueller.png?token=vgnCpmpJido3Y8bAsdL1)](https://magnum.travis-ci.com/screenconcept/alfred-mueller)

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

## Steps for making a release:

1. Update the changelog, add the implemented stories or describe your bugfix
2. Merge the development branch into the master branch (**production releases only**)
3. Create a new tag (**production releases only**)
4. `mmode enable <amstaging|alfred_mueller>`: enable the maintenance mode on the server, so nine does not get bugged
5. `git push <staging|production> <git ref>` push the code
6. `mmode disable <amstaging|alfred_mueller>`: disable the maintenance mode on the server

## How to kill thin servers while deployment takes too long

1. Connect to server via SSH
2. Get your user id with the simple command `id`. Output should be something like this: `uid=1007(alfred_mueller) gid=1008(alfred_mueller) groups=1008(alfred_mueller)`
3. Watch currently running thins with `watch -n1 'ps aux | grep '^1007' | grep thin'` while the integer value is the user id => 1007.
4. In a new session you can monitor the thins with this command `tail -f log/thin.1004*.log`
5. Kill the running thins with the kill command and the process id. For example: `kill 12841`
6. You're done :shipit:

# Environments

## Development

Make sure you have a running instance of MongoDB before starting the rails server.
If not, start it by calling `mongod` in your terminal.

## Staging
The app runs on the scrcpt2.nine.ch server:

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

## Idx301 Exporter
* Supported fields for Idx301 exporter are listed in `lib/export/documentation/idx-format-v301_v015.xlsx`

## PDF Generation

* Thin is freezing when generating PDFs using PDFKit. As an workaround we have to run Thin in threaded mode.
* This seems to be a bug in Thin.

## Performance

* Thin is very slow when running Ruby 1.9 in threaded mode with 'epoll' enabled. Therefore it has to be disabled!
* Response times of Mongolab (currently used for database hosting) are very high, around 100ms for each database access. Don't use it in production.

## Avoid SSH disconnects due to firewall timeouts

Firewall timeouts may interrupt long-running rake tasks (e.g.
db:migrate). As alternative to a screen session, the rake task can be
run with nohup and in/output redirection.

    RAILS_ENV=production nohup rake db:migrate > ../db_migration.out 2> ../db_migration.err < /dev/null &

The ssh connection can be terminated afterwards and the command output
is stored in the corresponding files.

## Be careful with recreating image versions in migrations

Migrations that recreate image versions over all real estates can take more than 2h until they're finished.
Keep in mind (especially on deployment)! 

# Google Analytics

There's a Google Analytics integration for event tracking. I was forced
to work with two different ways:

* JS/jQuery
* Controller/Session (thx to @k-graefenhain)

## JS/jQuery

This integration is really simple. There's a JS listener for the `.ga-tracking-link` class in
`app/assets/javascripts/routes/application.js.coffee`. So every time
the class is clicked an event triggers and sends the information -
delivered by data attributes - to google.

I had to do some little tweaks for the accordions and CMS content right
in the `accordion.js.coffee` JS view. For example I had to use an
additional element (`.ga-tracking-info`) just to submit the tracking
info right to the accordion element (I wasn't able to revise the
accordion brick from the cms so I had to collect the info via this
additional element).

Additionally, all the movies on the page are going to be tracked too. I
tweaked the `sublime_video.js.coffee` JS view with some lines.

## Controller/Session

This is the much more comfortable and lovely way (in my opinion). All
you've got is a `log_event` method in the `ApplicationController`. Just
have a look at it. The implementation is really really simple.

The `_ga_events.html.haml` partial is rendered right after the Google
Analytics Code. So sometimes after a successful AJAX requests I had to
render the partial one more time in the confirmation view for sending
the event right to Google.

Don't be mad at me for this implementation. I'm not really satisfied
with this solution but I did my best.
