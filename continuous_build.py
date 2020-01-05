from time import sleep
import os

while True:
    os.system('elm make src/Main.elm --output=elm.js')
    sleep(1)
