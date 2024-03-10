# Docker Caching
## Objectives
- Minimize build times
    - To improve developer experience
    - To minimize external network requests (cost + security) for getting dependencies
- Minimize runtime application image size
    - To minimize attack surface area (security)
    - To minimize time to download and therefore start containers (time to recovery in cloud environments)
    - To minimize storage costs

## High Level Solution
1. Download the cache locally from external storage
1. Copy the local cache into cache mount using bind mount
1. Perform build
1. Copy the cache mount into local cache using local build output
1. Upload the local cache into external storage

## Commands
### Populate the build cache
```bash
docker compose --progress=plain build --build-arg CACHE_KEY=d="$(date -Iseconds)" write-to-cache
```

### Export the build cache to disk
```bash
docker build --progress=plain --output type=local,dest=output --target=read-from-cache --file dockerfiles/cache_manipulator.Dockerfile .
```

## Notes
- Building the app with `--no-cache` causes changes to the cache mount to not be saved
- Potential external cache storage locations: built-in CI caching mechanisms, S3-compliant services, other Docker images

## References
- https://github.com/moby/buildkit/issues/1512#issuecomment-1319736671
- https://github.com/moby/buildkit/issues/1673#issuecomment-1264502398
- https://docs.docker.com/build/guide/export/#export-binaries
- https://stackoverflow.com/a/37798643