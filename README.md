# Voron 2.4r2 by LDO
This is the automated backups of my WIP config that I run on my Voron 2.4r2 300mm.

# Features
- [Pin Mod](https://github.com/hartk1213/MISC/tree/main/Voron%20Mods/Voron%202-Trident/2.4/Voron2.4_Trident_Pins_Mod)
- [GE5C](https://github.com/VoronDesign/VoronUsers/tree/master/printer_mods/hartk1213/Voron2.4_GE5C)
- [Stealthburner with Clockwork 2](https://vorondesign.com/voron_stealthburner)
- [Voron Revo](https://e3d-online.com/products/revo-voron)
- [Voron TAP](https://github.com/VoronDesign/Voron-Tap)
- [EBB SB2240 CAN](https://github.com/bigtreetech/EBB#ebb-sb2240_2209-can-v10)
- [Ocotpus Max](https://github.com/bigtreetech/Octopus-Max-EZ)
- [Kinematics Mount](https://github.com/tanaes/whopping_Voron_mods/tree/main/kinematic_bed)
- [Nozzle Scrubber](https://github.com/VoronDesign/VoronUsers/tree/master/printer_mods/edwardyeeks/Decontaminator_Purge_Bucket_&_Nozzle_Scrubber)
- [ERCF](https://github.com/EtteGit/EnragedRabbitProject) - Using Octopus Max board not ERCF EASY BRD
- [ERCF-Software-V3 "Happy Hare"](https://github.com/moggieuk/ERCF-Software-V3)
- [Adaptive Bed Mesh](https://github.com/Frix-x/klippain/blob/main/docs/features/adaptive_bed_mesh.md)

## Specific features & config

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

## Disclaimer: Usage of this printer config happens at your own risk!