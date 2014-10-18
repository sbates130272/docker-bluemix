#
# bluemix Dockerfile
#
# https://github.com/sbates130272/docker-bluemix
#

# Pull base image.
FROM dockerfile/ubuntu

# Set the maintainer
MAINTAINER Stephen Bates (sbates130272) <sbates@raithlin.com>

# Install the Cloudfoundry CLI code from Github, we also need
# git and python and some python add-ins so we install them too.
# Since this container may well run in interactive mode we also
# install things like emacs and ipython. As per Dockerfile best
# practices we split this up to get snapshots along the way. We also
# install go.
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y python
RUN apt-get install -y python-dev
RUN apt-get install -y python-pip
RUN apt-get install -y python-setuptools
RUN apt-get install -y emacs
RUN apt-get install -y golang
#RUN apt-get install -y golang-bindata-dev
RUN pip install ipython
RUN git clone https://github.com/cloudfoundry/cli.git

# Now cd into the working folder and setup and install the API
# module. Note we do this on the same RUN comma
RUN mkdir go
ENV GOPATH $HOME/go
RUN go get github.com/jteeuwen/go-bindata/...
RUN cp $GOPATH/bin/go-bindata /usr/bin/
WORKDIR cli
RUN git checkout v6.6.2
RUN ./bin/build
RUN cp ./out/cf /usr/bin/
