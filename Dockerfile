FROM node:10 as build-stage
 
WORKDIR /app
COPY package*.json /app/
RUN yarn install
COPY ./ /app/
RUN yarn run build

# FROM nginx:1.17
# COPY build/ /usr/share/nginx/html

