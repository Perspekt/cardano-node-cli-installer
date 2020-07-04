#!/bin/bash

sudo apt-get update -y

sudo apt-get install build-essential pkg-config libffi-dev libgmp-dev libssl-dev libtinfo-dev libsystemd-dev zlib1g-dev make g++ tmux git jq wget libncursesw5 -y
sudo apt-get install libsodium-dev pkg-config -y
sudo apt-get install libtool -y
sudo apt-get install autoconf -y
sudo apt-get install git -y

mkdir ~/Downloads
cd ~/Downloads

git clone https://github.com/input-output-hk/libsodium

cd libsodium
git checkout 66f017f1
./autogen.sh
./configure
make
sudo make install

export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"



#Install Cabal
cd ~/Downloads
wget https://downloads.haskell.org/~cabal/cabal-install-3.2.0.0/cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
tar -xf cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz
rm cabal-install-3.2.0.0-x86_64-unknown-linux.tar.xz cabal.sig
mkdir -p ~/.local/bin
mv cabal ~/.local/bin/


#Adding ~/.local/bin and ~/.cabal/bin to the PATH
#https://github.com/input-output-hk/cardano-tutorials/blob/master/node-setup/000_install.md
#Add Manually to end of ~/.bashrc
echo "export PATH=\"~/.taco/bin:\$PATH\"" >> ~/.bashrc
echo "export PATH=\"~/.taco/bin:\$PATH\"" >> ~/.bashrc
source ~/.bashrc
cabal update

#Install GHC
cd ~/Downloads
wget https://downloads.haskell.org/~ghc/8.6.5/ghc-8.6.5-x86_64-deb9-linux.tar.xz
tar -xf ghc-8.6.5-x86_64-deb9-linux.tar.xz
rm ghc-8.6.5-x86_64-deb9-linux.tar.xz
cd ghc-8.6.5
./configure
sudo make install


# Build cardano-node cardano-cli
cd ~/Downloads
git clone https://github.com/input-output-hk/cardano-node.git
cd cardano-node
git fetch --all --tags
#'git tag' to list tags
git checkout tags/1.14.2
cabal install cardano-node cardano-cli --installdir="$HOME/.local/bin" --overwrite-policy=always
echo "Cardano Node Version: $(cardano-node version)"
echo "Cardano CLI Version: $(cardano-cli version)"
#If you see version 1.14.2 You are good to go


#cabal build all

#cp -p dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-node-1.14.0/x/cardano-node/build/cardano-node/cardano-node ~/.local/bin/
#cp -p dist-newstyle/build/x86_64-linux/ghc-8.6.5/cardano-cli-1.14.0/x/cardano-cli/build/cardano-cli/cardano-cli ~/.local/bin/
