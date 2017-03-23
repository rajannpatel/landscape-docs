Title: Installing Landscape On-Premises

# Installing Landscape On-Premises

# Quickstart, for when you don't have Juju but quickly want to check out On-Prem:

Run the following commands:

```bash
sudo add-apt-repository ppa:landscape/16.06
sudo apt-get update
sudo apt-get install landscape-server-quickstart
```
# Using Juju

Juju deployed for a truly scalable deployment. Using bundles, for example:

```bash
sudo add-apt-repository ppa:juju/stable
sudo apt-get update
sudo apt-get install juju-2.0
```

Now select your bundle 

landscape-dense-maas: if you have the MAAS provider, you can deploy all services on the bootstrap node using containers:

```
juju deploy cs:bundle/landscape-dense-maas-1

```
    
landscape-scalable: each service gets its own machine. Currently that means you will need 4 machines for Landscape, and one for the bootstrap node:

```
juju deploy cs:trusty/landscape-server-15

```

Once the deployment has finished, grab the address of the first haproxy unit and access it with your browser:

```
juju status haproxy/0
```
