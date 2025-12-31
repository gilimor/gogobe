FROM postgis/postgis:15-3.4-alpine

# Install build dependencies
RUN apk add --no-cache git make build-base clang llvm

# Fix for missing clang-15 (symlink whatever clang we have)
RUN if [ ! -f /usr/bin/clang-15 ]; then ln -s /usr/bin/clang /usr/bin/clang-15; fi

# Install pgvector
RUN cd /tmp \
    && git clone --branch v0.7.0 https://github.com/pgvector/pgvector.git \
    && cd pgvector \
    && make \
    && make install \
    && cd .. \
    && rm -rf pgvector

# Cleanup
RUN apk del git make build-base clang llvm
