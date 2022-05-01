Title: Landscape On-Premises
# Landscape On-Premises

Landscape On-Premises, is the standalone version of Landscape that you can install on your own network.

Each major Landscape version is supported for a period of one year after release. Here are the currently supported releases:

| **major version**                | **Release date** | **Supported until** | **Version of Ubuntu**  |
| ----------------------           | ---------------- | ------------------- | ---------------------  |
| [19.10](./ReleaseNotes19.10.md)  | 2019-Oct         | **2023-Apr**        | 18.04 LTS              |

!!! Note:
    Work is being done to allow Landscape On-Premises to run on Ubuntu 20.04. However, there is currently no ETA for that support. Once Ubuntu 20.04 is supported, Landscape On-Premises will still continue to be supported on Ubuntu 18.04 until there has been sufficient time for customers to migrate their environment.

!!! Note:
    The Landscape client is available for all [supported Ubuntu releases](https://ubuntu.com/about/release-cycle), independently of the Landscape On-Premises releases.


## Installation
Landscape On-Premises consists of two parts:

 * **database server**
 * **application server**

Depending on your deployment method, these may live on the same machine or different machines. Here is how you can get started:

### Quickstart
 * **[Quickstart](./landscape-install-quickstart.md)**, for when you don't have Juju but quickly want to check out On-Premises. Not recommended for production environments when having more than 500 clients.

### Juju deployed
 * **[Juju deployed](./landscape-install-juju.md)** for a truly scalable deployment.

### Manual installation
* **[Manual installation](./landscape-install-manual.md)**: for when you don't have a suitable Juju environment but need a scalable deployment.

## Installation requirements

### Network access
The machine(s) running as the application server will need the following network access:

 * https access to `usn.ubuntu.com` in order to download the USN database and detect security updates. Without this, the available updates won't be distinguished between security related and regular updates
 * http access to the public Ubuntu archives and `changelogs.ubuntu.com`, in order to update the hash-id-database files and detect new distribution releases. Without this, the release upgrade feature won't work
 * https access to `landscape.canonical.com` in order to query for available Landscape On-Premises releases. If this access is not given, the only drawback is that Landscape won't display a note about the available releases in the account page.

# Unsupported Versions
| **major version**                | **Release date** | **Support expired on** | **Version of Ubuntu**  |
| ----------------------           | ---------------- | ------------------------ | ---------------------  |
| [19.01](./ReleaseNotes19.01.md)  | 2019-Jan         | **2020-Jan**             | 18.04 LTS              |
| [18.03](./ReleaseNotes18.03.md)  | 2018-Jun         | **2019-Jun**             | 16.04 LTS or 18.04 LTS |
| [17.03](./ReleaseNotes17.03.md)  | 2017-Mar         | **2019-Mar**             | 16.04 LTS              |
| 16.06                            | 2016-Jul         | **2017-Dec**             | 14.04 LTS or 16.04 LTS |
| 16.03                            | 2016-Apr         | **2017-Apr**             | 14.04 LTS              |
