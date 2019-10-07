FROM frolvlad/alpine-glibc

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# Install Python and other APK dependencies
RUN apk -v --no-cache --update add \
        python3 \
        libaio \
        libnsl \
        make \
        uwsgi-python3 \
        lsof \
        jq \
        linux-headers \
        postgresql-libs && \
    apk add --no-cache --virtual .build-deps python3-dev gcc musl-dev postgresql-dev

## Install Oracle Client Libraries
COPY ./instantclient_12_1.zip /usr/lib/
RUN unzip /usr/lib/instantclient_12_1.zip -d /usr/lib && \
    rm /usr/lib/instantclient_12_1.zip && \
    ln /usr/lib/libclntsh.so.12.1 /usr/lib/libclntsh.so && \
    ln /usr/lib/libocci.so.12.1 /usr/lib/libocci.so && \
    ln /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

ENV ORACLE_BASE /usr/lib
ENV LD_LIBRARY_PATH /usr/lib
ENV TNS_ADMIN /usr/lib
ENV ORACLE_HOME /usr/lib