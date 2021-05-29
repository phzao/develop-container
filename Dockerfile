FROM alpine:3.12

WORKDIR /home/dev

RUN apk --no-cache add zip unzip git nodejs xfce4-dev-tools build-base zsh tmux openrc \
  alpine-sdk libtool automake m4 autoconf linux-headers tini ripgrep lm-sensors-sensord \
  make fontconfig \
  cmake \
  && rm -rf /var/cache/apk/*

ENV UID="1000" \
	GID="1000" \
	UNAME="dev" \
	GNAME="dev" \
	SHELL="/bin/bash" \
	WORKSPACE="/development" \
	USERSPACE="/home/dev" \
	NVIM_CONFIG="/home/dev/.config/nvim" \
	NVIM_PCK="/home/dev/.local/share/nvim/site/pack" \
	ENV_DIR="/home/dev/.local/share/vendorvenv" \
	NVIM_PROVIDER_PYLIB="python3_neovim_provider" \
	PATH="/home/dev/.local/bin:${PATH}"

# python 
ENV PYTHONUNBUFFERED=1
RUN apk add --update --no-cache python3 && ln -sf python3 /usr/bin/python
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools

	# install packages
RUN	apk --no-cache add \
		# needed by neovim :CheckHealth to fetch info
	curl \
		# needed to change uid and gid on running container
	shadow \
		# needed to install apk packages as neovim user on the container
	sudo \
		# needed to switch user
        su-exec \
		# needed for neovim python3 support
	python3 \
  lm-sensors lm-sensors-detect \
		# needed for pipsi
	py3-virtualenv \
        neovim-doc \
	bash \
	&& apk --no-cache add --virtual build-dependencies \
  lua5.3-dev \
	python3-dev \
	gcc \
	musl-dev \
  lua5.3-libs \
  xclip \
	git \
	# create user
	&& addgroup "${GNAME}" \
	&& adduser -D -G "${GNAME}" -g "" -s "${SHELL}" "${UNAME}" \
        && echo "${UNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
	# install neovim python3 provide
	&& sudo -u dev python3 -m venv "${ENV_DIR}/${NVIM_PROVIDER_PYLIB}" \
	&& "${ENV_DIR}/${NVIM_PROVIDER_PYLIB}/bin/pip" install pynvim \
	# install pipsi and python language server
	&& curl https://raw.githubusercontent.com/mitsuhiko/pipsi/master/get-pipsi.py | sudo -u dev python3 \ 
  && sudo -u dev pipsi install python-language-server

RUN apk add --no-cache zsh-vcs openssh-keygen pcre-dev xz-dev g++ npm
RUN sudo -u dev sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

COPY .zshrc ${USERSPACE}/.zshrc
COPY .tmux.conf ${USERSPACE}/.tmux.conf
COPY init.vim ${NVIM_CONFIG}/init.vim
COPY oh-my.sh ${USERSPACE}/oh-my.sh

RUN chmod +x ${USERSPACE}/oh-my.sh
RUN cd ${USERSPACE}
RUN chown -R dev:dev ${USERSPACE}
RUN sudo -u dev ./oh-my.sh

ENV LC_ALL=C.UTF-8 
ENV LANG=C.UTF-8 
ENV TZ America/Sao_Paulo

RUN git clone https://github.com/neovim/neovim.git && \
  cd neovim && \
  make DCMAKE_INSTALL_PREFIX=/home/dev/neovim && \
  make install

ENV PATH="/home/dev/neovim/bin:$PATH"

RUN chown -R dev:dev /usr/lib/node_modules

RUN git clone https://github.com/ggreer/the_silver_searcher.git
RUN chown -R dev:dev ${USERSPACE}  &&\
    cd the_silver_searcher && \
	./build.sh && \
	make install

RUN cd ${USERSPACE} && \
     cd .nvm && \
	 chmod +x nvm.sh && \
	 ./nvm.sh

RUN mkdir ~/.npm-global
RUN npm config set prefix '~/.npm-global'

RUN apk add fzf

RUN apk add openssh
RUN set -eux \
    & apk add \
        --no-cache \
        nodejs \
        yarn

ENTRYPOINT ["/bin/zsh"]
