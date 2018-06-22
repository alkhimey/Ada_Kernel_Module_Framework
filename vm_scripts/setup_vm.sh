#!/usr/bin/env bash
sudo apt-get install -y linux-source build-essential
# echo "Extracting kernel source..."
# tar xf /usr/src/linux-source-4.9.tar.xz

# Expect is used for interaction with gnat and gprbuild installers
sudo apt-get install -y expect

# Download an extract AdaCore's gprbuild version
# SHA-1: 88c5040f70398764f6a0d792f8c0191f29c72b58
if [ ! -d gprbuild-gpl-2017-x86_64-linux-bin ]; then
	wget http://mirrors.cdn.adacore.com/art/591c6890c7a447af2deed1be -O gprbuild-gpl-2017-x86_64-linux-bin.tar.gz
	tar -xvzf gprbuild-gpl-2017-x86_64-linux-bin.tar.gz
fi

# Download and extract AdaCore's gnat version
# SHA-1: 9682e2e1f2f232ce03fe21d77b14c37a0de5649bs
if [ ! -d gnat-gpl-2017-x86_64-linux-bin ]; then
	wget http://mirrors.cdn.adacore.com/art/591c6d80c7a447af2deed1d7 -O gnat-gpl-2017-x86_64-linux-bin.tar.gz
	tar -xvzf gnat-gpl-2017-x86_64-linux-bin.tar.gz
fi


if ! grep -q -e gnat  /home/vagrant/.bashrc ; then
	# Let's be optimistic that the installation of gnat will be ok
	# in the gnat_doinstall.exp script and also that it will installed 
	# in the specified here path.
	echo 'PATH="/usr/gnat/bin:$PATH"; export PATH' >> /home/vagrant/.bashrc

fi

# Install bats 
# Bats is a TAP-compliant testing framework for Bash. It provides a simple way to 
# verify that the UNIX programs you write behave as expected.
# We use this framework for testing.
sudo add-apt-repository ppa:duggan/bats
sudo apt-get update
sudo apt-get --yes install bats
