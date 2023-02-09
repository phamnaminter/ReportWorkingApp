# REPORT WORKING APP
Report working app project

## Deploy with Docker (example for local)
**1. Create config environment in application.yml (*)**
- Create file `application.yml` with path `pj/config/application.yml` by command `cp config/application.yml.example config/application.yml`
- Add environment variable on file `config/application.yml`
- Update `DATABASE_HOST = "db"`
- Update `REDIS_URL = "redis://redis:6379/0"`

**2.** `sudo docker-compose build`
**3.** `sudo docker-compose up -d`
## Requirements:
**1.** **Install Ruby: 2.7.2 and Rails: 6.0.5(for the first time only) (*)**
- Ubuntu: https://gorails.com/setup/ubuntu/16.04
- MacOS: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-macos

**2.** **Install Database: MySQL (for the first time only) (*)**
- Ubuntu: ###
- MasOS: ###

**3.** **Pull code from Github**

**3.1. Fork**
- Press button `fork` on GitHub

**3.2. Clone**
- use https: `$ git clone https://github.com/<your-github-account>/pj.git`
- use ssh: `$ git clone git@github.com:<your-github-account>/pj.git`

**3.3. Remote add upstream**
- `$ git remote add upstream https://github.com/factory-inc/pj.git`

**4** **How to start developing?**

**4.1. Install gems (*)**
```
$ cd pj
$ bundle install
```
**4.2. Add environment variable: (*)**
- Create file `application.yml` with path `pj/config/application.yml` by command `cp config/application.yml.example config/application.yml`
- Add enviroment variable on file `config/application.yml`

**4.3. Create database (for the first time only) (*)**
- Update file `database.yml` on path `pj/config/database.yml`
    + You need update **username** and **password** with your database account
- Next, need perform query below for create database.
```
$ rails db:create && rails db:migrate
```
**4.4. Start rails server (*)**
```
$ rails server
```

**4.5. Start sidekiq server (*)**
- Open a new tab in the current opened terminal you can press `SHIFT + CTRL + T ` and run command below:
```
$ bundle exec sidekiq
```
