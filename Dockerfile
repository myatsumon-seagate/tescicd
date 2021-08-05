FROM node:10 as build-stage
 
WORKDIR /app
COPY package*.json /app/
RUN yarn install
COPY ./ /app/
RUN yarn build


FROM nginx:1.19.0
COPY build/ /usr/share/nginx/html

# FROM nginx:1.17
# COPY build/ /usr/share/nginx/html

