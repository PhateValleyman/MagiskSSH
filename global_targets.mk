ifneq ($(IS_ARCHIVE_DIR_TARGET_CREATED),true)
IS_ARCHIVE_DIR_TARGET_CREATED:=true
$(ARCHIVE_DIR)/stamp.created:
	mkdir -p "$(ARCHIVE_DIR)"
	touch "$(ARCHIVE_DIR)/stamp.created"
endif