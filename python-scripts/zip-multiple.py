#!/usr/bin/env python

import os
import shutil
import re

# base = '/home/hoshiro/Documents/Mangas/Blade of the Immortal'
base_dir = '/home/hoshiro/Documents/Mangas/Blade of the Immortal'
# base_dir = '/home/hoshiro/Documents/Mangas/Test Manga'

dirs = os.listdir(base_dir)

count = 0
max_chapter = -1
for dir in dirs:
    m = re.search('Chapter\s(\d+)', dir)
    chapter = int(m.group(1))
    max_chapter = max(max_chapter, chapter)

    files = os.listdir(os.path.join(base_dir, dir))
    count += len(files)


num_lenght = len(str(count))

m = re.search('[^\/]+(?=\/$|$)', base_dir)
manga_name = m.group(0)

tmp_dir  = f'/tmp/{manga_name}'
os.mkdir(tmp_dir)

print('Renaming files')

page_counter = 1
for chapter in range(1, max_chapter + 1):
    dir_path = os.path.join(base_dir, f'Chapter {chapter}')
    files = sorted(os.listdir(dir_path))

    for file in files:
        original_path = os.path.join(dir_path, file)
        filename = str(page_counter).zfill(num_lenght) + '.jpg'
        new_path = os.path.join(tmp_dir, filename)

        shutil.copy(original_path, new_path)

        page_counter += 1

print('Files renamed')

print('Creating cbz')
# create new cbz
cbz_path = os.path.join(os.getcwd(), manga_name)
shutil.make_archive(cbz_path, 'zip', tmp_dir)
os.rename(f'{cbz_path}.zip', f'{cbz_path}.cbz')

print('Cbz created')

#remove
shutil.rmtree(tmp_dir)

print('Finish')
