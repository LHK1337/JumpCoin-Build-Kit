FROM alpine:latest

RUN apk update --no-cache ;\
    apk add --no-cache git gcc g++ make wget perl miniupnpc miniupnpc-dev musl-dev linux-headers libexecinfo-dev zlib zlib-dev ;\
    mkdir jumpcoin ;\
    cd jumpcoin ;\
    export basePath=$(pwd) ;\
    wget http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz ;\
    tar -xf boost_1_58_0.tar.gz ;\
    rm boost_1_58_0.tar.gz ;\
    wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz ;\
    tar -xf db-4.8.30.NC.tar.gz ;\
    rm db-4.8.30.NC.tar.gz ;\
    git clone https://github.com/openssl/openssl.git ;\
    git clone https://github.com/LHK1337/jumpcoin.git ;\
    cd openssl ;\
    git checkout OpenSSL_1_0_1-stable ;\
    ./config --prefix="$basePath/out/openssl/build" --openssldir="$basePath/out/openssl/build" ;\
    make -j$(nproc) ;\
    make install ;\
    cd $basePath ;\
    cd db-4.8.30.NC/build_unix ;\
    ../dist/configure --prefix="$basePath/out/db-4.8.30.NC/build_unix" --enable-cxx --enable-shared ;\
    sed -i 's/__atomic_compare_exchange/__atomic_compare_exchange_db/g' ../dbinc/atomic.h ;\
    make -j$(nproc) ;\
    make install ;\
    cd $basePath ;\
    cd boost_1_58_0 ;\
    ./bootstrap.sh --prefix=$basePath/out/boost/build ;\
    ./b2 install --prefix=$basePath/out/boost/build ;\
    cd $basePath ;\
    cd jumpcoin/src/leveldb ;\
    chmod +x ./build_detect_platform ;\
    make -j$(nproc) ;\
    make libleveldb.a ;\
    make libleveldb.so ;\
    make libmemenv.a ;\
    make libmemenv.so ;\
    cd .. ;\
    export BOOST_INCLUDE_PATH=$basePath/out/boost/build/include ;\
    export BDB_INCLUDE_PATH=$basePath/out/db-4.8.30.NC/build_unix/include ;\
    export OPENSSL_INCLUDE_PATH=$basePath/out/openssl/build/include ;\
    export BOOST_LIB_PATH=$basePath/out/boost/build/lib ;\
    export BDB_LIB_PATH=$basePath/out/db-4.8.30.NC/build_unix/lib ;\
    export OPENSSL_LIB_PATH=$basePath/out/openssl/build/lib ;\
    make -f makefile.unix -j$(nproc) USE_UPNP=- ;\
    strip jumpcoind ;\
    mv jumpcoind $basePath ;\
    cd $basePath ;\
    rm -rf SagaCoin boost_1_58_0 db-4.8.30.NC jumpcoin openssl ;\
    mkdir data ;\
    echo "rpcuser=jumpcoinrpc" >> ./data/jumpcoin.conf ;\
    echo "rpcpassword=$(dd if=/dev/random bs=1 count=64 status=none | sha256sum | awk '{print $1}')" >> ./data/jumpcoin.conf ;\
    echo "addnode=173.249.46.190" >> ./data/jumpcoin.conf ;\
    echo "addnode=62.77.152.66" >> ./data/jumpcoin.conf ;\
    echo "addnode=84.58.165.176" >> ./data/jumpcoin.conf ;\
    echo "addnode=45.63.117.50" >> ./data/jumpcoin.conf ;\
    echo "addnode=37.187.140.168" >> ./data/jumpcoin.conf ;\
    echo "addnode=185.141.61.132" >> ./data/jumpcoin.conf ;\
    echo "addnode=194.118.122.254" >> ./data/jumpcoin.conf ;\
    echo "addnode=90.146.173.245" >> ./data/jumpcoin.conf ;\
    echo "addnode=83.78.77.61" >> ./data/jumpcoin.conf ;\
    echo "addnode=87.171.201.148" >> ./data/jumpcoin.conf ;\
    echo "addnode=176.199.48.78" >> ./data/jumpcoin.conf ;\
    echo "addnode=210.211.124.189" >> ./data/jumpcoin.conf ;\
    echo "addnode=173.212.202.104" >> ./data/jumpcoin.conf ;\
    echo "addnode=79.237.45.242" >> ./data/jumpcoin.conf ;\
    echo "addnode=178.4.90.201" >> ./data/jumpcoin.conf ;\
    echo "addnode=118.184.105.17" >> ./data/jumpcoin.conf ;\
    echo "addnode=80.252.107.196" >> ./data/jumpcoin.conf ;\
    echo "addnode=194.182.83.248" >> ./data/jumpcoin.conf ;\
    echo "addnode=81.169.134.112" >> ./data/jumpcoin.conf ;\
    echo "addnode=185.216.214.17" >> ./data/jumpcoin.conf ;\
    echo "---[ jumpcoin.conf ]---" ;\
    cat ./data/jumpcoin.conf ;\
    echo "cd $(pwd)" >> runJumpcoind.sh ;\
    echo "export LD_LIBRARY_PATH=$basePath/out/boost/build/lib:$basePath/out/db-4.8.30.NC/build_unix/lib:$basePath/out/openssl/build/lib" >> runJumpcoind.sh ;\
    echo "./jumpcoind --datadir=$(pwd)/data -printtoconsole" >> runJumpcoind.sh ;\
    chmod +x runJumpcoind.sh

VOLUME /jumpcoin
EXPOSE 31240/tcp 31242/tcp
ENTRYPOINT /jumpcoin/runJumpcoind.sh
