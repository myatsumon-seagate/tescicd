FROM myatsumon/test:latest as build-stage
 
WORKDIR /app
COPY package*.json /app/
RUN yarn install
COPY ./ /app/
RUN apt-get update -y && apt-get install -y ca-certificates
RUN yarn run build

# FROM nginx:1.17
# COPY build/ /usr/share/nginx/html

