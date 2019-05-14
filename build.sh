sudo apt-get update
sudo apt-get install gcc make git wget curl qt4-dev-tools libqt4-dev libcxxtools-dev -y

mkdir jumpcoin_builKit
cd jumpcoin_builKit

export basePath=$(pwd)

wget http://sourceforge.net/projects/boost/files/boost/1.58.0/boost_1_58_0.tar.gz
wget http://download.oracle.com/berkeley-db/db-4.8.30.NC.tar.gz

tar -xf boost_1_58_0.tar.gz
tar -xf db-4.8.30.NC.tar.gz

git clone https://github.com/openssl/openssl.git
git clone https://github.com/Jumperbillijumper/jumpcoin.git
git clone https://github.com/sagacrypto/SagaCoin.git

mv jumpcoin/src/leveldb jumpcoin/src/leveldb.OLD
cp SagaCoin/src/leveldb jumpcoin/src/leveldb -r

cd openssl

git checkout OpenSSL_1_0_1-stable

./config --prefix="$basePath/openssl/build" --openssldir=openssl
make
make install

cd ..

cd db-4.8.30.NC/build_unix

../dist/configure --prefix="$basePath/db-4.8.30.NC/build_unix" --enable-cxx --enable-shared
make
make install

cd ..
cd ..

cd boost_1_58_0

./bootstrap.sh --prefix=build
./b2 install --prefix=build

cd ..

rm boost_1_58_0/build/include/boost/asio/ssl/impl/context.ipp
curl https://raw.githubusercontent.com/LHK1337/JumpCoin-Build-Kit/master/context.ipp > boost_1_58_0/build/include/boost/asio/ssl/impl/context.ipp

rm jumpcoin/src/makefile.unix
curl https://raw.githubusercontent.com/LHK1337/JumpCoin-Build-Kit/master/makefile.unix > jumpcoin/src/makefile.unix

cd jumpcoin/src/leveldb
chmod +x ./build_detect_platform

make
make libleveldb.a
make libmemenv.a

cd ..

export BOOST_INCLUDE_PATH=$basePath/boost_1_58_0/build/include
export BDB_INCLUDE_PATH=$basePath/db-4.8.30.NC/build_unix/include
export OPENSSL_INCLUDE_PATH=$basePath/openssl/build/include
export BOOST_LIB_PATH=$basePath/boost_1_58_0/build/lib
export BDB_LIB_PATH=$basePath/db-4.8.30.NC/build_unix/lib
export OPENSSL_LIB_PATH=$basePath/openssl/build/lib

make -f makefile.unix
strip jumpcoind

cd ..

qmake INCLUDEPATH+="$OPENSSL_INCLUDE_PATH $BDB_INCLUDE_PATH $BOOST_INCLUDE_PATH" LIBS+="-ldl  -L$OPENSSL_LIB_PATH  -L$BDB_LIB_PATH  -L$BOOST_LIB_PATH  -lleveldb"  USE_UPNP=-
make

cd ..

echo ###########################################################
echo "Don't forget to add $BDB_LIB_PATH to your LD_LIBRARY_PATH"
echo ###########################################################
