FROM      ubuntu:latest
MAINTAINER Andrei Baskakau <Andrei_Baskakau@epam.com>

ENV DEBIAN_FRONTEND noninteractive

ARG PENTAHO_USER=devuser
ARG PENTAHO_USER_PASSWORD=pentaho06
ARG PENTAHO_USER_HOME=/home/$PENTAHO_USER
ARG PENTAHO_HOME=$PENTAHO_USER_HOME/pentaho
ARG BUILD_VERSION
ARG BUILD_NUMBER

RUN useradd -ms /bin/bash $PENTAHO_USER
RUN echo "$PENTAHO_USER:$PENTAHO_USER_PASSWORD" | chpasswd
RUN echo "root:$PENTAHO_USER_PASSWORD" | chpasswd
WORKDIR $PENTAHO_USER_HOME

ADD resource/. $PENTAHO_USER_HOME

RUN bash prepare.sh
RUN bash install-java.sh
RUN bash get-pentaho.sh $BUILD_VERSION $BUILD_NUMBER

RUN bash install.sh $BUILD_VERSION $PENTAHO_USER_HOME/pentaho-business-analytics-$BUILD_VERSION-$BUILD_NUMBER-x64.bin $PENTAHO_HOME

EXPOSE 8080

ENTRYPOINT /home/devuser/start.sh && bash