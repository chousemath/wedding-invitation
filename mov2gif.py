import sys
import os
from shutil import copy2
import tempfile
import shutil
import subprocess
from PIL import Image


if len(sys.argv) <= 2:
    sys.exit(-1)

assert(os.path.exists(sys.argv[1]))
inp_name = sys.argv[1]
out_name = sys.argv[2]

try:
    FPS = int(sys.argv[3])
except Exception as e:
    FPS = 10

temp = tempfile.mkdtemp()

temp_name = os.path.join(temp, '%5d.png')
cmd = 'ffmpeg -loglevel quiet -i %(inp_name)s  -pix_fmt rgb24 -crf 37 -r %(FPS)i %(TEMP)s' % {
    'inp_name': inp_name,
    'FPS': FPS,
    'TEMP': temp_name,
}
subprocess.check_call(cmd, shell=True)

dirs = os.listdir(temp)
dest = './frames'
for item in [os.path.join(temp, x) for x in dirs if '.png' in x.lower()]:
    if os.path.isfile(item):
        im = Image.open(item)
        im.thumbnail((200,200), Image.ANTIALIAS)
        im.save(item, 'PNG', quality=80)
        shutil.copy2(item, dest)

cmd = 'convert -delay 1x%(FPS)i %(TEMP)s %(out_name)s' % {
	'FPS': FPS,
	'TEMP': os.path.join(temp, '*.png'),
	'out_name': out_name
}
subprocess.check_call(cmd, shell=True)
shutil.rmtree(temp)
cmd = 'open -R %(out_name)s' % {'out_name': out_name}
subprocess.check_call(cmd, shell=True)

