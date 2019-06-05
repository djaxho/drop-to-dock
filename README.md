

Pre-setup: Make sure you have cloned your main laravel project, gotten a .env file, run composer install and npm install and have a database dump ready to import for the project.

## Set up
##### note: full set up should take just a few minutes

1. add `/drop-to-dock` to the .gitignore file of your base project
2. navigate into your base project and clone this repo
3. navigate into the newly created drop-to-dock directory `cd drop-to-dock`
4. Generate config files by copying the '.example' files within `config/db/` to files without the '.example' extension. You can do this automatically by running `./generate-config` (you may need to grant permissions `chmod +x generate-config` and after executing it remove the execute permissions for safety `chmod -x generate-config`)
5. Run `docker-compose up`
6. Once up, navigate to phpmyadmin container (http://localhost:8181), click on the database name in the left-side panel, click on the import tab, and import your database dump file.
7. run the database migrations to make sure your database is up to date with the current state of the laravel repo 
    ```
    docker-compose exec php bash -c 'cd /code && php artisan migrate
    ```
8. now you should be able to visit http://localhost/ and see your laravel project
9. You should now update your laravel project .env database variables to mimic those you have set in drop-to-dock config: (note: since you are serving the code on a container, you can refer to the container names as the host in your laravel app)
    ``` 
      DB_HOST=db_mysql
      DB_PORT=3306
      DB_DATABASE=drop_to_dock
      DB_USERNAME=mysqluser
      DB_PASSWORD=mysqlpass
      ```
  
Running Tests
--
There are two options to get phpunit tests up and running using your testing database container:
1. *(Quickest way)* Copy the `phpunit.xml.dist` file to a new file called `phpunit.xml` and then update the php environmental vars to include your docker testing db config
    ```
    <env name="DB_HOST" value="127.0.0.1"/>
    <env name="DB_PORT" value="33061"/>
    ```
2. If you also want to override a lot of your project's `.env` file variables, then create a file called `.env.testing`
but you will still need a phpunit.xml file from step 1 to override some of the values in phpunit.xml.dist
 
Pretty URL's
--
For additional set up for using better local dev urls, one quick way is to use Dnsmasq: 

1. add the following to your `/etc/dnsmasq.conf` file: 
    ``` 
        listen-address=127.0.0.1
        address=/worksome-platform.dk/127.0.0.1
        address=/worksome-platform.co.uk/127.0.0.1
        address=/worksome-platform.no/127.0.0.1
        address=/worksome-platform.se/127.0.0.1
        address=/worksome-platform.lt/127.0.0.1
     ```
2. add the following to your `/etc/resolv.conf.head` (which you may have to create)
    ```
        nameserver 127.0.0.1
    ```
3. restart dnsmask service `systemctl restart dnsmasq` and `systemctl restart dhcpcd`
_________________
Troubleshooting
--
* If `docker-compose up` give you some trouble with already bound ports, you may need to stop
some services running on your machine like: 
    ```
        sudo service mysql stop
        sudo service nginx stop
        sudo service apache2 stop
        /etc/init.d/redis-server stop
    ```

* Trouble with database connections running artisan commands on your local machine:
Most of your file-generation artisan commands should run fine, but ones requiring database connections may not.
In these cases create another dotenv (like .env.local), fill with non-named database vars, and run the artisan commands with the extra argument `--env=local`

* If you want to inspect your containers, run `docker ps` to list them. Then to 'ssh' into them, use `docker exec -it drop-to-dock_php_1 /bin/bash` where drop-to-dock_php_1 is the name you gathered from the 'docker ps' command

* note: your database will persist through `docker-compose down` But if you **want to destroy your data** (and database, in this docker set up) then do `docker-compose down -v`
