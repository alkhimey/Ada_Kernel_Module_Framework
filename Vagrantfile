# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "debian/stretch64"
	config.vm.synced_folder ".", "/home/vagrant/project"

	config.vm.provision "shell", path: "vm_scripts/setup_vm.sh"
	config.vm.provision "shell", path: "vm_scripts/gprbuild_doinstall.exp"
	config.vm.provision "shell", path: "vm_scripts/gnat_doinstall.exp"
end
