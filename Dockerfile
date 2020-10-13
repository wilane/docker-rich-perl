FROM ubuntu:latest

LABEL version="1.10"
LABEL maintainer="Steve Guo <steve.guo@thunes.com>"

RUN apt-get update \
    && apt-get -y install build-essential git curl zip runit \
    && apt-get -y install libqrencode-dev libexpat1-dev libxml2-dev zlib1g-dev \
    && apt-get -y install libssl-dev libcrypto++-dev libz-dev \
    && apt-get -y install libpq-dev \
    && apt-get clean

# Install plenv
RUN git clone https://github.com/tokuhirom/plenv.git /usr/share/plenv
RUN git clone https://github.com/tokuhirom/Perl-Build.git ~/.plenv/plugins/perl-build
ENV PATH /usr/share/plenv/bin:$PATH

RUN plenv install 5.24.0 -j 20 --noman > /dev/null
RUN plenv install 5.26.0 -j 20 --noman > /dev/null
#RUN plenv install 5.28.0 -j 20 --noman > /dev/null
RUN plenv install 5.30.0 -j 20 --noman > /dev/null
RUN plenv install 5.32.0 -j 20 --noman > /dev/null

RUN rm -rfv ~/.plenv/build/* && rm -rfv ~/usr/share/plenv/build/*

RUN eval "$(plenv init -)" && cd ~/ \
    && plenv local 5.24.0 && plenv install-cpanm && plenv rehash \
    && cpanm -n Carton && plenv rehash

RUN eval "$(plenv init -)" && cd ~/ \
    && plenv local 5.26.0 && plenv install-cpanm && plenv rehash \
    && cpanm -n Carton && plenv rehash

RUN eval "$(plenv init -)" && cd ~/ \
    && plenv local 5.30.0 && plenv install-cpanm && plenv rehash \
    && cpanm -n Carton && plenv rehash

RUN eval "$(plenv init -)" && cd ~/ \
    && plenv local 5.32.0 && plenv install-cpanm && plenv rehash \
    && cpanm -n Carton && plenv rehash

COPY ./init.sh /init.sh

WORKDIR /root

ENTRYPOINT ["/init.sh"]

CMD ["perl", "-de0"]
