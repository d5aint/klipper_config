### Voron Klipper Backup
This is the automated backups of my klipper config

Voron 2.4r2 300mm by LDO

### Features
- [Pin Mod](https://github.com/hartk1213/MISC/tree/main/Voron%20Mods/Voron%202-Trident/2.4/Voron2.4_Trident_Pins_Mod)
- [GE5C](https://github.com/VoronDesign/VoronUsers/tree/master/printer_mods/hartk1213/Voron2.4_GE5C)
- [Filament Latch 2020 Extrusion](https://www.printables.com/model/172368-voron-24-filament-latch-or-any-2020-extrusion)
- [Stealthburner with Clockwork 2](https://vorondesign.com/voron_stealthburner)
- [Voron Revo](https://e3d-online.com/products/revo-voron)
- [Voron TAP](https://github.com/VoronDesign/Voron-Tap)
- [3DO Nozzle Camera](https://github.com/3DO-EU/nozzle-camera#3do-nozzle-camera)
- [EBB SB2240 CAN](https://github.com/bigtreetech/EBB#ebb-sb2240_2209-can-v10)
- [Ocotpus Max](https://github.com/bigtreetech/Octopus-Max-EZ)
- [Kinematics Mount](https://github.com/tanaes/whopping_Voron_mods/tree/main/kinematic_bed)
- [Nozzle Scrubber](https://github.com/VoronDesign/VoronUsers/tree/master/printer_mods/edwardyeeks/Decontaminator_Purge_Bucket_&_Nozzle_Scrubber)
- [ERCF](https://github.com/EtteGit/EnragedRabbitProject) - Using Octopus Max board not ERCF EASY BRD
- [ERCF-Software-V3 "Happy Hare"](https://github.com/moggieuk/ERCF-Software-V3)
- [Sensorless Homing](https://docs.vorondesign.com/community/howto/clee/sensorless_xy_homing.html)
- [Adaptive Bed Mesh](https://github.com/Frix-x/klippain/blob/main/docs/features/adaptive_bed_mesh.md)
- [Git backup](https://github.com/th33xitus/kiauh/wiki/How-to-autocommit-config-changes-to-github%3F) - using [SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh) authentication


### Specific features & config

Config is divided in two folders : one for the hardware declarations and the other for all the macros. In these folders I tried to put everything in files to be able to find and modify everything easily.

#### Purge bucket

There is a purge bucket at the back of the machine with a brush to purge and clean the nozzle tip. This ensure repeatability and consistency in the measurements.

#### Nevermore and chamber heating

Under the bed is a Nevermore duo v5 recirculating active carbon filter. This filters the VOCs generated during printing but the dual 5015 fans also serves as a quick chamber heat distribution system during the pre-print phase.

#### Adaptive bed mesh

Only do a bed mesh if it's needed (ie. no mesh if there is only a small single part in the center of the bed, and/or only mesh around the parts with a small margin).
To be able to use it, you need to add in SuperSlicer custom g_code :
```
START_PRINT [...common args...] SIZE={first_layer_print_min[0]}_{first_layer_print_min[1]}_{first_layer_print_max[0]}_{first_layer_print_max[1]}
```

#### Pre-print phase

The macro ```PRINT_START``` is dedicated to prepare the machine to print:
1. First this macro manages the heatsoak of the bed when needed. If I put the bed at temperature manually before starting a print, the macro will take care of that and will not do the heatsoak.
2. Then, there is a chamber heating phase using the nevermore fans at full power. This phase is customizable: it follows the chamber temperature setting from the slicer and there is also a timeout if the temperature is not reached in time. This phase ensures the chamber of the machine is at a good temperature for critical material like ABS that is very prone to warping and layer adhesion problems.
3. When the bed and chamber are at temperature, the machine goes for a quad gantry leveling, a purge of the hotend/nozzle, cleaning of the nozzle tip.
4. Then the macro applies custom material parameters like PA, nevermore filtering, retraction settings, etc...
5. At the end, an adaptive bed mesh is recorded before starting the print.

# Disclaimer: Usage of this printer config happens at your own risk!


### Links
#### Main mod repos
- [Voron User Mods](https://github.com/VoronDesign/VoronUsers/tree/master/printer_mods)
- [https://voronregistry.com/mods](https://voronregistry.com/mods) - Also nice website for same by discord:exceptionptr
- [https://vorondesign.com/](https://vorondesign.com/)

#### Software
- [Klipper](https://www.klipper3d.org/)
- [Mainsail](https://docs.mainsail.xyz/)
- [KlipperScreen](https://klipperscreen.readthedocs.io/en/latest/)
- [Crowsnest](https://github.com/mainsail-crew/crowsnest)

#### Hardware
- [BTT Ocotpus Max EZ](https://github.com/bigtreetech/Octopus-Max-EZ)
- [BTT EBB SB2240](https://github.com/bigtreetech/EBB#ebb-sb2240_2209-can-v10)

#### Misc
- [Ellis' SuperSlicer Profiles](https://github.com/AndrewEllis93/Ellis-SuperSlicer-Profiles)
- [Ellis' Print Tuning Guide](https://ellis3dp.com/Print-Tuning-Guide/)

#### Other klipper backups
- [https://github.com/AndrewEllis93/v2.247_backup_klipper_config](https://github.com/AndrewEllis93/v2.247_backup_klipper_config)
- [https://github.com/richardjm/voronpi-klipper-backup](https://github.com/richardjm/voronpi-klipper-backup)
- [https://github.com/zellneralex/klipper_config](https://github.com/zellneralex/klipper_config)
- [https://github.com/rootiest/zippy-klipper_config](https://github.com/rootiest/zippy-klipper_config)
- [https://github.com/Frix-x/klippain](https://github.com/Frix-x/klippain)
