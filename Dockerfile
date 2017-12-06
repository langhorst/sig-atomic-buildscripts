FROM fedora:25

# install needed packages

RUN dnf install -y rpm-ostree git python; \
dnf clean all

# create working dir, clone fedora atomic definitions

RUN mkdir -p /srv; \
cd /srv; \
git clone https://github.com/langhorst/sig-atomic-buildscripts; \

# create and initialize repo directory

mkdir -p /srv/jel-atomic-host-repo && \
cd /srv/ && \
ostree --repo=jel-atomic-host-repo init --mode=archive-z2; \

# make a cache dir

mkdir -p /srv/jel-atomic-host-cache

# expose default SimpleHTTPServer port, set working dir

EXPOSE 8000
WORKDIR /srv

# start SimpleHTTPServer

CMD python -m SimpleHTTPServer
