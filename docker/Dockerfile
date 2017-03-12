FROM ubuntu:16.04

MAINTAINER pankona

RUN useradd -m -d /home/docker -s /bin/bash docker \
 && echo "docker:docker" | chpasswd

# Install packages for building ruby
RUN apt-get update
RUN apt-get install -y --force-yes build-essential curl git
RUN apt-get install -y --force-yes zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev
RUN apt-get clean

# Install rbenv and ruby-build
RUN git clone https://github.com/sstephenson/rbenv.git /home/docker/.rbenv
RUN git clone https://github.com/sstephenson/ruby-build.git /home/docker/.rbenv/plugins/ruby-build
RUN /home/docker/.rbenv/plugins/ruby-build/install.sh
ENV PATH /home/docker/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> /home/docker/.bashrc

# Install multiple versions of ruby
ENV CONFIGURE_OPTS --disable-install-doc
ADD ./versions.txt /home/docker/versions.txt
RUN xargs -L 1 rbenv install < /home/docker/versions.txt

# Install Bundler for each version of ruby
RUN echo 'gem: --no-rdoc --no-ri' >> /.gemrc
RUN bash -l -c 'for v in $(cat /home/docker/versions.txt); do rbenv global $v; gem install bundler; done'

RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN /bin/bash -c "source /home/docker/.bashrc"
RUN chown docker:docker -R /home/docker

USER docker
WORKDIR /home/docker
ENV HOME /home/docker

RUN xargs -L 1 rbenv install < /home/docker/versions.txt
ENV PATH /home/docker/.rbenv/bin:$PATH
RUN bash -l -c 'for v in $(cat /home/docker/versions.txt); do rbenv global $v; gem install bundler; done'


ENTRYPOINT ["/bin/bash", "--login", "-c"]
