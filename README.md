# EPICS AppImage

This project is intended to provide prebuilt EPICS base tools in the form
of AppImages for the end-users, for those who usually do not need to have the full
EPICS base built. Tools like ``softIoc``, ``caget``, ``caput``, ``cainfo``,
``camonitor``, ``softIocPVA``, ``pvget``, ``pvput``, ``pvinfo``,
``pvmonitor``, etc. could be used in the command line interface. More tools
will be included in future releases.

## User Guide

### Installation
On an x86_64 machine, type in the Terminal with ``pip install epics-appimage`` will install all built AppImages.

Alternatively, each AppImage can also be downloaded from the release page,
``chmod +x <AppImage>`` and run it. If only one AppImage is needed, download
``epics-base-tools-x86_64.AppImage``.

### Run AppImage
Typical EPICS base tools could be invoked by just typing the name in the
Terminal, e.g. ``softIoc``, ``caget``, ``caput``, etc. Each command is
served from the regarding standalone AppImage.

One special command called ``epics-base-tools`` is built to be used as the
entry point for all the packaged tools, all packaged tools are sharing the
same libraries, thus this single AppImage is way more compact.

Type ``epics-base-tools`` in the Terminal will output the usage message:
```bash
Missing the app name!
Usage: epics-base-tools-x86_64.AppImage -i -l -h app-name

Run the deployed EPICS base tools.

Available options:

 -i, --info      EPICS base version
 -l, --list      All available EPICS base tools
 app-name        Name of one of the deployed tools
 -h, --help      Print this help and exit
 -v, --verbose   Print script debug info

Examples:
 # use caget tool
 epics-base-tools-x86_64.AppImage caget
 # create an alias for caget
 alias caget="epics-base-tools-x86_64.AppImage caget"
```

``epics-base-tools softIoc`` is equivalent as ``softIoc``, the same applies to other tools.

``--list`` or ``-l`` option lists all packaged EPICS base tools, e.g.:
``epics-base-tools -l`` outputs:
```bash
(26) apps are available:

acctst antelope ascheck caConnTest caEventRate caget cainfo camonitor caput caRepeater casw ca_test catime e_flex iocLogServer makeBpt msi p2p pvcall pvget pvinfo pvlist pvmonitor pvput softIoc softIocPVA

```

## Build AppImages from EPICS base
In the Terminal, run: ``make bootstrap | tee -a log``, edit `bootstrap.sh` as needed.
