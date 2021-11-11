# -*- coding: utf-8 -*-

__authors__ = "Tong Zhang"
__contact__ = "Tong Zhang <zhangt@frib.msu.edu>"
__version__ = "7.0.6.1-1"
__doc__ = "AppImages built from EPICS base"

import pathlib
import subprocess
import sys

CWDIR = pathlib.Path(__file__).parent

APP_NAME_PATH_MAP = {
    f.name.rsplit('-', 1)[0]: f.resolve()
    for f in CWDIR.glob("**/*.AppImage")
}


def _run_appimage(name):
    """Run an AppImage.
    """
    cmd = [APP_NAME_PATH_MAP[name]] + sys.argv[1:]
    subprocess.run(cmd, stderr=subprocess.STDOUT)


def main():
    """Reserved for future.
    """
    pass


# EPICS base tools
run_epics_base_tools = lambda: _run_appimage('epics-base-tools')
# softIoc
run_softIoc = lambda: _run_appimage('softIoc')
# sofIocPVA
run_softIocPVA = lambda: _run_appimage('softIocPVA')
# caget
run_caget = lambda: _run_appimage('caget')
# caput
run_caput = lambda: _run_appimage('caput')
# cainfo
run_cainfo = lambda: _run_appimage('cainfo')
# camonitor
run_camonitor = lambda: _run_appimage('camonitor')
# pvget
run_pvget = lambda: _run_appimage('pvget')
# pvput
run_pvput = lambda: _run_appimage('pvput')
# pvinfo
run_pvinfo = lambda: _run_appimage('pvinfo')
# pvmonitor
run_pvmonitor = lambda: _run_appimage('pvmonitor')
# p2p
run_p2p = lambda: _run_appimage('p2p')
# pvcall
run_pvcall = lambda: _run_appimage('pvcall')
