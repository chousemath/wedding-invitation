import sys
import os
from shutil import copy2
import tempfile
import shutil
import subprocess
from PIL import Image


cmd = 'convert -delay 1x%(FPS)i %(TEMP)s %(out_name)s' % {
	'FPS': 15,
	'TEMP': os.path.join('gifsrc', '*.png'),
	'out_name': 'sk.gif'
}
subprocess.check_call(cmd, shell=True)
