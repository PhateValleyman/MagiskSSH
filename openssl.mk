$(eval $(call start_package))
OPENSSL?=openssl-3.0.1

PACKAGE:=openssl

ARCHIVE_NAME:=$(OPENSSL).tar.gz
DOWNLOAD_URL:=https://www.openssl.org/source/$(ARCHIVE_NAME)
LIBCRYPTO_VERSION:=3

PACKAGE_INSTALLED_FILES:=$(BUILD_DIR)/usr/lib/libcrypto.so.$(LIBCRYPTO_VERSION)

define pkg-targets
$(BUILD_DIR)/$(PACKAGE)/stamp.configured: $(SRC_DIR)/$(PACKAGE)/stamp.prepared
	mkdir -p $(BUILD_DIR)/$(PACKAGE)
	cp -R "$(SRC_DIR)/$(PACKAGE)/$(OPENSSL)/." "$(BUILD_DIR)/$(PACKAGE)"
	cd "$(BUILD_DIR)/$(PACKAGE)"; CC=$(CC) LD=$(LD) AS=$(AS) AR=$(AR) ./Configure -DOPENSSL_NO_HEARTBEATS shared "linux-$(OPENSSL_ARCH)" $(CFLAGS) $(LDFLAGS)
	$(make-configured-stamp)

$(BUILD_DIR)/usr/lib/libcrypto.so.$(LIBCRYPTO_VERSION): $(BUILD_DIR)/$(PACKAGE)/stamp.built
	mkdir -p $(BUILD_DIR)/usr/lib/
	cp -u "$(BUILD_DIR)/$(PACKAGE)/libcrypto.so.$(LIBCRYPTO_VERSION)" "$(BUILD_DIR)/usr/lib/"
endef

$(eval $(package))
