# Sample Dockerfile for an application

FROM busybox as base

FROM base as build
RUN --mount=type=bind,source=lock_file,target=lock_file \
    --mount=type=cache,target=/some_cache \
    export VAR="$(date +%Y-%m-%d_%H-%M-%S)"; \
    echo "some data" > "/some_cache/$VAR" \
    && ls -al /some_cache \
    && mkdir /build-artifact \
    && cp "/some_cache/$VAR" "/build-artifact/$VAR"

FROM base as run
COPY --from=build /build-artifact /run-artifact
