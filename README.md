# labware_debug

This is a repo for debugging particle photons. It contains several useful programs that can be flashed via USB using the following `make` targets (specify the `device` variable in the `makefile` to flash via cloud instead of USB). 

- `make blink`: flashes a simple blink program (pin 7 blue LED blinking)
- `make cloud_debug`: flashes a program to debug the cloud connectivity and starts the serial monitor to start reporting
- `make i2c_scanner`: flashes a program to find i2c peripherals and starts the serial monitor to start scanning
- `make lcd_test` : flashes a program to test for connected lcd and starts the serial monitor to provide LCD info

Additionally, these `make` targets are also available for convenience:

- `make monitor`: start a serial monitor that restarts when disconnected (exit with cmd+C)
- `make list`: list all available photons and their status
- `make doctor`: flash the paraticle doctor program to revive a device with bad firmware or network settings
- 