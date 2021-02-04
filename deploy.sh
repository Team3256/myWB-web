#!/bin/bash
HOST=ftp.vcrobotics.net
USER=robotics@vcrobotics.info
PASSWORD=r0b0w3bs!te

#flutter clean
#flutter build web

cd build/web

ncftp -u robotics@vcrobotics.info ftp.vcrobotics.net
mput -r /*