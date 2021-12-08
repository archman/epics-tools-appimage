# -*- coding: utf-8 -*-
"""Entrypoints for all available appimages.
"""

import pathlib
import subprocess
import sys

# global entry point
LAUNCHER_NAME = 'epics-base-tools'

PKG_DIR = pathlib.Path(__file__).parent.parent
APP_NAME_PATH_MAP = {
    f.name.rsplit('-', 1)[0]: f.resolve()
    for f in PKG_DIR.glob("AppImages/*.AppImage")
}

r = subprocess.run(APP_NAME_PATH_MAP[LAUNCHER_NAME], capture_output=True, text=True)
# a list of app names which could be launched from the global entry point
SUPPORT_APP_LIST = r.stdout.strip().split()


class AppRunner(object):
    def __init__(self, app_name):
        self._cmdlist = [APP_NAME_PATH_MAP[LAUNCHER_NAME], app_name]

    def __call__(self):
        """Run an AppImage."""
        cmd = self._cmdlist + sys.argv[1:]
        subprocess.run(cmd, stderr=subprocess.STDOUT)


# create exec functions for each appimage
_fn_name_exec_map = {}  # CLI tool name : entry point function
for _app in APP_NAME_PATH_MAP:
    _fn_name = 'run_' + _app.replace("-", "_")
    globals()[_fn_name] = AppRunner(_app)
    _fn_name_exec_map[_app] = _fn_name
