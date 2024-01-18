# build stage
FROM node:18-alpine3.18 as build

WORKDIR /app

COPY package.json .

RUN npm config set registry https://registry.npmmirror.com

RUN npm install -g pnpm

RUN pnpm install -r

COPY . .

RUN pnpm run build

# deploy-stage
FROM nginx:stable-alpine as deploy

COPY --from=build /app/dist /usr/share/nginx/html

COPY nginx.conf  /etc/nginx/conf.d/default.conf 

EXPOSE 80

ENTRYPOINT ["sh", "-c","nginx -g 'daemon off;'"]



