#!/usr/bin/env python3
# -*- coding: utf-8 -*-
import setuptools
import pathlib

CWDIR = pathlib.Path(__file__).parent


def readme():
    with open("README.md", "r") as f:
        return f.read()


def set_entry_points():
    r = {}
    r['console_scripts'] = []
    for f in CWDIR.glob("AppImages/**/*.AppImage"):
        exec_name = f.name.rsplit('-', 1)[0]
        entry_name = 'run_' + exec_name.replace("-", "_")
        r['console_scripts'].append(f"{exec_name}=epics_appimage:{entry_name}")
    return r


_name = "epics-appimage"
_version = "7.0.6.1-1"

setuptools.setup(
    name=_name,
    version=_version,
    author="Tong Zhang",
    author_email="zhangt@frib.msu.edu",
    description="AppImages built from EPICS base",
    long_description=readme(),
    long_description_content_type='text/markdown',
    url='https://github.com/archman/epics-appimage',
    download_url='https://pypi.org/project/epics-appimage',
    license='GPLv3',
    install_requires=[],
    classifiers=[
        'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
        'Topic :: Software Development', 'Topic :: Scientific/Engineering',
        'Operating System :: POSIX :: Linux'
    ],
    include_package_data=True,
    packages=[
        'epics_appimage',
    ],
    package_dir={
        'epics_appimage': '.',
    },
    entry_points=set_entry_points(),
)
