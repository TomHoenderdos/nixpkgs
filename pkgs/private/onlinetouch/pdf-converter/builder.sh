source $stdenv/setup

mkdir build
cd build
cp -R $src/* .
chmod -R a+w .

./configure --prefix=$out
make
make install
