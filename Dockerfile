FROM node:18-alpine3.17 AS builder

WORKDIR /app
COPY package.json package-lock.json ./

RUN npm install --ignore-scripts

COPY public/ ./public/
COPY src/ ./src/
COPY vite.config.js ./
COPY index.html ./

RUN npm run build

FROM nginx:1.22.1-alpine

COPY --from=builder /app/dist /usr/share/nginx/html
COPY front-nginx.conf /etc/nginx/conf.d/default.conf

RUN chown -R nginx:nginx /usr/share/nginx/html

USER nginx

EXPOSE 3000

CMD ["nginx", "-g", "daemon off;"]
