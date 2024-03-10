# Dockerfile for setting up or exporting a Docker cache mont
FROM alpine:latest as rsync
RUN apk add --no-cache rsync

FROM rsync as write-to-cache
ARG CACHE_KEY
RUN --mount=type=bind,source=local_cache/,dst=/bind_cache \
    --mount=type=cache,target=/some_cache \
    rsync --archive --delete --verbose --human-readable /bind_cache/ /some_cache

FROM rsync as read-from-cache-helper
ARG CACHE_KEY
RUN --mount=type=cache,target=/some_cache \
    mkdir /new_local_cache \
    && rsync --archive --delete --verbose --human-readable /some_cache/ /new_local_cache

FROM scratch as read-from-cache
ARG CACHE_KEY
COPY --from=read-from-cache-helper /new_local_cache /new_local_cache