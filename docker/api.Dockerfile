FROM composer:2 AS dependencies

WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --no-progress --no-scripts

FROM php:8.5-cli-alpine

RUN apk add --no-cache libpq-dev postgresql-client \
    && docker-php-ext-install pdo_pgsql

WORKDIR /var/www/html
COPY --from=dependencies /app/vendor ./vendor
COPY . .

RUN mkdir -p storage/framework/cache storage/framework/sessions storage/framework/views \
    storage/logs var/covers \
    && chown -R www-data:www-data storage var

EXPOSE 8000
CMD ["sh", "-c", "php artisan migrate --force && php artisan library:ensure-admin && php artisan serve --host=0.0.0.0 --port=8000"]
