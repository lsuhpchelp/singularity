FROM kasmweb/chromium:x86_64-1.19.0

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="Chromium" \ 
    base_image="docker pull kasmweb/chromium:x86_64-1.19.0" \ 
    about.summary="Chromium built by Kasm Technologies (w/ added QT 5 support)" \ 
    software.version="1.19.0"

USER root
RUN apt update && apt install qtcreator qtbase5-dev qt5-qmake cmake -y
RUN rm /etc/chromium/policies/managed/urlblocklist.json
USER 1000