#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import setuptools

from _epics_appimage_apps import _fn_name_exec_map


def readme():
    with open("README.md", "r") as f:
        return f.read()


def set_entry_points():
    r = {}
    r['console_scripts'] = []
    for app, fn_name in _fn_name_exec_map.items():
        r['console_scripts'].append(f"{app}=epics_appimage.apps:{fn_name}")
    return r


_name = "epics-appimage"
_version = "7.0.6.1-6"

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
    packages=['epics_appimage', 'epics_appimage.apps'],
    package_dir={
        'epics_appimage': '.',
        'epics_appimage.apps': '_epics_appimage_apps',
    },
    entry_points=set_entry_points(),
)
