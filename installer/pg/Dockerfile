FROM postgres:15.8-bullseye

ARG DEPENDENCIES="                    \
        libexpat1-dev                 \
        libffi-dev                    \
        curl                          \
        ca-certificates               \
        vim                           \
        gettext                       \
        postgresql-15-pgvector"

RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends $DEPENDENCIES && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/*

ENV POSTGRES_USER=root \
    POSTGRES_PASSWORD=Password123@postgres \
    POSTGRES_DB=app \
    POSTGRES_MAX_CONNECTIONS=1000

EXPOSE 5432

VOLUME ["/var/lib/postgresql/data"]

CMD ["postgres"]
