FROM frolvlad/alpine-glibc

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# Install Python and other APK dependencies
RUN apk -v --no-cache --update add \
        python3 \
        libaio \
        libnsl \
        make \
        lsof \
        jq \
        linux-headers \
        postgresql-libs && \
    apk add --no-cache --virtual .build-deps python3-dev gcc musl-dev postgresql-dev

## Install Oracle Client Libraries
COPY ./instantclient_12_1.zip /usr/lib/
RUN unzip /usr/lib/instantclient_12_1.zip -d /usr/lib && \
    rm /usr/lib/instantclient_12_1.zip && \
    ln /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/libclntsh.so && \
    ln /usr/lib/instantclient_12_1/libocci.so.12.1 /usr/lib/libocci.so && \
    ln /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1

ENV ORACLE_BASE /usr/lib/instantclient_12_1
ENV LD_LIBRARY_PATH /usr/lib/instantclient_12_1
ENV TNS_ADMIN /usr/lib/instantclient_12_1
ENV ORACLE_HOME /usr/lib/instantclient_12_1