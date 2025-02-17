FROM python:3.11-slim-bookworm
WORKDIR /opt/maxkb/app
ARG DOCKER_IMAGE_TAG=dev \
    BUILD_AT \
    GITHUB_COMMIT \
    DEPENDENCIES="python3-pip gettext libopenblas-dev curl postgresql-client"

RUN echo "deb http://mirrors.aliyun.com/debian/ bookworm main contrib non-free" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends $DEPENDENCIES && \
    apt-get clean all  && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt/maxkb/app /opt/maxkb/model /opt/maxkb/conf && \
    python3 -m venv /opt/py3 && \
    pip install poetry==1.8.5 --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    poetry config virtualenvs.create false && \
    . /opt/py3/bin/activate

COPY . /opt/maxkb/app

RUN if [ "$(uname -m)" = "x86_64" ]; then sed -i 's/^torch.*/torch = {version = "^2.2.1+cpu", source = "pytorch"}/g' pyproject.toml; fi && \
    poetry install && \
    export MAXKB_CONFIG_TYPE=ENV  && \
    python3 /opt/maxkb/app/apps/manage.py compilemessages

RUN pip3 install --upgrade pip setuptools && \
    pip install pycrawlers && \
    pip install transformers && \
    python3 installer/install_model.py \

ENV MAXKB_VERSION="${DOCKER_IMAGE_TAG} (build at ${BUILD_AT}, commit: ${GITHUB_COMMIT})" \
    MAXKB_CONFIG_TYPE=ENV \
    MAXKB_DB_NAME=maxkb \
    MAXKB_DB_HOST=127.0.0.1 \
    MAXKB_DB_PORT=5432  \
    MAXKB_DB_USER=root \
    MAXKB_DB_PASSWORD=Password123@postgres \
    MAXKB_DB_MAX_OVERFLOW=80 \
    MAXKB_EMBEDDING_MODEL_NAME=/opt/maxkb/model/embedding/shibing624_text2vec-base-chinese \
    MAXKB_EMBEDDING_MODEL_PATH=/opt/maxkb/model/embedding \
    MAXKB_SANDBOX=1 \
    LANG=en_US.UTF-8 \
    PATH=/opt/py3/bin:$PATH \
    POSTGRES_USER=root \
    POSTGRES_PASSWORD=Ab123456 \
    POSTGRES_MAX_CONNECTIONS=1000 \
    PIP_TARGET=/opt/maxkb/app/sandbox/python-packages \
    PYTHONPATH=/opt/maxkb/app/sandbox/python-packages \
    PYTHONUNBUFFERED=1


RUN chmod 755 /opt/maxkb/app/installer/run-maxkb.sh && \
    cp -r /opt/maxkb/model/base/hub /opt/maxkb/model/tokenizer && \
    cp -f /opt/maxkb/app/installer/run-maxkb.sh /usr/bin/run-maxkb.sh && \
    cp -f /opt/maxkb/app/installer/init.sql /docker-entrypoint-initdb.d && \
    curl -L --connect-timeout 120 -m 1800 https://resource.fit2cloud.com/maxkb/ffmpeg/get-ffmpeg-linux | sh && \
    mkdir -p /opt/maxkb/app/sandbox/python-packages &&  \
    find /opt/maxkb/app -mindepth 1 -not -name 'sandbox' -exec chmod 700 {} + && \
    chmod 755 /tmp && \
    useradd --no-create-home --home /opt/maxkb/app/sandbox sandbox -g root && \
    chown -R sandbox:root /opt/maxkb/app/sandbox && \
    chmod g-x /usr/local/bin/* /usr/bin/* /bin/* /usr/sbin/* /sbin/* && \
    chmod g+x /usr/local/bin/python* /bin/sh && \
    cp /opt/maxkb/app/config_example.yml /opt/maxkb/conf/config.yml

EXPOSE 8080

ENTRYPOINT ["bash", "-c"]
CMD [ "/usr/bin/run-maxkb.sh" ]

