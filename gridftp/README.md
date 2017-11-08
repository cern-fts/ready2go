GridFTP Docker Container
========================
This image is intended to make easier to deploy a GridFTP server to be used by FTS. The image contains
both the GridFTP server, and [Let's Encrypt](https://letsencrypt.org/) certbot, so at first boot it will
obtain an X509 certificate.

In this repository you can find both the `Dockerfile` to build the image,
and a `docker-compose.yml` file to deploy it.

You may use our pre-built image `gitlab-registry.cern.ch/fts/ready-to-go/gridftp:latest`,
and just run it with `docker-compose`.

## How to run it
Just checkout this repository, and run `docker-compose up`. You will, obviously,
need Docker and Docker Compose installed locally. Please, check the documentation
for your distribution to see how to get them.

For CentOS7 at least, you can install the rpms `docker-compose` and `docker`.

```bash
yum install docker docker-compose
```

The following ports have to be open on your firewall for the image to work:

* `80`: Used by certbot to obtain the X509 certificate
* `2811`: GridFTP control channel
*  `50000-50200`: GridFTP data channels

The `iptables` rules are

```bash
-A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
-A INPUT -p tcp -m tcp --dport 2811 -j ACCEPT
-A INPUT -p tcp --dport 50000:50200 -j ACCEPT
```

You can add them manually, or edit `/etc/sysconfig/iptables`, and add them *before* any catch-all
`REJECT` or `DROP`.

Then, run the server

```bash
docker-compose up -d
```

The `-d` flag is to detach.

To stop the server

```bash
docker-compose down
```

By default, the container will run certbot with the `--test-cert` flag. This will create a certificate
with a "bad" signature from the staging authority.
This is useful for testing, and to avoid rate limitation on the production service. You can edit
`docker-compose.yml` once you are satisfied with your settings, and let the variable `TESTCERT` be empty.

Also, by default, only `/srv` is mounted inside the container, and served by the GridFTP daemon.
If you want to replace it (by `/pnfs` for instance), you will need to modify `config/gridftp.conf` (restrict\_paths)
and `docker-compose.yml` (volumes).

## Notes
Let's Encrypt certificates may not be trusted by your UI installation. If you have control over it, you can
install the package `ca_letsencrypt` and/or `ca_letsencrypt-fake` (only while testing) provided
on the [FTS repository](http://fts-repo.web.cern.ch/fts-repo/testing/).

Installing `ca_letsencrypt-fake` on production repositories is not advised.
