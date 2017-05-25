# Visual Studio Code in a container
#	some of the code copied from https://github.com/jessfraz/dockerfiles/blob/master/vscode/Dockerfile
#
# docker run -d \
#    -v /tmp/.X11-unix:/tmp/.X11-unix \
#    -v $HOME:/home/user \
#    -e DISPLAY=unix$DISPLAY \
#    --device /dev/dri \
#    --name vscode \
#    --net="host" \
#    insready/vscode-php

FROM php:7.1
LABEL maintainer "Jingsheng Wang <skyred@insready.com>"

# https://code.visualstudio.com/Download
ENV CODE_VERSION 1.12.1-1493934083
ENV CODE_COMMIT f6868fce3eeb16663840eb82123369dec6077a9b

# Setup vscode repo, see #https://code.visualstudio.com/docs/setup/linux
RUN curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg \
	&& mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg \
	&& sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

RUN apt-get update && apt-get install -y \
    code \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

COPY start.sh /usr/local/bin/start.sh

ENV HOME /home/user
RUN useradd --create-home --home-dir $HOME user \
	&& chown -R user:user $HOME

WORKDIR $HOME

CMD [ "start.sh" ]