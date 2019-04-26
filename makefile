LAST_BIN:=$(shell ls -Art *.bin | tail -n 1)
BIN:=$(LAST_BIN)
DEVICE?="photon"
VERSION?="1.0.1"
TARGET?=

### PROJECT SPECIFIC RULES ###

# cloud debug
cloud_debug: BIN=cloud_debug.bin 
cloud_debug: cloud_debug.bin flash

# blink
blink: BIN=blink.bin 
blink: blink.bin flash

### GENERAL RULES ###

# general compile - usually useful but not in the case of this project
compile: 
	@echo "ERROR: general compile not supported for this particular project."
#@echo "INFO: compiling everything in the cloud for $(DEVICE) $(VERSION)...."
#@particle compile $(DEVICE) --target $(VERSION)

# compile single file in the cloud (this is the typical use case for this project)
%.bin: src/%.cpp
	@echo "\nINFO: compiling $< in the cloud for $(DEVICE) $(VERSION)...."
	@particle compile $(DEVICE) $< --target $(VERSION) --saveTo $@

# flash (via cloud if TARGET device is set, via usb if none provided)
# by the default the latest bin, unless BIN otherwise specified
flash:
ifeq ($(TARGET),)
	$(MAKE) usb_flash
else
	$(MAKE) cloud_flash
endif

# flash via the cloud
cloud_flash:
ifeq ($(TARGET),)
	@echo "ERROR: no TARGET provided, specify the name of the device to flash."
else
	@echo "\nINFO: flashing $(BIN) to $(TARGET) via the cloud..."
	@particle flash $(TARGET) $(BIN)
endif

# usb flash
usb_flash:
	@echo "INFO: flashing $(BIN) over USB (requires device in DFU mode)..."
	@particle flash --usb  $(BIN)

# cleaning
clean:
	@echo "INFO: removing all .bin files..."
	@rm ./*.bin
