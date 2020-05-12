FROM ubuntu:bionic as build-env
WORKDIR /dynamic
RUN apt-get -qq update
RUN apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev
RUN apt-get install -y libcrypto++-dev libevent-dev software-properties-common git curl wget
RUN wget 'http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz'
RUN tar -xzvf db-4.8.30.NC.tar.gz
RUN cd db-4.8.30.NC/build_unix
RUN db-4.8.30.NC/dist/configure --prefix=/usr/local --enable-cxx
RUN make -j$(nproc)
RUN make install
RUN cd ..//..
RUN git clone https://github.com/duality-solutions/dynamic.git
RUN ./dynamic/autogen.sh 
RUN ./dynamic/configure --without-gui --disable-tests --disable-bench
RUN cd dynamic && git submodule update --init --recursive
RUN make -j$(nproc)
RUN make install-strip
RUN strip /dynamic/src/dynamicd
RUN strip /dynamic/src/dynamic-cli 
FROM ubuntu:bionic
WORKDIR /dynamic
COPY --from=build-env /dynamic/build/apps/dynamic/installed/x86_64-unknown-linux-gnu/bin/dynamicd /dynamic/build/apps/dynamic/installed/x86_64-unknown-linux-gnu/bin/dynamic-cli ./dist/
ENV PATH="/dynamic/dist:${PATH}"
COPY ./docker/* ./
CMD ["/bin/bash","-c","./entry.sh"]