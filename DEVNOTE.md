# Soilcrete Data Logger - Developer Note
This document is a note for developers for further maintenance of the software.

## Revision


## Table of Contents
- [Soilcrete Data Logger - Developer Note](#soilcrete-data-logger---developer-note)
  - [Revision](#revision)
  - [Table of Contents](#table-of-contents)
  - [Starting Soilcrete at boot](#starting-soilcrete-at-boot)
  - [Folder Structure of the Software](#folder-structure-of-the-software)
    - [using mountUSBMassStorage](#using-mountusbmassstorage)
    - [using reader.py](#using-readerpy)
  - [Setting up RTC](#setting-up-rtc)
    - [Configuring RPi for I2C](#configuring-rpi-for-i2c)
    - [Setting up RTC](#setting-up-rtc-1)
    - [Syncing the time between RPi and RTC](#syncing-the-time-between-rpi-and-rtc)

## Starting Soilcrete at boot
After booting, the program will automatically start. The auto-start script is written inside `.bashrc` file at home directory of the Raspberry-Pi. After some experimenting, it was found that *USB mounting* and *Serial Communication* won't work by executing script at home directory. The root cause of the problem is currently unknown. Thus, executing the following commands won't work.
```shell
flutter-pi ~/flutter-apps/soilcrete/flutter_assets
```
or given its full path
```shell
/home/pi/flutter-pi/out/flutter-pi /home/pi/flutter-apps/soilcrete/flutter_assets
```
or given sudo permission
```shell
sudo /home/pi/flutter-pi/out/flutter-pi /home/pi/flutter-apps/soilcrete/flutter_assets
```

**The remedy** to this problem is to mimic the behavior of manually executing the script from current directory.
```shell
cd ~/flutter-apps/soilcrete
flutter-pi flutter_assets
```
Executing or adding the above script in `.bashrc` allows USB mounting and Serial Communication to work.



## Folder Structure of the Software
The folder structure is arranged as the following diagram.
```
home/pi
   |
   '---------flutter-apps/
                   '----------soilcrete/
                                    |---------flutter_assets/
                                    |                 '---------app.so
                                    |---------mountUSBMassStorage
                                    '---------reader.py
                                    
```
The description of each files are
- **flutter_assets/** : Flutter assets directory for the application. Without this folder, the app won't be executed.
- **mountUSBMassStorage** : Shell command for mounting and unmounting USB Drive. This command is called by Flutter App.
- **reader.py** : Python script for Serial Communication. This script is called by Flutter App.
- **app.so** : This is the `release` instance of the app. This file allows flutter-pi to run in release mode. (production)

### using mountUSBMassStorage
This script accepts 1 arguement
returns **OK** if success, otherwise **FAIL**.
```
bash mountUSBMassStorage <mount param>

<mount param> can be 'mount' or 'umount' for mounting and unmounting drive
```

### using reader.py
```bash
Gibberish gibbberish
```


## Setting up RTC
> In this note, we'll use DS3231 as our RTC chip.

### Configuring RPi for I2C
1. Power down the Raspberry Pi and then wire the connection between the RTC and the Pi.
2. After wiring is completed, run `update` and `upgrade` commands.
```bash
sudo apt-get update
sudo apt-get upgrade
```
3. After that, configure I2C communication using `raspi-config`
```bash
sudo raspi-config
```
Select **Interfaceing Options** -> **P5 I2C** -> **YES** to confirm enabling I2C interface on Raspberry Pi.

4. Reboot Raspberry Pi
5. Install utilities package
```bash
sudo apt-get install python-smbus i2c-tools
```
6. Run the following command to detect the I2C device
```bash
sudo i2cdetect -y 1
```
If the detection was *successful*, the **68** will show up in the terminal.
```bash
0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- 68 -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --
```

### Setting up RTC
1. Configure the boot configuration file of the Raspberry Pi to let the Kernel load the correct RTC driver. Run the following command
```bash
sudo vim /boot/config.txt
```
2. At the end of the file, append the following line (regarding to your RTC module) then save.
**DS1307**
```bash
dtoverlay=i2c-rtc,ds1307
```
**PCF8523**
```bash
dtoverlay=i2c-rtc,pcf8523
```
**DS3231**
```bash
dtoverlay=i2c-rtc,ds3231
```
3. Reboot the Raspberry Pi.
4. Try detect the I2C again by running the following command.
```bash
sudo i2cdetect -y 1
```
The output will show **UU** instead of **68** indicating that the Kernel successfully loaded the RTC driver.
```bash
0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f
00:          -- -- -- -- -- -- -- -- -- -- -- -- -- 
10: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
20: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
30: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
40: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
50: -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- 
60: -- -- -- -- -- -- -- -- UU -- -- -- -- -- -- -- 
70: -- -- -- -- -- -- -- --
```
5. Next, we have to remove the **fake hwclock** package since we now have a real hw clock. Run the following command to remove the fake hwclock package.
```bash
sudo apt-get -y remove fake-hwclock
sudo update-rc.d -f fake-hwclock remove
```
6. Run the following command to edit the hw-clock file to let the Raspberry Pi use the original hw-clock
```bash
sudo vim /lib/udev/hwclock-set
``` 
7. Find and *comment out* the following 3 lines.
Replace
```bash
if [ -e /run/systemd/system ] ; then
    exit 0
fi
```
with
```bash
#if [ -e /run/systemd/system ] ; then
#    exit 0
#fi
```

### Syncing the time between RPi and RTC
1. To read time directly from RTC, run the following comamnd.
```bash
sudo hwclock -r
```
2. Before sync the time from RPi to the RTC, you must connect the the internet to get the real time. Check with the following command
```bash
date
``` 
3. After that, run the following command to program RTC with the Raspberry Pi time.
```bash
sudo hwclock -w
```
1. To set the time from the RTC to the RPi, run the following command.
```bash
sudo hwclock -s
```


















