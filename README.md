# Remake in assembly language of "Cityscape", one of the short program of Lee Fastenau - thelbane.
# https://github.com/thelbane/Apple-II-Programs 

* This is a Tribute to Lee Fastenau for the elegance and efficiency of his basic programs


## Usage

This archive contains a disk image to be used it with Applewin or your favourite Apple II emulator.

* Boot cs.do image disk
* type -cs

## Requirements to compile and run

Here is my configuration:

* Visual Studio Code with 2 extensions :

-> [Merlin32 : 6502 code hightliting](https://marketplace.visualstudio.com/items?itemName=olivier-guinart.merlin32)

-> [Code-runner :  running batch file with right-clic.](https://marketplace.visualstudio.com/items?itemName=formulahendry.code-runner)

* [Merlin32 cross compiler](https://brutaldeluxe.fr/products/crossdevtools/merlin)

* [Applewin : Apple IIe emulator](https://github.com/AppleWin/AppleWin)

* [Applecommander ; disk image utility](https://applecommander.sourceforge.net)

* [Ciderpress ; disk image utility](https://a2ciderpress.com)

Note :
DoMerlin.bat puts all things together. You need to indicate your own path to Merlin32 directory, to Applewin, and to Applecommander in DoMerlin.bat file.
DoMerlin.bat is to be placed in project directory.
It compiles source (*.s) with Merlin32, copy 6502 binary to a disk image (containg ProDOS), and launch Applewin with this disk in S1,D1.

## Todo

* Port to DHGR
* Music ?
