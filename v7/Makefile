# Makefile for building Vagrant base image "boxes" for vagrant-libvirt
# Copyright (C) 2010-2013+ James Shubin
# Written by James Shubin <james@shubin.ca>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# NOTE: if you change any of the values in this file (such as SIZE or --install
# arguments) make won't notice the change, you'll have to manually clean first.

SHELL = /bin/bash
.PHONY: all docker xz index asc builder convert box local upload clean
.SILENT:

# virt-builder os-version
VERSION =
POSTFIX =
ifeq ($(POSTFIX), )
	FULLNAME = $(VERSION)
else
	FULLNAME = $(VERSION)-$(POSTFIX)
endif
ISO =
# if a slash exists, then assume an absolute path; TODO: split between abs/rel
ifeq (,$(findstring $(ISO), /))
	FULLISO := $(shell echo `pwd`/iso/$(ISO))
	# TODO: add xdg support
	# FIXME: when iso in ~/.cache/ qemu shows a permission denied error...
	#FULLISO := $(shell echo ~/.cache/vagrant-builder/iso/$(ISO))
endif

ifneq ($(ISO), )
	# TODO: use a signed index instead (useful for automated environments?)
	INDEX_PRESENT = $(OUTPUT)/index
	BUILDER_FLAGS = --fingerprint '' --source $(OUTPUT)/index --no-check-signature --no-cache
else
	INDEX_PRESENT =
	BUILDER_FLAGS =
endif

BOX = $(FULLNAME).box
SIZE = 40
ifeq ($(SIZE), )
	SIZE = 40
endif
# the user might want to generate a personal set of base images
OUTPUT := $(shell echo ~/tmp/builder/$(FULLNAME))
SERVER = 'user@host.example.org'
REMOTE_PATH = 'public_html/vagrant'
# list of keys (from keys/ folder) to install
KEYS =
# list of extra repos (from repos/ folder) to install
REPOS =
# list of extra packages to install
PACKAGES =
# list of docker images to pull in
IMAGES =
# list of container output paths
PREFIX = $(OUTPUT)/
SUFFIX = .docker
# $(VARIABLE:OLD_PREFIX%OLD_SUFFIX=NEW_PREFIX%NEW_SUFFIX)
DOCKER = $(IMAGES:%=$(PREFIX)%$(SUFFIX))
# find out which key files actually exist
KEYS_PATTERN = $(KEYS:%=keys/RPM-GPG-KEY-%)
ifeq ($(KEYS_PATTERN), )
	KEYS_PRESENT =
else
	KEYS_PRESENT := $(shell ls $(KEYS_PATTERN) 2> /dev/null)
endif
# build command line args for virt-builder
KEYS_COMMAND = $(KEYS_PRESENT:%=--upload %:/etc/pki/rpm-gpg/)
# find out which repo files actually exist
REPOS_PATTERN = $(REPOS:%=repos/%.repo)
ifeq ($(REPOS_PATTERN), )
	REPOS_PRESENT =
else
	REPOS_PRESENT := $(shell ls $(REPOS_PATTERN) 2> /dev/null)
endif
# build command line args for virt-builder
REPOS_COMMAND = $(REPOS_PRESENT:%=--upload %:/etc/yum.repos.d/)

# needed for subscription-manager virt-builder install...
USERNAME := $(shell source ~/.vagrant-builder/auth.sh && echo "$$USERNAME")
PASSWORD := $(shell source ~/.vagrant-builder/auth.sh && echo "$$PASSWORD")
POOLID =
ifeq ($(POOLID), )
	ATTACH = --auto
else
	# POOLID can be a list of poolid's separated by spaces...
	ATTACH = $(POOLID)
endif
# TODO: alternatively, we could simulate a repo download first, and then copy
# those repos in with the REPOS variable, but that's too complicated for now!
# this is a list of elements (space separated)
RHELREPOS =
ifneq ($(RHELREPOS), )
	# TODO: avoid passing in the password where it can be visible...
	SUBSCRIPTION_COMMAND = --run-command "echo \"USERNAME='$(USERNAME)';PASSWORD='$(PASSWORD)';ATTACH='$(ATTACH)';REPOS='$(RHELREPOS)'\" > /root/subscribe.input.sh" --run files/subscribe.sh
	SUBSCRIPTION_UNREGISTER = --run-command 'if (test "$(USERNAME)" != "" && test "$(PASSWORD)" != ""); then subscription-manager unregister; fi'
else
	SUBSCRIPTION_COMMAND =
	SUBSCRIPTION_UNREGISTER =
endif

# ensure this is run from a script file and not directly :)
ifeq ($(VERSION),)
$(info VERSION not set!)
all:
	echo 'Run this Makefile using a script in ./versions/'
	echo 'Example: ./versions/fedora-21.sh'
	echo 'Note: doing this from this working directory is important!'
	false	# cause make to exit now :)
else
#
#	aliases
#
all: box
docker: $(DOCKER)
builder: $(OUTPUT)/builder.img
convert: $(OUTPUT)/box.img
box: $(OUTPUT)/$(BOX)
xz: $(OUTPUT)/$(VERSION).xz
index: $(OUTPUT)/index
asc: $(OUTPUT)/index.asc
local: $(OUTPUT)/SHA256SUMS.asc
endif

#
#	clean
#
# delete created files
clean:
	@echo Running clean...
	# TODO: technically, the 'true' should check if all the files are rm-ed
	rm $(DOCKER) $(OUTPUT)/{docker.tar,{builder,box}.img,metadata.json,$(BOX),SHA256SUMS{,.asc}} || true

#
#	docker
#
$(DOCKER): %:
	# get name of the container by removing prefix/suffix
	d='$@'; d=$${d#$(PREFIX)}; d=$${d%$(SUFFIX)}; docker pull "$$d" && docker save "$$d" > $@

$(OUTPUT)/docker.tar: $(DOCKER)
	cd $(PREFIX) && tar -cf $(OUTPUT)/docker.tar -C $(OUTPUT) *$(SUFFIX) || ls *$(SUFFIX) || tar -cf $(OUTPUT)/docker.tar --files-from=/dev/null

$(OUTPUT)/$(VERSION).xz: $(FULLISO)
	sudo -v	# auth
	./scripts/virt-install.sh $(VERSION) $(FULLISO) $(OUTPUT)/$(VERSION) || (rm -f $(OUTPUT)/$(VERSION) && false)
	virt-sysprep -a $(OUTPUT)/$(VERSION)
	mv $(OUTPUT)/$(VERSION){,.tmp}
	virt-sparsify $(OUTPUT)/$(VERSION){.tmp,} && rm -f $(OUTPUT)/$(VERSION).tmp
	xz --best --block-size=16777216 $(OUTPUT)/$(VERSION)	# produces .xz

#
#	plain index
#
$(OUTPUT)/index: $(OUTPUT)/$(VERSION).xz
	# TODO: get heredoc to work...
	echo -n > $(OUTPUT)/index
	echo '[$(VERSION)]' >> $(OUTPUT)/index
	echo 'name=$(VERSION)' >> $(OUTPUT)/index
	echo '#osinfo=$(VERSION)' >> $(OUTPUT)/index
	echo 'arch=x86_64' >> $(OUTPUT)/index
	echo 'file='`python -c "import os.path; print(os.path.relpath('$(OUTPUT)/$(VERSION).xz', '.'))"` >> $(OUTPUT)/index
	echo 'checksum[sha512]='`sha512sum $(OUTPUT)/$(VERSION).xz | awk '{print $$1}'` >> $(OUTPUT)/index
	echo 'format=raw' >> $(OUTPUT)/index
	echo '# hardcoded to 6GiB' >> $(OUTPUT)/index
	echo 'size=6442450944' >> $(OUTPUT)/index
	echo 'compressed_size='`stat -c %s $(OUTPUT)/$(VERSION).xz` >> $(OUTPUT)/index
	echo 'expand=/dev/sda3' >> $(OUTPUT)/index
	echo 'notes=Made with vagrant-builder by @purpleidea' >> $(OUTPUT)/index
	#echo 'hidden=true' >> $(OUTPUT)/index

#
#	signed index
#
$(OUTPUT)/index.asc: $(OUTPUT)/index
	gpg --clearsign --armor $(OUTPUT)/index

#
#	virt-builder
#
# build image with virt-builder
# NOTE: some of this system prep is based on the vagrant-libvirt scripts
# TODO: install: ruby ruby-devel make gcc rubygems ?
# FIXME: if virt-builder fails during install, there is no unregister done!
$(OUTPUT)/builder.img: files/* $(OUTPUT)/docker.tar $(REPOS_PRESENT) $(KEYS_PRESENT) $(INDEX_PRESENT)
	@echo Running virt-builder...
	[ -d $(OUTPUT) ] || mkdir -p $(OUTPUT)/	# ensure path is present first!
	virt-builder $(BUILDER_FLAGS) $(VERSION) $(SUBSCRIPTION_COMMAND) $(REPOS_COMMAND) $(KEYS_COMMAND) \
	--output $(OUTPUT)/builder.img \
	--format qcow2 \
	--size $(SIZE)G \
	--install rsync,nfs-utils,sudo,openssh-server,openssh-clients,screen,tar \
	--root-password file:files/password \
	--run-command 'yum erase -y vim-minimal || true' \
	--run-command 'yum install -y puppet || true' \
	--run-command 'yum install -y docker || true' \
	--run-command 'systemctl enable docker || true' \
	--upload $(OUTPUT)/docker.tar:/root/ \
	--run-command 'mkdir /root/docker/ && tar -C /root/docker/ -xf /root/docker.tar && rm /root/docker.tar' \
	--upload files/yum.sh:/root/yum.sh \
	--run-command '/root/yum.sh install $(PACKAGES) && rm /root/yum.sh' \
	--run-command 'yum update -y' \
	--run files/user.sh \
	--run files/ssh.sh \
	--run files/network.sh \
	--run files/cleanup.sh \
	$(SUBSCRIPTION_UNREGISTER) \
	--run-command 'touch /.autorelabel'

	# boot machine once to run the selinux relabelling, see:
	# https://www.redhat.com/archives/libguestfs/2014-January/msg00183.html
	# https://github.com/libguestfs/libguestfs/commit/20a4bfde9628cfeb8bea441cab7dcc94843b34e3
	qemu-system-x86_64 -machine accel=kvm:tcg -cpu host -m 512 -drive file=$(OUTPUT)/builder.img,format=qcow2,if=virtio -no-reboot -serial stdio -nographic || (rm $(OUTPUT)/builder.img; false)
	reset	# TODO: qemu-system-x86_64 borks the terminal :(

#
#	convert
#
# workaround sparse qcow2 images bug
# thread: https://www.redhat.com/archives/libguestfs/2014-January/msg00008.html
$(OUTPUT)/box.img: $(OUTPUT)/builder.img
	@echo Running convert...
	qemu-img convert -O qcow2 $(OUTPUT)/builder.img $(OUTPUT)/box.img

#
#	metadata.json
#
$(OUTPUT)/metadata.json:
	@echo Running templater...
	[ -d $(OUTPUT) ] || mkdir -p $(OUTPUT)/	# ensure path is present first!
	echo '{"provider": "libvirt", "format": "qcow2", "virtual_size": $(SIZE)}' > $(OUTPUT)/metadata.json
	echo '' >> $(OUTPUT)/metadata.json	# newline

#
#	tar
#
# create custom box
# format at: https://github.com/pradels/vagrant-libvirt/tree/master/example_box
$(OUTPUT)/$(BOX): Vagrantfile $(OUTPUT)/metadata.json $(OUTPUT)/box.img
	@echo Running tar...
	tar -cvzf $(OUTPUT)/$(BOX) ./Vagrantfile --directory=$(OUTPUT)/ ./metadata.json ./box.img

#
#	sha256sum
#
$(OUTPUT)/SHA256SUMS: $(OUTPUT)/$(BOX)
	@echo Running sha256sum...
	cd $(OUTPUT) && sha256sum $(BOX) > SHA256SUMS; cd -

#
#	gpg
#
$(OUTPUT)/SHA256SUMS.asc: $(OUTPUT)/SHA256SUMS
	@echo Running gpg...
	# the --yes forces an overwrite of the SHA256SUMS.asc if necessary
	gpg2 --yes --clearsign $(OUTPUT)/SHA256SUMS

#
#	upload
#
# upload to public server
# NOTE: user downloads while file uploads are in progress don't cause problems!
upload: $(OUTPUT)/$(BOX) $(OUTPUT)/SHA256SUMS $(OUTPUT)/SHA256SUMS.asc
	if [ "`cat $(OUTPUT)/SHA256SUMS`" != "`ssh $(SERVER) 'cd $(REMOTE_PATH)/$(FULLNAME)/ && sha256sum $(BOX)'`" ]; then \
		echo Running upload...; \
		scp -p $(OUTPUT)/{$(BOX),SHA256SUMS{,.asc}} $(SERVER):$(REMOTE_PATH)/$(FULLNAME)/; \
	fi
# this method works too, but always hits the server on every make call
#upload:
#ifeq ($(shell cat $(OUTPUT)/SHA256SUMS), $(shell ssh $(SERVER) 'cd $(REMOTE_PATH)/ && sha256sum $(BOX)'))
#	@echo true
#else
#	@echo false
#endif

