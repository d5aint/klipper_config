# MCU firmware build settings

Klipper `menuconfig` settings for the two boards, as used to build the firmware
flashed on 2026-10-20 (Klipper `v0.13.0-813-ga08fc79fc`).

They normally live untracked in `~/klipper`, so they are not part of any backup
and are lost when the Pi is rebuilt. They are kept here so they survive.

| File | Board | MCU | Crystal | Bootloader offset | Link to the host |
|---|---|---|---|---|---|
| `config.octopus_max` | BTT Octopus MAX EZ | STM32H723 | 25 MHz | 128 KiB (`0x20000`) | USB serial (PA11/PA12) |
| `config.sb2240` | BTT EBB SB2240 | STM32G0B1 | 8 MHz | 8 KiB (`0x2000`) | CAN on PB0/PB1, 1000000 bit/s |

## Rebuilding a firmware image

```
cp ~/printer_data/config/firmware/config.octopus_max ~/klipper/
cd ~/klipper
make clean
make KCONFIG_CONFIG=config.octopus_max
```

The image is written to `out/klipper.bin`. Repeat with `config.sb2240` for the
toolhead board, and flash each board the way you normally do (the flashing
method is not recorded here).

To reproduce the exact images, build from commit `a08fc79fc`. Otherwise build
from the current Klipper and reflash both boards together so the host and MCU
versions stay in step.

To change a setting, run `make KCONFIG_CONFIG=config.<name> menuconfig`, then
copy the updated file back into this folder.
