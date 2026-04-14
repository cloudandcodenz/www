# Stage 1: Build with Hugo
FROM hugomods/hugo:latest AS builder

WORKDIR /site
COPY . .
RUN hugo --minify

# Stage 2: Serve with nginx
FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder /site/public /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD wget -qO- http://localhost:8080/ || exit 1
