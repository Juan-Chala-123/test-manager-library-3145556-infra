FROM php:8.5-cli-alpine

RUN apk add --no-cache curl-dev \
    && docker-php-ext-install curl

WORKDIR /tool
COPY . .
ENTRYPOINT ["php", "seed.php"]
