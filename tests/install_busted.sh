cd ~
wget https://luarocks.org/releases/luarocks-2.4.4.tar.gz
tar zxpf luarocks-2.4.4.tar.gz
cd luarocks-2.4.4
./configure --lua-version=5.1
sudo make bootstrap
sudo rm -rf ~/luarocks-2.4.4.tar.gz
sudo luarocks install busted