FROM debian:11.3

WORKDIR task/
COPY . .

RUN apt-get update
RUN apt-get install -yy lsb-release

ENTRYPOINT [ "sh", "-c", "lsb_release -a > info.txt" ]
