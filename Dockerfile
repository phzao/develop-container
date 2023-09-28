FROM alpine:3.12

ENV NODE_VERSION 16.13.1

WORKDIR /home/dev

RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk add --no-cache \
        libstdc++ \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && ARCH= && alpineArch="$(apk --print-arch)" \
      && case "${alpineArch##*-}" in \
        x86_64) \
          ARCH='x64' \
          CHECKSUM="3b4c47e5554fa466651a767691fc76c09b6a514b49d79bbd0061e549614adedf" \
          ;; \
        *) ;; \
      esac \
  && if [ -n "${CHECKSUM}" ]; then \
    set -eu; \
    curl -fsSLO --compressed "https://unofficial-builds.nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz"; \
    echo "$CHECKSUM  node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" | sha256sum -c - \
      && tar -xJf "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
      && ln -s /usr/local/bin/node /usr/local/bin/nodejs; \
  else \
    echo "Building from source" \
    # backup build
    && apk add --no-cache --virtual .build-deps-full \
        binutils-gold \
        g++ \
        gcc \
        gnupg \
        libgcc \
        linux-headers \
        make \
        python3 \
    # gpg keys listed at https://github.com/nodejs/node#release-keys
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      74F12602B6F1C4E913FAA37AD3A89613643B6201 \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION.tar.xz" \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
    && tar -xf "node-v$NODE_VERSION.tar.xz" \
    && cd "node-v$NODE_VERSION" \
    && ./configure \
    && make -j$(getconf _NPROCESSORS_ONLN) V= \
    && make install \
    && apk del .build-deps-full \
    && cd .. \
    && rm -Rf "node-v$NODE_VERSION" \
    && rm "node-v$NODE_VERSION.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt; \
  fi \
  && rm -f "node-v$NODE_VERSION-linux-$ARCH-musl.tar.xz" \
  && apk del .build-deps \
  # smoke tests
  && node --version \
  && npm --version

ENV YARN_VERSION 1.22.15

RUN apk add --no-cache --virtual .build-deps-yarn curl gnupg tar \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
    gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && apk del .build-deps-yarn \
  # smoke test
  && yarn --version

#COPY docker-entrypoint.sh /usr/local/bin/

RUN apk --no-cache add zip unzip apache2-utils git xfce4-dev-tools build-base zsh tmux openrc \
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
	python2 \
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

RUN git clone https://github.com/neovim/neovim && \
    cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

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

# If you also need fonts then add this - Select any fonts from here https://wiki.alpinelinux.org/wiki/Fonts
# Just replace ttf-ubuntu-font-family with fonts that you need
RUN apk --update add ttf-ubuntu-font-family fontconfig && rm -rf /var/cache/apk/*

# if ever you need to change phantom js version number in future ENV comes handy as it can be used as a dynamic variable
ENV PHANTOMJS_VERSION=2.1.1

# magic command
RUN apk add --no-cache curl && \
    cd /tmp && curl -Ls https://github.com/dustinblackman/phantomized/releases/download/${PHANTOMJS_VERSION}/dockerized-phantomjs.tar.gz | tar xz && \
    cp -R lib lib64 / && \
    cp -R usr/lib/x86_64-linux-gnu /usr/lib && \
    cp -R usr/share /usr/share && \
    cp -R etc/fonts /etc && \
    curl -k -Ls https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-${PHANTOMJS_VERSION}-linux-x86_64.tar.bz2 | tar -jxf - && \
    cp phantomjs-${PHANTOMJS_VERSION}-linux-x86_64/bin/phantomjs /usr/local/bin/phantomjs && \
    rm -fR phantomjs-${PHANTOMJS_VERSION}-linux-x86_64 && \
    apk del curl

RUN apk add openssh fzf
RUN set -eux \
    & apk add \
        --no-cache \
        nodejs \
        yarn

RUN apk add libc6-compat gcompat

ENV GO_VERSION=1.21.1

RUN wget https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \ 
  rm -rf /usr/local/go && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz && \ 
  rm go${GO_VERSION}.linux-amd64.tar.gz

ENTRYPOINT ["/bin/zsh"]
