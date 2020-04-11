# shorewall-backport

Backport of `shorewall` for Debian Buster

This allows `shorewall` to work with `docker`.


## Building

Building requires `docker`. The following commands will create a `build` folder containing the built debs.

```

git clone https://github.com/phlax/shorewall-backport
cd shorewall-backport
make debs

```

## Usage

There are some unsigned prebuilt debs for `shorewall`.

These can be accessed with the following command

```
mkdir shorewall-build
docker run \
	-v `pwd`/shorewall-build:/tmp/build phlax/shorewall-backport \
	bash -c "cp -a /usr/share/shorewall-backport/*deb /tmp/build"

```

The prebuilt debs are useful for testing only.

For production use you are strongly recommended to build your own debs.
