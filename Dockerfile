# FROM registry.gitlab.com/lyvesaas/registry/sumon:node as build-stage
 
# WORKDIR /app
# COPY package*.json /app/
# RUN yarn add –offline
# COPY ./ /app/
# RUN apk update
# RUN yarn run build

# FROM registry.gitlab.com/lyvesaas/registry/secure-nginx:4ffd799b
# COPY build/ /usr/share/nginx/html

# FROM myatsumon/test:latest as build-stage
 
# WORKDIR /app
# COPY package*.json /app/
# RUN yarn install
# COPY ./ /app/
# RUN apk update
# RUN yarn run build

# FROM nginx:1.17
# COPY build/ /usr/share/nginx/html


FROM registry.gitlab.com/lyvesaas/registry/sumon:node

# Yarn is available by default in node docker images now, no need to install

# set yarnMode to "--prod" to install only production modules
#   from docker-compose you can set build.args.yarnMode: --prod
ARG yarnMode

ENV HOME=/home/app
WORKDIR $HOME

# Using yarn's offline cache avoids any need to fetch modules remotely.
# In the case of this docker image it reduces build time from 34 seconds to 30 seconds.
# Whether or not those benefits warrant it is up to you.
# The “Offline Mirror” can be shared between build servers or development machines in
# any way that is convenient: a Dropbox folder, stored in source control or on a network
# drive. At Facebook the offline mirror lives inside of our big Mercurial “monorepo”.

# copy directory of module tarballs
COPY yarn-offline-mirror $HOME/yarn-offline-mirror

# .yarnrc sets the location of the offline mirror
#   https://yarnpkg.com/blog/2016/11/24/offline-mirror/
#   $ yarn config set yarn-offline-mirror ./yarn-offline-mirror
#   $ mv ~/.yarnrc ./
#   $ rm -rf node_modules/ yarn.lock
#   $ yarn install
COPY ["package.json", "yarn.lock", ".yarnrc", "$HOME/"]

# In package.json, rename `prepublish` script to `prepublishOnly` to
# prevent it being run by install.
#   https://github.com/yarnpkg/yarn/pull/1499
#   https://github.com/yarnpkg/yarn/issues/1323
#   https://github.com/yarnpkg/yarn/issues/684

# install modules
#   offline: trigger an error if any required dependencies are not available in local cache
#   frozen-lockfile: don't generate a lockfile and fail if an update is needed
#   link-duplicates: create hardlinks to the repeated modules in node_modules
RUN yarn $yarnMode --offline --frozen-lockfile --link-duplicates

COPY src $HOME/src
RUN yarn run compile

FROM FROM registry.gitlab.com/lyvesaas/registry/secure-nginx:beb87766
COPY build/ /usr/share/nginx/html

ENV NODE_ENV development
EXPOSE 8008


