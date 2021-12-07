# -*- coding: utf-8 -*-
"""Entrypoints for all available appimages.
"""

import pathlib
import subprocess
import sys

PKG_DIR = pathlib.Path(__file__).parent.parent
APP_NAME_PATH_MAP = {
    f.name.rsplit('-', 1)[0]: f.resolve()
    for f in PKG_DIR.glob("**/*.AppImage")
}


class AppRunner(object):
    def __init__(self, app_name):
        self._fn = APP_NAME_PATH_MAP[app_name]

    def __call__(self):
        """Run an AppImage."""
        cmd = [self._fn] + sys.argv[1:]
        subprocess.run(cmd, stderr=subprocess.STDOUT)


# create exec functions for each appimage
_fn_name_exec_map = {}  # CLI tool name : entry point function
for _app in APP_NAME_PATH_MAP:
    _fn_name = 'run_' + _app.replace("-", "_")
    globals()[_fn_name] = AppRunner(_app)
    _fn_name_exec_map[_app] = _fn_name
