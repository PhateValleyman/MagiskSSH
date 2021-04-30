$(eval $(call start_package))
RSYNC?=rsync-3.2.3

PACKAGE:=rsync

ARCHIVE_NAME:=$(RSYNC).tar.gz
DOWNLOAD_URL:=https://download.samba.org/pub/rsync/src/$(ARCHIVE_NAME)
PACKAGE_INSTALLED_FILES:=$(BUILD_DIR)/usr/bin/rsync

CFLAGS+=-I$(BUILD_DIR)/openssl/include
LDFLAGS+=-L$(BUILD_DIR)/openssl/

define pkg-targets
$(BUILD_DIR)/$(PACKAGE)/stamp.configured: $(SRC_DIR)/$(PACKAGE)/stamp.prepared $(call depend-built,openssl)
	mkdir -p $(BUILD_DIR)/$(PACKAGE)
	cd "$(BUILD_DIR)/$(PACKAGE)";                                  \
	$(SRC_DIR)/$(PACKAGE)/$(RSYNC)/configure                       \
	  --build x86_64-pc-linux-gnu --host $(CROSS)                  \
	  --disable-simd --disable-xxhash --disable-zstd --disable-lz4 \
	  CFLAGS="$(CFLAGS)" CPPFLAGS="$(CFLAGS)" LDFLAGS="$(LDFLAGS)"
	$(make-configured-stamp)

$(BUILD_DIR)/usr/bin/rsync: $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/bin/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/rsync" "$(BUILD_DIR)/usr/bin/"
endef

$(eval $(package))
