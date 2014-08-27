# DB Admin

DB Admin provides a simple interface to browse the data in the tables in a database and execute queries and view the results.

![](https://raw.github.com/pjb3/dbadmin/master/doc/screenshots/tables.png)

You can view the results in the traditional columns and rows table view:

![](https://raw.github.com/pjb3/dbadmin/master/doc/screenshots/table_list.png)

or for larger tables, you can view the results one row per column:

![](https://raw.github.com/pjb3/dbadmin/master/doc/screenshots/table_grid.png)

You can execute any SQL query and see the result:

![](https://raw.github.com/pjb3/dbadmin/master/doc/screenshots/query.png)

## Installation

    $ gem install dbadmin

## Usage

    $ dbadmin postgres://localhost/myapp_development
    $ open http://localhost:8888

The argument to the dbadmin command is a URI representing the credentials/info needed to connect to the database.  The format is generally:

    <adapter>://<user>:<pass>@<host>/<database>

You will need the database adapter gem installed for your database, e.g, `mysql` for mysql, `pg` for postgres, etc.  See the [Sequel docs][sequel] for more info.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[sequel]: http://sequel.rubyforge.org/rdoc/files/doc/opening_databases_rdoc.html
