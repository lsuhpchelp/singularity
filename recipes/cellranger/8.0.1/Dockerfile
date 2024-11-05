FROM rockylinux:9

MAINTAINER Jason Li <jasonli3@lsu.edu>

LABEL    software="Cellranger" \ 
    about.summary="Contains Cellranger 8.0.1, Cellranger-ARC 2.0.2, Cellranger-ATAC 2.1.0." \ 
    about.home="https://www.10xgenomics.com/support/software/cell-ranger/latest" \ 
    software.version="8.0.1"

# Update packages
RUN yum update -y
RUN yum install -y unzip which java
WORKDIR /opt

# Copy and install bcl2fastq2
COPY bcl2fastq2-v2-20-0-linux-x86-64.zip /opt
RUN unzip *.zip
RUN yum install -y *.rpm

# Download and unpack CellRanger
RUN curl -o cellranger-8.0.1.tar.gz "https://cf.10xgenomics.com/releases/cell-exp/cellranger-8.0.1.tar.gz?Expires=1730865953&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=ZZHillzCNp640FYNDkYu~HylSkhd4~w1YeU-VT~MJELtwMtC5VdSb2XxjkGHG52nWtLw~JYVmuYjfZRnzq-OiZQmS6qNCWFi1wEduGhmmKoIpC5jhap~4e~DGFPftn4-SJGKJqezxngHBwk7BKq8ItmhYYbWRPqLQ2gJk1Q1YqNUz04x4WXLKMHb20UIlBFaasHS-UQwaqLHxHQE4CHoAXJWaI32ApZk5m3ki2elvf5zZQQYS4tjntdpxj~m6oZaaYkpLg9RD7ntBTfBCgqPEhFLrYGGOdP2qM9mPauQzTVaNjyjYnnhCuqJXGlpbkLUz7-E7ZP2ArU9UKF9BvX9KQ__"
RUN tar -xf cellranger-8.0.1.tar.gz
ENV PATH=/opt/cellranger-8.0.1/bin:$PATH

# Download and unpack CellRanger-ARC
RUN curl -o cellranger-arc-2.0.2.tar.gz "https://cf.10xgenomics.com/releases/cell-arc/cellranger-arc-2.0.2.tar.gz?Expires=1730865633&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=Jg8ICT2CEXLuDCurTCaHsmQVl-RUp91A20UE8MrXVIns80T8bEFtoQA7HfHFMnkZywL5CU0Qc3o3C4NRFdbyNHk8P02cD3nWOIyNCzipFf~1x2aKuN2S3GSFKZ-8~xu6Sais6wD2ok--YMooXgU47FYkPWqw59WhVacJ-6LD9hEgKhDJqjgClWpTiWfCz0xyfZMBl93v9dKiTarIn3YCrjmAZRTjmjIbkNSlGUaN6j2STlYqlMznhQfs4uGDeoz5z~uQQJ~J-O9G07SpODXXoc6FUgedKwzs6NzL5v697em8v4yRHSjBUkmf-Hrk~PP-PA-FpEQxAX6zlOGktJIQMg__"
RUN tar -xf cellranger-arc-2.0.2.tar.gz 
ENV PATH=/opt/cellranger-arc-2.0.2/bin:$PATH

# Download and unpack CellRanger-ATAC
RUN curl -o cellranger-atac-2.1.0.tar.gz "https://cf.10xgenomics.com/releases/cell-atac/cellranger-atac-2.1.0.tar.gz?Expires=1730868795&Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9jZi4xMHhnZW5vbWljcy5jb20vcmVsZWFzZXMvY2VsbC1hdGFjL2NlbGxyYW5nZXItYXRhYy0yLjEuMC50YXIuZ3oiLCJDb25kaXRpb24iOnsiRGF0ZUxlc3NUaGFuIjp7IkFXUzpFcG9jaFRpbWUiOjE3MzA4Njg3OTV9fX1dfQ__&Signature=GW3WlQt8hNVlG93WN~GXKVCnY~QvO62v7us2jneh1bkoJ4SR2p6zieIRTs3lXb3ahsdpljvSY92Xo2laFdkjsDLq7Uwd22itfpzYNlFjBsh~HPUyEop5WJD86vAQHcksJOne4~gaIa1FyAyWBBQCbTK6lFIIb-ZhShfV6jx1A3f7hC27mxVsqA8LRVV37DrdJT93cWXXXm~iSrJoUd2DFtHInXPN6B9gu1R5OxrMf0VE9sGcBbWB66PKhbjVpzM0OeOX-3xjRmT9h1yutwBcW1l0l5wAhjfV1ZYNhMTlGGBHPuP8oZU3K2ku85UQSjmWRUWKaGljzDnd4tUi3rqivA__&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA"
RUN tar -xf cellranger-atac-2.1.0.tar.gz 
ENV PATH=/opt/cellranger-atac-2.1.0/bin:$PATH

# Clean garbage
RUN rm *.tar.gz *.rpm *.zip
RUN yum clean all
