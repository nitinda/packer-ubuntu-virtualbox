# Packer - Ubuntu 18.04.03 Vagrant Box With Desktop

**_Current ubuntu Version Used_**: **_18.04.03_**

**Pre-built Vagrant Box**:

  - [`vagrant init nitindas/ubuntu-18`](https://app.vagrantup.com/nitindas/boxes/ubuntu-18)

This example build configuration installs and configures ubuntu 18.04.03 amd64.

## Requirements

The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:

  - [Packer](http://www.packer.io/)
  - [Vagrant](http://vagrantup.com/)
  - [VirtualBox](https://www.virtualbox.org/) (if you want to build the VirtualBox box)

## Usage

Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:

    $ ubuntu-18.04.3-packer-build.sh <VagrantCloud User/login> <VagrantCloud Password>

After a few minutes, Packer should tell you the box was generated successfully, and the box was uploaded to Vagrant Cloud.

> **Note**: This configuration includes a post-processor that pushes the built box to Vagrant Cloud (which requires a `VAGRANT_CLOUD_TOKEN` environment variable to be set); remove the `vagrant-cloud` post-processor from the Packer template to build the box locally and not push it to Vagrant Cloud. You don't need to specify a `version` variable either, if not using the `vagrant-cloud` post-processor.

## Testing built boxes

There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From VagrantFile-Example/ directory, run one the following command after building the box:

    $ cd VagrantFile-Example/
    $ vagrant up

## License

MIT license.