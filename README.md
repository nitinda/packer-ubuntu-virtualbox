# _Packer - Ubuntu Virual Box With Desktop_

<!--BEGIN STABILITY BANNER-->
---

![_Stability: Stable_](https://img.shields.io/badge/stability-Stable-success.svg?style=for-the-badge)

> **_This is a stable example. It should successfully build out of the box_**
>
---
<!--END STABILITY BANNER-->

_This example creates a **_Ubuntu Virtual Box_**._


**_Pre-built Vagrant Box_**:

  - [`vagrant init nitindas/ubuntu-18`](https://app.vagrantup.com/nitindas/boxes/ubuntu-18)

_This example build configuration installs and configures ubuntu desktop amd64._

---

## _Requirements_

_The following software must be installed/present on your local machine before you can use Packer to build the Vagrant box file:_

  - [_Packer_](http://www.packer.io/)
  - [_Vagrant_](http://vagrantup.com/)
  - [_VirtualBox_](https://www.virtualbox.org/) _(if you want to build the VirtualBox box)_

---

## _Usage_

_Make sure all the required software (listed above) is installed, then cd to the directory containing this README.md file, and run:_

* **_Ubuntu 18_**
    _$ cd ubuntu-18_
    _$ ubuntu-packer-build.sh 18.03 or 18.04 <VagrantCloud User/login> <VagrantCloud Password>_


* **_Ubuntu 20_**
    _$ cd ubuntu-20_
    _$ ubuntu-packer-build.sh <VagrantCloud User/login> <VagrantCloud Password>_


_After a few minutes, Packer should tell you the box was generated successfully, and the box was uploaded to Vagrant Cloud._

_> **Note**: This configuration includes a post-processor that pushes the built box to Vagrant Cloud (which requires a `VAGRANT_CLOUD_TOKEN` environment variable to be set); remove the `vagrant-cloud` post-processor from the Packer template to build the box locally and not push it to Vagrant Cloud. You don't need to specify a `version` variable either, if not using the `vagrant-cloud` post-processor._

## _Testing built boxes_

_There's an included Vagrantfile that allows quick testing of the built Vagrant boxes. From VagrantFile-Example/ directory, run one the following command after building the box:_

    _$ cd VagrantFile-Example/_
    _$ vagrant up_

---

## _Authors_
_Module maintained by Module maintained by the - **Nitin Das**_
