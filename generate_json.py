# -*- coding: utf-8 -*-

import json
from time import time
from datetime import datetime, timedelta
from random import choice
from random import randint, shuffle
import json
import unicodedata as ud
import io

def norm(input: str) -> str:
    return ud.normalize('NFC', input)


words = """새로운보수당이 오늘 창당한다. 당은 ‘순환형 집단대표 체제’를 도입해 첫 책임대표는 하태경 의원이 맡는다. 새보수당 측에 따르면 새보수당은 5일 오후 2시 국회 의원회관 대회의실에서 ‘새로운보수당 중앙당 창당대회’를 진행한다. 새보수당은 초재선 의원을 중심으로 지도부가 꾸려질 예정이지만, 당 안팎에서는 유일 대선주자인 유승민 의원을 사실당 당의 기둥으로 보고 있다. 유 의원은 앞서 바른정당에서 ‘개혁보수’를 당의 가치로 내걸었지만, 대선 참패와 당내 의원들의 연이은 탈당으로 사실상 실패를 맛봤다. 2018년 지방선거를 앞두고는 안철수 전 대표가 이끄는 국민의당과 통합해 ‘합리적 중도·개혁적 보수’를 내세우면서 정국 전환을 시도했지만, 또 선거 참패를 겪었다."""
words = words.split(' ')
now = datetime.now() # current date and time
gen_dt = lambda: (now - timedelta(days=randint(1, 100))).strftime('%Y-%m-%d')
rand_words = lambda x: norm(' '.join([choice(words) for _ in range(0, x)]))
gen_comment = lambda: {'author': rand_words(1), 'content': rand_words(7), 'createdAt': gen_dt()}
comments = [gen_comment() for _ in range(0, 10)]

photos = [
        'DSC00897_Resize.jpg',
        'DSC00314_Resize.jpg',
        'DSC00746_Resize.jpg',
        'DSC00421_Resize.jpg',
        'DSC00886_Resize.jpg',
        'DSC00900_Resize.jpg',
        'DSC00446_Resize.jpg',
        'DSC00873_Resize.jpg',
        'DSC00297_Resize.jpg',
        ]
shuffle(photos)
data = {'comments': comments, 'photos': photos}
response = {'ok': True, 'data': data}

with io.open('response.json', 'w', encoding='utf-8') as f:
    f.write(json.dumps(response, ensure_ascii=False, indent=4))

