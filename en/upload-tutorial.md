Title: Upload Tutorial

# Upload Tutorial

Here's a complete example of package uploads from scratch.
Although there are a few values which might be replaced by more appropriate ones (e.g. `distribution`, `series`, `pocket`, keys), the following code blocks should work if run as-is.

## Preconditions

The following packages will be used in this document to create packages, sign and upload them.

```
sudo apt-get install build-esssential debmake debhelper dput
sudo snap install --devmode landscape-api
```

Make sure you have exported your landscape credentials. If you haven't, they are available from your Landscape Server, at `https://landscape.example.com/settings`

Also, this guide assumes the server certificate is trusted. If your Landscape is using self-signed certificates, installing the certificate simplifies a lot of the configuration. This can be done with the following set of commands:

```
echo | openssl s_client -connect landscape.example.com:443 | sudo openssl x509 -out /usr/local/share/ca-certificates/landscape.crt
sudo update-ca-certificates
```


## Creating the keys

If you have followed the documentation for [Repositories](./repositories.md), the following should feel familiar.

```
gpg --yes --batch --pinentry-mode=loopback --passphrase "" --quick-generate-key mirror-key
gpg -a --export-secret-key mirror-key > mirror-key.gpg
landscape-api import-gpg-key mirror-key mirror-key.gpg
```

We generated a new passphrase-less key, exported the secret key to a file, and imported it in Landscape. The command should output something similar to this:

```
{u'fingerprint': u'c43d:2208:94fc:852c:6283:f21f:cc21:fbbf:1fcb:bf5e',
 u'has_secret': True,
 u'id': 1,
 u'key_id': u'CC21FBBF1FCBBF5E',
 u'name': u'mirror-key'}
```

The `fingerprint` and `key_id` will be different. But the interesting part is the `has_secret` field, which indicate that this key is suitable for signing a repository. This is also the key which computers will use to verify downloaded packages integrity. We'll come back to that fact a few sections down.

Next, we need a key to upload packages. Package upload don't use password authentication to grant users access to uploads. Instead, all data sent to the server is cryptographically signed with an upload key. We'll use the same identifier (`upload-key`) both in gpg and in Landscape. This doesn't have to be the case, but is done here for the sake of simplicity and consistency.

```
gpg --yes --batch --pinentry-mode=loopback --passphrase "" --quick-generate-key upload-key
gpg -a --export upload-key > upload-key.gpg
landscape-api import-gpg-key upload-key upload-key.gpg
```

You will notice the difference from the `mirror-key` is the second command exported the key without the secret. The server doesn't need the secret to validate the integrity of uploaded packages. This fact will be reflected in the output we get:

```
{u'fingerprint': u'9015:54ab:7384:ae2d:ba56:3f9e:64f1:bb30:0e0a:d153',
 u'has_secret': False,
 u'id': 2,
 u'key_id': u'64F1BB300E0AD153',
 u'name': u'upload-key'}
```

## Setting up the upload pocket

Now let's create a distribution, series, and upload pocket. This is covered more in depth by the [Repositories](./repositories.md) page. For the purpose of clarity, we'll stick to descriptive names for distribution (e.g. ubuntu), series (e.g. focal), pocket (e.g. updates).

```
landscape-api create-distribution distribution
landscape-api create-series series distribution
landscape-api create-pocket pocket series distribution main amd64 upload mirror-key
landscape-api add-uploader-gpg-keys-to-pocket pocket series distribution upload-key
```

* First, we created a distribution called `distribution`.
* We created a series called `series`.
* We created a pocket called `pocket`. It has a `main` component, supports the `amd64` architecture, will be used for uploading packages, and will use the `mirror-key` with clients.
* Last but not least, we allow upload to our new pocket for packages signed by our `upload-key`.


## Creating a test package

Now, let's create an empty package to test uploading to our new pocket. We'll name this package `package-name`, and it will have a version of `1.2.3`.

```
mkdir package-name-1.2.3
cd package-name-1.2.3
debmake -p package-name -u 1.2.3 -n
dch --distribution series-pocket --force-distribution -U --release ''
dpkg-buildpackage -B --sign-key=upload-key
cd ..
```

This will create a couple of files and folders. The most interesting parts are the `package-name_1.2.3_amd64.deb` file (our new empty package), and the changes file (`package-name_1.2.3_amd64.changes`). The changes file contains meta-data about the package, the target pocket (called `Distribution` in this context), the list of files to upload and a cryptographic signature to authenticate our upload (using the `upload-key`). This is all we need to test uploading!

If you want to know more about the files we generated in the process, the [deb policy manual](https://www.debian.org/doc/debian-policy/ch-source.html) covers their exact format. A lot of upload problems can be traced to missing or incorrectly formatted fields.


## Uploading the test package

First, we will have to create a `~/.dput.cf` file describing how to upload to Landscape server:

```
tee ~/.dput.cf <<EOF
[lds]
fqdn = landscape.example.com
method = https
incoming = /upload/standalone/%(lds)s
EOF
```

Be sure to fill the fqdn field with the actual address of your Landscape server.

Then, our new package can be uploaded by running the following:

```
dput lds:distribution/series/pocket package-name_1.2.3_amd64.changes
```

If everything worked as it should, the package is now uploaded and available. Please note that errors are unlikely to surface during the `dput` command. Upload errors, if any, get logged on the server under `/var/log/landscape-server/package-upload.log`. Adding the `-d` argument flag will output more details. Adding the `-f` argument flag can be used to re-upload already uploaded files.


## Using the pocket on computers

Now if we recall, we generated a `mirror-key` and used it on the created pocket. To allow `apt` to trust packages from our server, the public (not secret) part of this key can be exported to a file and imported into a target computer:

```
gpg --export mirror-key > landscape.gpg
sudo cp landscape.gpg /etc/apt/trusted.gpg.d/landscape.gpg
sudo add-apt-repository "deb http://landscape.example.com/repository/standalone/distribution series-pocket main"
```

Now, updating packages lists will also look up on Landscape, in our upload pocket, and allow us to install packages from it:

```
sudo apt-get update
sudo apt-get install package-name
```


## Uploading a binary-only package

If we have a pre-built binary which we want to upload to a pocket, the process is similar. First let's download a binary package. Here, we'll use the `hello` package. The version you will have might differ from the one in this guide (`2.10-1build3`):

```
apt-get download hello
```

There is now a `hello_2.10-1build3_amd64.deb` file in the current folder. Much like the package we generated previously, we need a `.changes` file to describe meta-data about the package, files to be uploaded, and authenticate our upload with our `upload-key`.

```
mkdir hello
cd hello
debmake -p hello -u 2.10-1build3 -n
dch --distribution series-pocket --force-distribution -U --release ''
```
We now have the meta-data generated. Unlike with our source-built `package-name`, we will directly add our binary package to the list of uploaded files. Then we generate the `changes` file and sign it. For our previous `package-name` package, those steps were done by `dpkg-buildpackage` :

```
dpkg-distaddfile hello_2.10-1build3_amd64.deb unknown extra
dpkg-genchanges -B -O../hello_2.10-1build3_amd64.changes
cd ..
debsign -kupload-key hello_2.10-1build3_amd64.changes
```

This package can now be uploaded, much like the previous one:

```
dput lds:distribution/series/pocket hello_2.10-1build3_amd64.changes
```

Once uploaded, it should show up on our server. It will look like this:

```
sudo apt-get update
apt-cache policy hello
hello:
  Installed: (none)
  Candidate: 2.10-1build3
  Version table:
     2.10-1build3 500
        500 http://archive.ubuntu.com/ubuntu bionic-updates/main amd64 Packages
        500 http://security.ubuntu.com/ubuntu bionic-security/main amd64 Packages
        500 http://landscape.example.com/repository/standalone/distribution series-pocket/main amd64 Packages
     2.10-1build1 500
        500 http://archive.ubuntu.com/ubuntu bionic/main amd64 Packages
```


## Common errors

### Incorrect GPG keys when creating the pocket

Creating an upload pocket, like mirror pockets, requires a key with `has_secret`. Be sure to generate a key without a passphrase, and to export the secret key. This is not the same as the upload key.


### Public key missing

Either:

* the upload gpg key has not been imported with `landscape-api import-gpg-key`,
* or gpg key hasn't been allowed on the upload pocket, with `landscape-api add-uploader-gpg-keys-to-pocket`,
* or the gpg key used to sign the `changes` file is not the upload key. Be sure to pass the correct key name or key fingerprint to the `-k` parameter when running `debsign`.


### Proxy errors

The standard `dput` package, does not support proxy configuration. If you require a proxy to upload to Landscape server, install the `dput-ng` package. This is a drop-in replacement for dput, but which honors the `https_proxy` environment variable.

For it to work, you will also have to update the `.dput.cf` configuration file to specify the `https` prefix under `fqdn`.
The full content of this file will look like this:

```
[lds]
fqdn = https://landscape.example.com
method = https
incoming = /upload/standalone/%(lds)s
```


### dput claims the files have already been uploaded

Some packaging hosts like Launchpad normally only allow uploading a set of files once. With those, you would be required to increment the package version revision number (e.g. from `1.2-1ubuntu1` to `1.2-1ubuntu2`), then rebuild to upload a new set of files. With Landscape, you can simply add the `--force` flag to `dput` and the existing upload will be overwritten.


### Invalid distribution error

In the context of an upload error, the distribution refers to the suite (series-pocket). This field is read from the `changes` file, under `Distribution` and under `Changes`. Initially, the package building process initially gets this value from a field in the `debian/changelog` file. Make sure the value of the suite (i.e. series-pocket) is correctly set in the `changelog`, then rebuild the package and/or `changes` file.

There is a special case when the pocket it named `release`. This is used to represent a suite with no pocket suffix (e.g. just `bionic` instead of `bionic-release`). If the pocket is named `release`, changes files should use the series name as the `distribution` field value. For our binary upload example, uploading to `distribution/series/release` becomes:

```
dch --distribution series --force-distribution -U --release ''
dpkg-genchanges -B -O../hello_2.10-1build3_amd64.changes
debsign -kupload-key hello_2.10-1build3_amd64.changes
dput lds:distribution/series/release hello_2.10-1build3_amd64.changes
```


Note that errors about bad distributions can follow misconfigured gpg keys. For instance, the gpg key used to sign (e.g. upload-key) is the actual problem in this log entry:

```
Could not check validity of signature with '0000000000000000' in 'hello_2.10-1build3_amd64.changes' as public key missing!
No distribution accepting 'hello_2.10-1build3_amd64.changes' (i.e. none of the candidate distributions allowed inclusion)!
There have been errors!
```


### Invalid characters

Deb packages have some strict restrictions over how packages can be named. Package names should be limited to lowercase letters, digits and `+-.` characters. Versions also have similar restrictions. Refer to the [deb policy manual](https://www.debian.org/doc/debian-policy/ch-controlfields.html) for the exact specification.

