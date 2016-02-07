FROM ruby:2.2.4-onbuild
EXPOSE 9000


#install ffmpeg
#RUN deb http://www.deb-multimedia.org jessie main non-free\
#		&& deb-src http://www.deb-multimedia.org jessie main non-free\
#		&&apt-get update\
#		&& apt-get install deb-multimedia-keyring\
#		&& apt-get update\
#		&& apt-get remove ffmpeg\
#		&& apt-get install build-essential libmp3lame-dev libvorbis-dev libtheora-dev libspeex-dev yasm pkg-config libfaac-dev libopenjpeg-dev libx264-dev\
#		&& wget http://ffmpeg.org/releases/ffmpeg-2.7.2.tar.bz2\
#		&& tar xvjf ffmpeg-2.7.2.tar.bz2\
#		&& cd ffmpeg-2.7.2\
#		&& ./configure --enable-gpl --enable-postproc --enable-swscale --enable-avfilter --enable-libmp3lame --enable-libvorbis --enable-libtheora --enable-libx264 --enable-libspeex --enable-shared --enable-pthreads --enable-libopenjpeg --enable-libfaac --enable-nonfree\
#		&& make\
#		&& make install\
#		&& cd ..\
#		&& /sbin/ldconfig

RUN apt-get update && apt-get install -y \
      autoconf \
			libtag1-dev\
      build-essential \
      imagemagick \
      libbz2-dev \
      libcurl4-openssl-dev \
      libevent-dev \
      libffi-dev \
      libglib2.0-dev \
      libjpeg-dev \
      liblzma-dev \
      libmagickcore-dev \
      libmagickwand-dev \
      libmysqlclient-dev \
      libncurses-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      libxml2-dev \
      libxslt-dev \
      libyaml-dev \
      zlib1g-dev \
      bison \
      libgdbm-dev \
      ruby \
      && rm -rf /var/lib/apt/lists/*
