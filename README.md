# Entropia Coletiva

Primeira plataforma de financiamento coletivo de projetos científicos do Brasil.

Projeto idealizado e realizado pro Frederico Reis e Patricia Bado.

https://revistacult.uol.com.br/home/entropia-coletiva-crowdfunding-cientifico/

https://revistapesquisa.fapesp.br/wp-content/uploads/2017/12/038-041_crowdfunding_262.pdf

Startup acelerada pelo programa Startup Rio 2016. http://www.startuprio.rj.gov.br/

Projeto descontinuado em 2019.

The first science crowdfunding platform from Brazil






## Getting started

### Dependencies

To run this project you need to have:

* Ruby 2.1.2
* [PostgreSQL](http://www.postgresql.org/)
  * OSX - [Postgres.app](http://postgresapp.com/)
  * Linux - `$ sudo apt-get install postgresql`
  * Windows - [PostgreSQL for Windows](http://www.postgresql.org/download/windows/)

  **IMPORTANT**: Make sure you have postgresql-contrib ([Aditional Modules](http://www.postgresql.org/docs/9.3/static/contrib.html)) installed on your system.

### Setup the project

* Clone the project

        $ git clone https://github.com/angelis-reis/entropia-coletiva.git

* Enter project folder

        $ cd entropia-coletiva

* Create the `database.yml`

        $ cp config/database.sample.yml config/database.yml

    You must do this to configure your local database!
    Add your database username and password (unless you don't have any).

* Install the gems

        $ bundle install

* Install the front-end dependencies

        $ bower install

    Requires [bower](http://bower.io/#install-bower), which requires [Node.js](https://nodejs.org/download/) and its package manager, *npm*. Follow the instructions on the bower.io website.

* Create and seed the database

        $ rake db:create db:migrate db:seed

If everything goes OK, you can now run the project!


### Running the project

```bash
$ rails server
```

Open [http://localhost:3000](http://localhost:3000)
* ...
##To Update cron
bundle exec whenever --update-crontab

## To start Redis
redis-server
##clear rediscache
redis-cli flushall

## To Start Sidekiq in production env
bundle exec sidekiq -d -L sidekiq.log -q mailer,5 -q default -e production




## Payment gateways

Iugu.com integration  https://github.com/angelis-reis/catarse_iugu


If you have created a different payment engine to Entropia Coletiva, please contact us so we can link your engine here.


## How to contribute with code

Just fork the project, change what you want, and send us a pull request.

### Best practices (or how to get your pull request accepted faster)

* Follow this style guide: https://github.com/bbatsov/ruby-style-guide
* Create one acceptance tests for each scenario of the feature you are trying to implement.
* Create model and controller tests to keep 100% of code coverage in the new parts you are writing.
* Feel free to add specs to committed code that lacks coverage ;)
* Let our tests serve as a style guide: we try to use implicit spec subjects and lazy evaluation wherever we can.

## Credits

Author: Frederico Reis  adapted from https://github.com/catarse/catarse

### License

Licensed under the MIT license (see MIT-LICENSE file)

