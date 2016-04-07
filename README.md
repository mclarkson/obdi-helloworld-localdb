# obdi-helloworld-localdb

This Obdi plugin has a UI and a private sqlite3 database.

## Screenshot

![](images/helloworld-localdb.png?raw=true)

## What is it?
A starting point for writing an Obdi plugin that uses a private sqlite3 database.

* This plugin has a Web Interface.
* This plugin uses a private sqlite database.
* This plugin exposes a REST endpoint.
    The GUI uses REST to access the private database.
* This plugin does not run scripts on workers.

Similar plugin: [obdi-saltregexmanager](https://github.com/mclarkson/obdi-saltregexmanager)

## Using the REST Endpoint for CRUD from the Command Line

```
# Log in

$ ipport="127.0.0.1:443"

$ guid=`curl -ks -d '{"Login":"nomen.nescio","Password":"password"}' \
  https://$ipport/api/login | grep -o "[a-z0-9][^\"]*"`

# Create

$ curl -k -d '{"Text":"Hello"}' \
  https://$ipport/api/nomen.nescio/$guid/helloworld-localdb/helloworld-localdb?env_id=1

# Read

$ curl -k https://$ipport/api/nomen.nescio/$guid/helloworld-localdb/helloworld-localdb?env_id=1

# Update

$ curl -k -d '{"Id":1,"Text":"Hello there"}' -X PUT \
  https://$ipport/api/nomen.nescio/$guid/helloworld-localdb/helloworld-localdb?env_id=1

# Delete

$ curl -k -X DELETE \
  https://$ipport/api/nomen.nescio/$guid/helloworld-localdb/helloworld-localdb/1?env_id=1
```

See [obdi-dev-repository](https://github.com/mclarkson/obdi-dev-repository)
for more information about Dev plugins.
