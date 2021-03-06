echo "Provisioning virtual machine..."

apt-get -qq update > /dev/null
apt-get install -y build-essential libtool autotools-dev autoconf pkg-config libssl-dev libboost-all-dev libcrypto++-dev libevent-dev libzmq3-dev software-properties-common > /dev/null
apt-add-repository -y ppa:bitcoin/bitcoin > /dev/null
apt-get update -y && sudo apt-get install -y libdb4.8-dev libdb4.8++-dev > /dev/null
