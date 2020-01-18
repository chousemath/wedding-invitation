import sys
import os
from shutil import copy2, rmtree
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
    FPS = 14

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
rmtree(dest, ignore_errors=True)
os.mkdir(dest)
paths = []
for item in [os.path.join(temp, x) for x in dirs if '.png' in x.lower()]:
    if os.path.isfile(item):
        im = Image.open(item)
        im.thumbnail((150, 150), Image.ANTIALIAS)
        rgb_im = im.convert('RGB')
        name = item.split('/')[-1]
        new_path = os.path.join(dest, name.replace('png', 'jpg'))
        paths.append(new_path)
        rgb_im.save(new_path, 'JPEG', quality=65)

paths.sort(reverse=True)
max_val = int(paths[0].split('/')[-1].replace('.jpg', ''))

for i, fpath in enumerate(paths):
    val = max_val + i + 1
    lx = 5 - len(str(val))
    new_path = os.path.join(dest, (lx * '0') + str(val) + '.jpg')
    copy2(fpath, new_path)


cmd = 'convert -delay 1x%(FPS)i %(TEMP)s %(out_name)s' % {
	'FPS': FPS,
	'TEMP': os.path.join(dest, '*.jpg'),
	'out_name': out_name
}

subprocess.check_call(cmd, shell=True)
shutil.rmtree(temp)
cmd = 'open -R %(out_name)s' % {'out_name': out_name}
subprocess.check_call(cmd, shell=True)

