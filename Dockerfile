FROM node:20-alpine AS build

# ENV HTTP_PROXY=http://inetgw2-proxy.corp.bi.go.id:8080
# ENV HTTPS_PROXY=http://inetgw2-proxy.corp.bi.go.id:8080

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ARG APP_VERSION
ARG APP_NAME
ENV APP_VERSION=$APP_VERSION APP_NAME=$APP_NAME
RUN npm run build

# nginx-unprivileged: jalan sebagai non-root, port 8080 (cocok untuk OpenShift)
FROM nginxinc/nginx-unprivileged:stable-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
