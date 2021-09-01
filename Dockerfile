FROM registry.gitlab.com/lyvesaas/registry/sumon:node as build-stage
 
WORKDIR /app
COPY package*.json /app/
RUN yarn install
COPY ./ /app/
RUN apk update
RUN yarn run build

FROM registry.gitlab.com/lyvesaas/registry/orchestrator-nginx:ce0784f2
COPY build/ /usr/share/nginx/html

