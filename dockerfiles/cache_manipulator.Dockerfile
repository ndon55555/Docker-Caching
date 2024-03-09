FROM busybox as base

FROM base as write-to-cache
ARG CACHE_KEY
RUN --mount=type=bind,source=local_cache/,dst=/bind_cache \
    --mount=type=cache,target=/some_cache \
    cp -r /bind_cache/* /some_cache

FROM base as read-from-cache-helper
ARG CACHE_KEY
RUN --mount=type=cache,target=/some_cache \
    mkdir /new_local_cache && cp -r /some_cache/* /new_local_cache

FROM scratch as read-from-cache
ARG CACHE_KEY
COPY --from=read-from-cache-helper /new_local_cache /new_local_cache