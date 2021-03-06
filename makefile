LAST_BIN:=$(shell ls -Art *.bin | tail -n 1)
BIN:=$(LAST_BIN)
PLATFORM?=photon
VERSION?=2.0.0-rc.4
device?=

### PROJECT SPECIFIC RULES ###

# cloud debug
cloud_debug: BIN=cloud_debug-$(VERSION).bin 
cloud_debug: cloud_debug-$(VERSION).bin flash monitor

# blink
blink: BIN=blink-$(VERSION).bin 
blink: blink-$(VERSION).bin flash

# i2c scanner
i2c_scanner: BIN=i2c_scanner-$(VERSION).bin 
i2c_scanner: i2c_scanner-$(VERSION).bin flash monitor

# lcd test
lcd_test: BIN=lcd_test-$(VERSION).bin
lcd_test: lcd_test-$(VERSION).bin flash monitor

### GENERAL RULES ###

list:
	@echo "\nINFO: querying list of available devices..."
	@particle list

monitor:
	@echo "\nINFO: connecting to serial monitor..."
	@trap "exit" INT; while :; do particle serial monitor; done

doctor:
	@particle usb dfu
	@echo "\nINFO: starting particle doctor..."
	@echo "WARNING: do NOT reset keys if device is not claimed by you - it may become impossible to access"
	@particle device doctor

identify:
	@echo "\nINFO: checking identify of device connected to serial (requires device in listening mode = blue)..."
	@particle serial identify

rainbow_on:
ifeq ($(device),)
	@echo "ERROR: no device provided, specify the name to make rainbows via make nyan device=???."
else
	@echo "\nINFO: starting rainbow on $(device)..."
	@particle nyan $(device) on
endif

rainbow_off:
ifeq ($(device),)
	@echo "ERROR: no device provided, specify the name to make rainbows via make nyan device=???."
else
	@echo "\nINFO: stopping rainbow on $(device)..."
	@particle nyan $(device) off
endif

# general compile - usually useful but not in the case of this project
compile: 
	@echo "ERROR: general compile not supported for this particular project."
#@echo "INFO: compiling everything in the cloud for $(PLATFORM) $(VERSION)...."
#@particle compile $(PLATFORM) --target $(VERSION)

# compile single file in the cloud (this is the typical use case for this project)
%-$(VERSION).bin: src/%.cpp
	@echo "\nINFO: compiling $< in the cloud for $(PLATFORM) $(VERSION)...."
	@particle compile $(PLATFORM) $< project.properties --target $(VERSION) --saveTo $@

# flash (via cloud if device is set, via usb if none provided)
# by the default the latest bin, unless BIN otherwise specified
flash:
ifeq ($(device),)
	@$(MAKE) usb_flash BIN=$(BIN)
else
	@$(MAKE) cloud_flash BIN=$(BIN)
endif

# flash via the cloud
cloud_flash:
ifeq ($(device),)
	@echo "ERROR: no device provided, specify the name to flash via make ... device=???."
else
	@echo "\nINFO: flashing $(BIN) to $(device) via the cloud..."
	@particle flash $(device) $(BIN)
endif

# usb flash
usb_flash:
	@echo "INFO: putting device into DFU mode"
	@particle usb dfu
	@echo "INFO: flashing $(BIN) over USB (requires device in DFU mode = yellow blinking)..."
	@particle flash --usb  $(BIN)

# cleaning
clean:
	@echo "INFO: removing all .bin files..."
	@rm -f ./*.bin
