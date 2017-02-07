#!/usr/bin/env python

import eyed3
import sys
from os import listdir
from os.path import isfile, join

if len(sys.argv) < 4:
    print sys.argv[0] + ' <music-dir> <artist> <album>'
    exit(1)


work_path = sys.argv[1]
artist = sys.argv[2]
album = sys.argv[3]

print artist
print album

mp3_files = [f for f in listdir(work_path) if isfile(join(work_path, f))]

for f in mp3_files:
    tokens = f.split('.')
    if tokens[-1].lower() != 'mp3':
        continue
    print work_path + '/' + f
    audiofile = eyed3.load(work_path + '/' + f)
    audiofile.tag.artist = unicode(artist, 'utf-8')
    audiofile.tag.album = unicode(album, 'utf-8')
    audiofile.tag.title = unicode(tokens[1], 'utf-8')
    audiofile.tag.track_num = int(tokens[0])
    audiofile.tag.save()
