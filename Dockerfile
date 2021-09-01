FROM registry.gitlab.com/lyvesaas/registry/sumon:node as build-stage
 
WORKDIR /app
COPY package*.json /app/
RUN yarn install –offline
COPY ./ /app/
RUN apk update
RUN yarn run build

# FROM registry.gitlab.com/lyvesaas/registry/secure-nginx:4ffd799b
# COPY build/ /usr/share/nginx/html

