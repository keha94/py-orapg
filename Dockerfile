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
WORKDIR /usr/lib
COPY ./build/instantclient_12_1.zip ./
RUN unzip instantclient_12_1.zip && \
    rm instantclient_12_1.zip && \
    ln /usr/lib/instantclient_12_1/libclntsh.so.12.1 /usr/lib/libclntsh.so && \
    ln /usr/lib/instantclient_12_1/libocci.so.12.1 /usr/lib/libocci.so && \
    ln /usr/lib/instantclient_12_1/libociei.so /usr/lib/libociei.so && \
    ln /usr/lib/instantclient_12_1/libnnz12.so /usr/lib/libnnz12.so && \
    ln /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1 && \
    ## Below should not really need symlink...
    ln /usr/lib/instantclient_12_1/libmql1.so /usr/lib/libmql1.so && \
    ln /usr/lib/instantclient_12_1/libipc1.so /usr/lib/libipc1.so && \
    ln /usr/lib/instantclient_12_1/libons.so /usr/lib/libons.so && \
    ln /usr/lib/instantclient_12_1/libclntshcore.so.12.1 /usr/lib/libclntshcore.so.12.1

ENV ORACLE_BASE /usr/lib/instantclient_12_1
ENV LD_LIBRARY_PATH /usr/lib/instantclient_12_1
ENV TNS_ADMIN /usr/lib/instantclient_12_1
ENV ORACLE_HOME /usr/lib/instantclient_12_1