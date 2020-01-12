from moviepy.editor import *

clip = (VideoFileClip('sk.mov')
    .subclip((0, 0), (0, 5))
    .resize(0.3))
clip.write_gif('sk.gif')
