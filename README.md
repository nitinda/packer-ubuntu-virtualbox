# _Packer - Ubuntu 18.04 Vagrant Box With Desktop_

<!--BEGIN STABILITY BANNER-->
---

![_Stability: Stable_](https://img.shields.io/badge/stability-Stable-success.svg?style=for-the-badge)

> **_This is a stable example. It should successfully build out of the box_**
>
> _This examples does is built on Construct Libraries marked "Stable" and does not have any infrastructure prerequisites to build._

---
<!--END STABILITY BANNER-->

_This example creates a **Ubuntu Virtual Box : 18.04**._


**_Pre-built Vagrant Box_**:

  - [`vagrant init nitindas/ubuntu-18`](https://app.vagrantup.com/nitindas/boxes/ubuntu-18)

_This example build configuration installs and configures ubuntu 18.04 amd64._

---

## _Requirements_

_The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:_

  - [_Packer_](http://www.packer.io/)
  - [_Vagrant_](http://vagrantup.com/)
  - [_VirtualBox_](https://www.virtualbox.org/) (if you want to build the VirtualBox box)

---

## _Usage_

_Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:_

    $ ubuntu-18.04.3-packer-build.sh <VagrantCloud User/login> <VagrantCloud Password>

_After a few minutes, Packer should tell you the box was generated successfully, and the box was uploaded to Vagrant Cloud._

_> **Note**: This configuration includes a post-processor that pushes the built box to Vagrant Cloud (which requires a `VAGRANT_CLOUD_TOKEN` environment variable to be set); remove the `vagrant-cloud` post-processor from the Packer template to build the box locally and not push it to Vagrant Cloud. You don't need to specify a `version` variable either, if not using the `vagrant-cloud` post-processor._

## _Testing built boxes_

_There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From VagrantFile-Example/ directory, run one the following command after building the box:_

    $ cd VagrantFile-Example/
    $ vagrant up

---

## _Authors_
_Module maintained by Module maintained by the - **Nitin Das**_
