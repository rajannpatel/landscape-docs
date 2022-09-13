Title: Using the landscape-api package

# Using the landscape-api package

The **landscape-api** package is available as a snap package, and also in the same PPA repository as Landscape Server.

It is recommended to install the package as a self updating [snap](https://ubuntu.com/core/services/guide/snaps-intro), by running:

```bash
sudo snap install --classic landscape-api
```

Instead, if you wish to install the package from the PPA, run:

```bash
sudo add-apt-repository --update ppa:landscape/landscape-api
sudo apt-get install landscape-api
```

To avoid having to pass the access key, secret key and endpoint URL everytime you call landscape-api, you can put them in a file and source it. For example, you can create a ~/.landscape-api.rc file with:

```bash
#!/bin/bash
export LANDSCAPE_API_KEY="<API access key>"
export LANDSCAPE_API_SECRET="<API secret key>"
export LANDSCAPE_API_URI="https://<landscape-hostname>/api/"
```

If you are using a custom Certificate Authority (CA), you will also need to tell the API tool where to find that certificate:

```bash
export LANDSCAPE_API_SSL_CA_FILE="/path/to/ca/file"
```

All these variables can also be specified as command-line options to the landscape-api tool.

Now, before making an API request, just source that file and you are ready to go:

```bash
source ~/.landscape-api.rc
```

The list of API methods supported by the client can be seen by just running it without any arguments. Each method has also its own quick usage description, which can be seen by running:

```bash
landscape-api help <method>
```

Note that the method names in the command-line client are all lowercase and use hyphens as a word separator. So, for example, the API method GetComputers is called `get-computers` in the client.
