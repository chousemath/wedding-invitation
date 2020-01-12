from os import listdir, path as p
from PIL import Image

files = listdir('./gifsrc')
for fpath, fname in [(p.join('gifsrc', x), x) for x in files if '.png' in x]:
    im = Image.open(fpath)
    bg = Image.new('RGB', im.size, (255,255,255))
    bg.paste(im,im)
    bg.save(p.join('gifsrcfinal', fname.replace('.png', '.jpg')))
