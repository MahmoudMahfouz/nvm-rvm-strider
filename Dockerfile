FROM ubuntu:14.04
MAINTAINER Mahmoud Mahfouz <mahmoud.mahfouz.zaza@gmail.com>

ADD sv_stdout.conf /etc/supervisor/conf.d/
ENV STRIDER_VERSION master
ENV STRIDER_REPO https://github.com/Strider-CD/strider

ENV HOME /home/strider
ENV NODE_V 0.10.30
ENV BASH_ENV /etc/bash.bashrc
ENV RUBY_VERSIONS ruby-2.2.0

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV RUBY_VERSIONS ruby-2.1.3

RUN apt-get update && \
  apt-get install -y git supervisor python-pip && \
  pip install supervisor-stdout && \
  sed -i 's/^\(\[supervisord\]\)$/\1\nnodaemon=true/' /etc/supervisor/supervisord.conf

RUN apt-get install -y nginx openssh-server git-core openssh-client curl
RUN apt-get install -y nano
RUN apt-get install -y build-essential
RUN apt-get install -y openssl libreadline6 libreadline6-dev curl zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config gawk libgdbm-dev libffi-dev libmysqlclient-dev

ADD sv_stdout.conf /etc/supervisor/conf.d/

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

VOLUME /home/strider/.strider
RUN mkdir -p /home/strider && mkdir -p /opt/strider
RUN adduser --disabled-password --gecos "" --home /home/strider strider
RUN chown -R strider:strider /home/strider
RUN chown -R strider:strider /opt/strider
RUN ln -s /opt/strider/src/bin/strider /usr/local/bin/strider
USER strider

RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash && \
	. ~/.nvm/nvm.sh && \
	nvm install "$NODE_V" && \
	nvm use "$NODE_V" && \
	nvm alias default "$NODE_V"

RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN /bin/bash -l -c "\curl -L https://get.rvm.io | bash -s stable && source  ~/.rvm/scripts/rvm && rvm requirements && rvm install $RUBY_VERSIONS && gem install bundler --no-ri --no-rdoc"

RUN /bin/bash -l -c "git clone --branch $STRIDER_VERSION --depth 1 $STRIDER_REPO /opt/strider/src && \
  source $HOME/.nvm/nvm.sh && \
  cd /opt/strider/src && \
  npm install && \
  npm run build"

RUN echo "export PATH=$PATH:$NVM_BIN" >> ~/.profile
RUN echo "export PATH=$PATH:$rvm_bin_path" >> ~/.profile
RUN echo "source $HOME/.nvm/nvm.sh" >> ~/.profile
RUN echo "source $HOME/.rvm/scripts/rvm" >> ~/.profile
COPY start.sh /usr/local/bin/start.sh
ADD strider.conf /etc/supervisor/conf.d/strider.conf
EXPOSE 3000
USER root
CMD ["bash", "--login", "/usr/local/bin/start.sh"]
