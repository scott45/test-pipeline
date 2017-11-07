# VOF Tracker

Before joining the Fellowship, every candidate must exhibit their proficiency when measured against their 
Value Alignment, Output Quality and Feedback (V.O.F). 

The VOF Tracker helps to automate this process by empowering the Bootcamp Facilitators, Facilitator's Assistants 
and the Talent team to continue to identify the top 1% as Andela scales its recruitment process.

## External Dependencies

This web application is written with Ruby using the Ruby on Rails framework and a PostgreSQL database.

To install Ruby visit [Ruby Lang](https://www.ruby-lang.org). [v2.4.0]

To install Rails visit [Ruby on Rails](http://rubyonrails.org/). [v5.0.1]

Install [RubyGems](https://rubygems.org/) and [Bundler](http://bundler.io/) to help you manage dependencies in your [Gemfile](Gemfile).

To install PostgreSQL visit [Postgres app](http://postgresapp.com/).

## Running the App

* Once you have Ruby, Rails and PostgreSQL installed, clone the repo by running:

  ```$ git clone https://github.com/andela/vof-tracker.git```

* Then run the following command to install gem dependencies:

  ```$ bundle install```

### Database

Create a postgres user/role with the same username as indicated in the `config/database.yml` file using the steps below.

If you'd like to use your own postgres user and password don't forget to update the `config/database.yml` file.

* To create a user, enter the postgres shell and create a user with `createdb` rights, no password necessary:

  ```$ psql```

  ```psql# create role vof_tracker with createdb login;```

  ```psql# \q```

* Then create and migrate the database: 

  ```$ rake db:setup```

  ```$ rails db:migrate```

### Starting the server

* Once your database is installed successfully, start the Rails server by running:

  ```$ rails server```

* To access the app, visit http://localhost:3000 in a web browser

## Limitations

* VOF Tracker is still in development
