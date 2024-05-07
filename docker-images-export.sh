#!/bin/bash

# Function to pull and save images into a .tar.gz file
pull_and_save() {
  local -n images=$1  # Reference to array
  local file_name=$2  # Output file name

  for image in "${images[@]}"; do
    echo "Pulling $image..."
    docker pull "$image"
  done
  
  echo "Saving images to $file_name.tar..."
  docker save "${images[@]}" -o "$file_name.tar"

  echo "Compressing $file_name.tar to $file_name.tar.gz..."
  gzip "$file_name.tar"

  echo "$file_name.tar.gz ready."
}

# Arrays of images by type
ubuntu_images=("ubuntu:noble" "ubuntu:24.04" "ubuntu:latest" "ubuntu:rolling" "ubuntu:jammy" "ubuntu:22.04" "ubuntu:focal" "ubuntu:20.04" "ubuntu:bionic" "ubuntu:18.04")
debian_images=("debian:bookworm" "debian:bullseye" "debian:buster")
alpine_images=("alpine:3.19.1" "alpine:3.18.6")
node_images=(
  node:22 node:22-bookworm node:22.1 node:22.1-bookworm node:22.1.0 node:22.1.0-bookworm node:bookworm node:current node:current-bookworm node:latest node:22-alpine node:22-alpine3.19 node:22.1-alpine node:22.1-alpine3.19 node:22.1.0-alpine node:22.1.0-alpine3.19 node:alpine node:alpine3.19 node:current-alpine node:current-alpine3.19 node:22-slim node:22-bookworm-slim node:22.1-bookworm-slim node:22.1-slim node:22.1.0-bookworm-slim node:22.1.0-slim node:bookworm-slim node:current-bookworm-slim node:current-slim node:slim
  node:20 node:20-bookworm node:20.12 node:20.12-bookworm node:20.12.2 node:20.12.2-bookworm node:iron node:iron-bookworm node:lts node:lts-bookworm node:lts-iron node:20-alpine node:20-alpine3.19 node:20.12-alpine node:20.12-alpine3.19 node:20.12.2-alpine node:20.12.2-alpine3.19 node:iron-alpine node:iron-alpine3.19 node:lts-alpine node:lts-alpine3.19 node:20-slim node:20-bookworm-slim node:20.12-bookworm-slim node:20.12-slim node:20.12.2-bookworm-slim node:20.12.2-slim node:iron-bookworm-slim node:iron-slim node:lts-bookworm-slim node:lts-slim
  node:18 node:18-bookworm node:18.20 node:18.20-bookworm node:18.20.2 node:18.20.2-bookworm node:hydrogen node:hydrogen-bookworm node:18-alpine node:18-alpine3.19 node:18.20-alpine node:18.20-alpine3.19 node:18.20.2-alpine node:18.20.2-alpine3.19 node:hydrogen-alpine node:hydrogen-alpine3.19 node:18-slim node:18-bookworm-slim node:18.20-bookworm-slim node:18.20-slim node:18.20.2-bookworm-slim node:18.20.2-slim node:hydrogen-bookworm-slim node:hydrogen-slim
  node:16 node:16-bookworm node:16.20 node:16.20-bookworm node:16.20.2 node:16.20.2-bookworm node:gallium node:gallium-bookworm node:16-alpine node:16-alpine3.18 node:16.20-alpine node:16.20-alpine3.18 node:16.20.2-alpine node:16.20.2-alpine3.18 node:gallium-alpine node:gallium-alpine3.18 node:16-slim node:16-bookworm-slim node:16.20-bookworm-slim node:16.20-slim node:16.20.2-bookworm-slim node:16.20.2-slim node:gallium-bookworm-slim node:gallium-slim
)
pm2_images=(
  "pm2/pm2:22" "pm2/pm2:22-alpine" "pm2/pm2:latest-alpine" "pm2/pm2:latest"
  "pm2/pm2:22-bookworm" "pm2/pm2:latest-bookworm"
  "pm2/pm2:22-slim" "pm2/pm2:latest-slim"
  "pm2/pm2:20" "pm2/pm2:20-alpine"
  "pm2/pm2:20-bookworm"
  "pm2/pm2:20-slim"
  "pm2/pm2:18" "pm2/pm2:18-alpine"
  "pm2/pm2:18-bookworm"
  "pm2/pm2:18-slim"
  "pm2/pm2:16" "pm2/pm2:16-alpine"
  "pm2/pm2:16-bookworm"
  "pm2/pm2:16-slim"
)
python_images=("python:3.12.3" "python:3.12.3-slim" "python:3.12.3-alpine" "python:3.11.9" "python:3.11.9-slim" "python:3.11.9-alpine")
postgres_images=("postgres:16.2" "postgres:15.6" "postgres:14.11" "postgres:13.14" "postgres:12.18")
mongo_images=("mongo:7" "mongo:6" "mongo:5" "mongo:4")
mongo_express_images=("mongo-express:1")
redis_images=("redis:7" "redis:6")
mysql_images=("mysql:8" "mysql:8.0" "mysql:8.0-debian")
mariadb_images=("mariadb:11" "mariadb:10")
phpmyadmin_images=("phpmyadmin:5" "phpmyadmin:5-fpm" "phpmyadmin:5-fpm-alpine")
openjdk_images=("openjdk:23" "openjdk:23-bookworm" "openjdk:23-slim")
ruby_images=("ruby:3" "ruby:3-slim" "ruby:3-alpine")
golang_images=("golang:1.22" "golang:1.21")
nginx_images=("nginx:1.25" "nginx:1.25-perl" "nginx:1.25-otel" "nginx:1.25-alpine")
unit_images=("unit:go1.22" "unit:go1.21" "unit:node20" "unit:python3.12" "unit:python3.11" "unit:minimal")
apache_images=("httpd:2" "httpd:2-alpine")
docker_images=("docker:cli" "docker:dind" "docker:dind-rootless")
rabbitmq_images=("rabbitmq:3.13" "rabbitmq:3.13-management" "rabbitmq:3.13-alpine" "rabbitmq:3.13-management-alpine" "rabbitmq:3.12" "rabbitmq:3.12-management" "rabbitmq:3.12-alpine" "rabbitmq:3.12-management-alpine")
haproxy_images=("haproxy:2.9" "haproxy:2.9-alpine")
traefik_images=("traefik:v3.0.0" "traefik:3.0.0" "traefik:v3.0" "traefik:3.0" "traefik:beaufort" "traefik:latest" "traefik:v2.11.2" "traefik:2.11.2" "traefik:v2.11" "traefik:2.11" "traefik:mimolette")
ghost_images=("ghost:5" "ghost:5-alpine")
gcc_images=("gcc:13" "gcc:12" "gcc:11" "gcc:10" "gcc:9")
gitlab_images=(
  "gitlab/gitlab-ce:16.11.1-ce.0"
  "gitlab/gitlab-ce:latest"
  "gitlab/gitlab-runner:alpine3.18-bleeding"
  "gitlab/gitlab-runner:alpine-bleeding"
  "gitlab/gitlab-runner:bleeding"
  "gitlab/gitlab-runner:ubuntu-bleeding"
  "gitlab/gitlab-runner:alpine3.18-v16.11.1"
  "gitlab/gitlab-runner:alpine-v16.11.1"
  "gitlab/gitlab-runner:alpine"
  "gitlab/gitlab-runner:alpine3.18"
  "gitlab/gitlab-runner:v16.11.1"
  "gitlab/gitlab-runner:ubuntu-v16.11.1"
  "gitlab/gitlab-runner:latest"
  "gitlab/gitlab-runner:ubuntu"
  "gitlab/gitlab-runner-helper:x86_64-bleeding"
  "gitlab/gitlab-runner-helper:ubuntu-x86_64-bleeding"
  "gitlab/gitlab-runner-helper:alpine3.18-x86_64-bleeding"
  "gitlab/gitlab-runner-helper:x86_64-v16.11.1"
  "gitlab/gitlab-runner-helper:ubuntu-x86_64-v16.11.1"
  "gitlab/gitlab-runner-helper:alpine3.18-x86_64-v16.11.1"
  "gitlab/gitlab-ce-qa:16.11.1"
  "gitlab/gitlab-ce-qa:latest"
  "gitlab/glab:latest"
  "gitlab/glab:v1.40.0"
  "gitlab/glab:v1.40.0-amd64"
  "gitlab/gitlab-performance-tool:latest"
  "gitlab/gitlab-performance-tool:2.14.0"
  "gitlab/gitlab-agent-ci-image:latest"
)
directus_images=("directus/directus:10.10" "directus/directus:latest" "directus/directus:10" "directus/directus:10.10.7")


# Call function for each type
pull_and_save ubuntu_images "ubuntu-images"
pull_and_save debian_images "debian-images"
pull_and_save alpine_images "alpine-images"
pull_and_save node_images "node-images"
pull_and_save pm2_images "pm2-images"
pull_and_save python_images "python-images"
pull_and_save postgres_images "postgres-images"
pull_and_save mongo_images "mongo-images"
pull_and_save mongo_express_images "mongo-express-images"
pull_and_save redis_images "redis-images"
pull_and_save mysql_images "mysql-images"
pull_and_save mariadb_images "mariadb-images"
pull_and_save phpmyadmin_images "phpmyadmin-images"
pull_and_save openjdk_images "openjdk-images"
pull_and_save ruby_images "ruby-images"
pull_and_save golang_images "golang-images"
pull_and_save nginx_images "nginx-images"
pull_and_save unit_images "unit-images"
pull_and_save apache_images "apache-images"
pull_and_save docker_images "docker-in-docker-images"
pull_and_save rabbitmq_images "rabbitmq-images"
pull_and_save haproxy_images "haproxy-images"
pull_and_save traefik_images "traefik-images"
pull_and_save ghost_images "ghost-images"
pull_and_save gcc_images "gcc-images"
pull_and_save gitlab_images "gitlab-images"
pull_and_save directus_images "directus-images"

echo "All images exported."
