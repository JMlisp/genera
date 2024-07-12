
Genera 8.3 Installation Procedure for Symbolics Ivory Machines:
===============================================================


Table of Contents

- Configure serial COM port parameters to control the FEP
- Prepare FEP files required to boot Symbolics Genera
- Access Genera on the NXP1000 from an Intranet host via xterm
- Enable PC and Mac to mount and export a CD-ROM filesystem via NFS
- Restore Distribution Worlds from CD-ROM via the FEP-Tape Activity
- Build an IDS World based on a Genera Distribution World
- Build a Complete World on a Vendor-provided SCSI Disk


Overview:

This section details the steps required to run Genera 8.3 on Ivory Symbolics machines, the way to control the cold load stream, and how to access Genera from a host on the same Intranet. In addition, it outlines details of Genera 8.3 utilities and explains how to create a customised Complete World on a higher capacity Vendor-provided SCSI disk.

The description applies to Ivory machines (iMACH), i.e NXP1000 and XL machines. Unlike XL machines which have their own console, i.e monitor, mouse and keyboard, the NXP1000 needs both a VT100 compatible Serial Terminal to control the cold load stream and an X Terminal to interact with Genera. Configuration details required to achieve this goal are given below.


Configure serial COM port parameters to control the FEP:
--------------------------------------------------------

The serial COM port parameters required to connect to and control the Front-End Processor (FEP) of a Symbolics NXP1000 are as follows:

| Parameter | Value |
|:--- |:--- |
| Connection speed: | 9600 Bits per second |
| Number of Data Bits: | 8 |
| Parity Bits: | none |
| Number of Stop Bits: | 1 |

Flow control can be left with the hardware of your serial COM port. If your computer does not have a serial COM port, you can use a USB to RS232 port adapter. e.g a [VScom USB-2COM PL](https://www.vscom.de/vscom-usb-2com-pl.html), a small and reliable VScom adapter, which provides two RS232 serial ports, easy to configure and to use. The [HyperTerminal Configuration](https://github.com/JMlisp/genera/blob/main/screenshots/HyperTerminal%20Configuration.png) screenshot shows the configuration of a COM port in HyperTerminal under Windows using the aforementioned adapter. Drivers and documentation for this adapter are available for Windows and for other Operating Systems from the aforementioned product homepage.


Prepare FEP files required to boot Symbolics Genera:
----------------------------------------------------

Once the COM port has been configured, you can use a serial port communication software, e.g [HyperTerminal](https://hyperterminal-private-edition-htpe.en.softonic.com/?ex=RAMP-2046.2) or [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html), to connect to the FEP and control the cold load stream on NXP1000 machines and the process of booting Genera, as shows the  [HyperTerminal - Cold Load Stream Venus](https://github.com/JMlisp/genera/blob/main/screenshots/HyperTerminal%20-%20Cold%20Load%20Stream%20Venus.png) screenshot.

As you can see, only two commands are required to boot Genera on a Symbolics machine. This are the commands hello and boot. Hello loads the FEP overlays, assigns an IP Internet address to the machine's Network Interface and includes declarations that enable boot to load a World and start Genera.

For use on Ivory machines, this repository includes examples of the FEP command files [hello.boot](https://github.com/JMlisp/genera/blob/main/hello.boot) and [boot.boot](https://github.com/JMlisp/genera/blob/main/boot.boot). Also available is the FEP command file [autoboot.boot](https://github.com/JMlisp/genera/blob/main/autoboot.boot), which you can use to automate Genera's boot process. You can create .boot files in Genera using Zmacs.


Access Genera on the NXP1000 from an Intranet host via xterm:
-------------------------------------------------------------

On the NXP1000, you can access Genera from a host on the same Intranet using an X Terminal Emulator. Under Windows, this can be [X-Win32](https://www.starnet.com/xwin32/) or [Exceed](https://www.opentext.com/en-gb/products/exceed?utm_source=connectivity&utm_medium=redirect), as well as [X2Go](https://wiki.x2go.org/doku.php/start). Under Mac OS X, you can use the X Terminal Emulator (xterm). Xterm allows Genera PCF fonts to be used during an X session and use Telnet to start an X screen on your X server's display, as shows for the host SERVER [Telnet - X Session Start - Venus to Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Telnet%20-%20X%20Session%20Start%20-%20Venus%20to%20Server%20via%20the%20Intranet.png), using the commands,

**$  xhost  +venus**        # add VENUS to the X server's host list

**$  xset  fp+  /usr/X11/share/fonts/genera**        # adjust font path as appropriate

**$  telnet  venus**

and from within Telnet, launching the following Genera command to get an X screen on your X Server's display.

command:  **start  x  screen  (the name of a host [default ...])  serverhostname**

The default values used by the X Server for display and screen are  :display 0 and :screen  0.

On your display it will appear an X screen similar to that shown by the screenshot [Venus Dynamic Lisp Listener on Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Venus%20Dynamic%20Lisp%20Listener%20on%20Server%20via%20the%20Intranet.png), thus allowing you to log into Genera and start using Lisp.

As shows [Venus Peek Network on Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Venus%20Peek%20Network%20on%20Server%20via%20the%20Intranet.png), the X Server's display 0 is bound as foreign port 6000 (the default display port), and Telnet port 23, in this X session, is bound as foreign port 49183.

Also note that the Telnet process on the X Server host does not return and waits for input as shown in [Venus Peek Processes on Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Venus%20Peek%20Processes%20on%20Server%20via%20the%20Intranet.png) until the command "**halt remote terminal**" is executed in the bash shell as shown in [Telnet - X Session Halt - Venus to Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Telnet%20-%20X%20Session%20Halt%20-%20Venus%20to%20Server%20via%20the%20Intranet.png) and Genera is halted as follows:

command:  **Logout**

command:  **Halt Machine (keywords) :Query (Yes or No [default Yes]) no**

For who might be interested, also available in the repository is a set of Genera configuration files that may be useful when setting up a new Site.

[sys.translations](https://github.com/JMlisp/genera/blob/main/sys.translations)        # Translation file defining the SYS logical pathname

[lmfs.translations](https://github.com/JMlisp/genera/blob/main/lmfs.translations)        # Translation file defining the LMFS logical pathname

[home.translations](https://github.com/JMlisp/genera/blob/main/home.translations)        # Translation file defining HOME host's logical pathname

[joshua.translations ](https://github.com/JMlisp/genera/blob/main/joshua.translations)        # Translation file defining the Joshua logical pathname

[macsyma.translations](https://github.com/JMlisp/genera/blob/main/macsyma.translations)        # Translation file defining the Macsyma logical pathname

Translation files define the translations from logical directories (on the logical host) to physical directories (on a physical host). Except for sys.translations, any other system translation file can be created and modified manually using Zmacs. Upon an LMFS is available, also a personal lisp initialisation file similar to the one provided below, can be created and saved in the user's home directory, to customise Lisp's initialisation.

[lispm-init.lisp](https://github.com/JMlisp/genera/blob/main/lispm-init.lisp)        # LISP User initialisation File

The following Private-Patch-File can be used to cure the "Year 2000 problem" in Genera. That is, it can be included in an Incremental World, in order to avoid the FEP asking for the Date and Time, when booting a Genera Distribution World in a year 2000 onwards. See the section related to Distribution Worlds below.

[y2k.lisp](https://github.com/JMlisp/genera/blob/main/y2k.lisp)        # Private-Patch-File for the Year 2000 problem

The following two files are examples provided only for information. They are created by special Genera commands and should never be manually modified.

[fspt.fspt](https://github.com/JMlisp/genera/blob/main/fspt.fspt)        # LMFS File System Partition Table

[home-objects.text](https://github.com/JMlisp/genera/blob/main/home-objects.text)        # Namespace objects of Site Home

The tape provided below contains the sources and associated .ibin files of patches that cure remaining problems in Genera_8_3, and tools that extend its functionality.

[home.reel](https://github.com/JMlisp/genera/blob/main/home.reel)        # Tape including the sources of home-site and home-tools

Also available are the sources of the Private-Patch-Files provided below, and the file w83 that may be used to build a complete Symbolics world.

[init-time.lisp](https://github.com/JMlisp/genera/blob/main/init-time.lisp)        # Use only, if the time from calendar clock is not available

[merlin-ii-patch-2.lisp](https://github.com/JMlisp/genera/blob/main/merlin-ii-patch-2.lisp)        # Private-Patch-File for Symbolics XL1200 machines only

[w83.lisp](https://github.com/JMlisp/genera/blob/main/w83.lisp)        # Lisp file containing definitions to build a complete world

Except for sys.translations, fspt.fspt and home-objects.text, but including hello.boot, boot.boot and autoboot.boot, put the aforementioned files on a CD-ROM, eventually removing the extension .txt from .lisp files if attached, and title it Downloads. It will be useful, should you decide to build a new world, incremental or complete, as described further below.


Enable PC and Mac to mount and export a CD-ROM filesystem via NFS:
------------------------------------------------------------------

A CD-ROM drive for NXP1000 and XL machines normally has had to be ordered separately. Should a CD-ROM drive not be available to your machine, you can restore a Symbolics Distribution World into Genera, using the CD-ROM drive of another workstation on the LAN, for example of a PC or Mac.

Of course this can be done only, if an LMFS already exists on your machine, and PC and Mac are defined as hosts in Genera's namespace database, as shown for Pluto and MacPro in the home-objects.text file for the site "home". If either no LMFS is available or PC or Mac are undefined, consult the documentation for Adding a LMFS partition or for using the command "Create namespace object host" in Site Operations.

A CD-ROM mounted under Windows can be accessed from Genera by installing [Allegro NFS](https://nfsforwindows.com) onto your PC. All you need to do to export a CD-ROM filesystem via NFS, is to specify the path to the CD-ROM drive on the PC and define User access privileges, as shows the [Allegro NFS - Export CD-ROM Filesystem](https://github.com/JMlisp/genera/blob/main/screenshots/Allegro%20NFS%20-%20Export%20CD-ROM%20Filesystem.png) screenshot.

Under Mac OS X a CD-ROM, e.g a Genera_8_3 Distribution CD-ROM, gets mounted as a Volume. Exporting the CD-ROM filesystem requires the following steps.

From within OS X System Preferences - Sharing, allow the Mac's CD-ROM drive to be accessed from other hosts on the LAN, by setting DVD or CD Sharing as shown in [OS X NFS - Export CD-ROM](https://github.com/JMlisp/genera/blob/main/screenshots/OS%20X%20NFS%20-%20Export%20CD-ROM.png).

Configure /etc/exports in Mac OS X to allow exporting a CD-ROM filesystem via NFS, as shows the file [exports](https://github.com/JMlisp/genera/blob/main/exports), using the hostnames of your LAN hosts and User ID, as appropriate.

In Genera's Dynamic Lisp Listener you can then ask for filesystems exported by a specific host, PC or Mac, using the command,

command:  **show  NFS  exports  (the name of a host [default ...])  hostname**

You can then proceed, mounting the CD-ROM filesystem, e.g using Genera's FileSystem Manager, as shown for the PC host Pluto and for the workstation MacPro in the screenshots [Exported Genera_8_3 CD-ROM Filesystem from PC Pluto](https://github.com/JMlisp/genera/blob/main/screenshots/Exported%20Genera_8_3%20CD-ROM%20Filesystem%20from%20PC%20Pluto.png) and [Exported Genera_8_3 CD-ROM Filesystem from MacPro](https://github.com/JMlisp/genera/blob/main/screenshots/Exported%20Genera_8_3%20CD-ROM%20Filesystem%20from%20MacPro.png), respectively.


Restore Distribution Worlds from CD-ROM via the FEP-Tape Activity:
------------------------------------------------------------------

From Genera 8.1.1 onwards, you can restore Distribution worlds from CD-ROM using the FEP-Tape activity. As shown in screenshots [Restore Genera Distribution World from PC CD-ROM](https://github.com/JMlisp/genera/blob/main/screenshots/Restore%20Genera%20Distribution%20World%20from%20PC%20CD-ROM.png) and [Restore Genera Distribution World from Mac CD-ROM](https://github.com/JMlisp/genera/blob/main/screenshots/Restore%20Genera%20Distribution%20World%20from%20Mac%20CD-ROM.png), do this, typing Read Image File and supplying a CD-ROM pathname to a world image. Do not use the [Read Image File] menu item, because it will not prompt you for a world image pathname. If necessary, use "Ctrl-Shift ?", which provides the possible path completions to identify and restore the world you are interested on.

The same way, you can copy also other software from a CD-ROM onto an Ivory's LMFS, as for example shown below for copying the y2k Private-Patch-File from the CD-ROM Downloads on MacPro into the directory special on the NXP1000 VENUS, using the command.

command:  **copy file (pathname of files [default ...]) MP:/Volumes/Downloads/y2k.lisp (to [default ...]) v:>special>**


Build an IDS World based on a Genera Distribution World:
--------------------------------------------------------

On a Symbolics machine, e.g on the iMACH VENUS, you can build an Incremental Disk Save (IDS) world, including a Distribution World, restored from CD-ROM as described above, e.g Genera_8_3, and the y2k Private-Patch-File, performing the sequence of steps given below.

1.  Insert the CD-ROM Downloads into the CD/DVD drive of your PC or Mac

2.  Onto your iMACH Symbolics workstation create the directory "special"

3.  Copy the file y2k.lisp from CD-ROM to the directory "special", as shown above for 
    the host MacPro. If, however, the CD-ROM has been placed in the CD/DVD drive of a 
    PC, e.g Pluto, use instead the following command.

    command:  **copy file (pathname of files [default ...]) pluto:/CDROM/y2k.lisp (to [default ...])  venus:>special>**

4.  Issue the following command in order to compile the Private-Patch-File

    command:  **Compile  File (file) venus:>special>y2k.lisp**

5.  Create a new version of boot.boot that points to the Distribution World

6.  Logout and issue the following command to halt the current Genera session

    command:  **Halt  Machine (keywords)  :query no**

7.  In the FEP, boot the Distribution World, using the file boot.boot.newest

8.  In the cold load stream you will be asked to provide the Date and Time

9.  Enter mm/dd/yyyy and hh:mm:ss separated by a blank and press return

10. In DIS-LOCAL-HOST's Dynamic Lisp Listener log in as LISP-MACHINE

11. Put mouse pointer away to avoid highlighting objects by screen scrolling

12. Issue the following command to load the compiled Private-Patch-File

    command:  **Load  File (file [default ...])  dis-local-host:>special>y2k**

13. Issue the following command in order to save the current world incrementally

    command:  **Save World (Complete or Incr... [...]) Incremental  Genera_8_3_y2k.ilod**

14. Create a new version of boot.boot that points to world Genera_8_3_y2k.ilod

15. Logout and boot Genera_8_3_y2k.ilod on your workstation, as done before

The Genera_8_3_y2k World will now boot and the Genera Dynamic Lisp Listener be started without being asked in the cold load stream to enter the Date and Time.

Using the world Genera_8_3_y2k.ilod you can create a customised Complete World on a higher-capacity, Vendor-provided, SCSI disk and replace the small 1GB disk, made available by Symbolics on NXP1000 or XL machines on delivery. For details, see section "Build a complete World on a Vendor-provided SCSI Disk" below.

You can also use the Genera activity "Restore Distribution" to load special programs, systems, or Genera sources into a current world, as shown in screenshots [Restore Genera Distribution Sources from PC CD-ROM](https://github.com/JMlisp/genera/blob/main/screenshots/Restore%20Genera%20Distribution%20Sources%20from%20PC%20CD-ROM.png) and [Restore Genera Distribution Sources from Mac CD-ROM](https://github.com/JMlisp/genera/blob/main/screenshots/Restore%20Genera%20Distribution%20Sources%20from%20Mac%20CD-ROM.png), respectively. For details, see the Genera document "Site Operations".

With the NFS settings for exporting CD-ROM filesystems described above, you can even place a Genera_8_3 Distribution CD-ROM into a PC's CD/DVD drive, then use an X Terminal Emulator on a Mac to mount the CD-ROM's filesystem under Genera's File System Maintenance Program, as shows the screenshot [Exported Genera_8_3 CD-ROM Filesystem from PC via Mac](https://github.com/JMlisp/genera/blob/main/screenshots/Exported%20Genera_8_3%20CD-ROM%20Filesystem%20from%20PC%20via%20Mac.png), and restore a Distribution world and Genera sources, as shown in [Restore Genera Distribution World from PC CD-ROM via Mac](https://github.com/JMlisp/genera/blob/main/screenshots/Restore%20Genera%20Distribution%20World%20from%20PC%20CD-ROM%20via%20Mac.png) and [Restore Genera Distribution Sources from PC CD-ROM via Mac](https://github.com/JMlisp/genera/blob/main/screenshots/Restore%20Genera%20Distribution%20Sources%20from%20PC%20CD-ROM%20via%20Mac.png), respectively.


Build a Complete World on a Vendor-provided SCSI Disk:
------------------------------------------------------

You can use a higher-capacity Vendor-provided SCSI disk to replace the small 1GB disk usually installed on Symbolics NXP1000 and XL machines on delivery.

Be however aware, that because a word on Ivory Symbolics machines uses 40 bits, i.e for each 32-bit word there are 8 additional tag bits, only specific SCSI disks with a variable sector size can be low-level formatted for use on NXP1000 and XL machines, as for example the 9.1GB Seagate ST39173N SCSI disk. The default sector size for formatting such a SCSI disk is 1280 Bytes per sector. That is, each sector on a SCSI disk for Ivory machines comprises 256 40-bit words.

To proceed with the installation of a virgin SCSI disk onto an iMACH workstation these are the steps you might take. However, take into account that the convention for mapping SCSI addresses to FEP unit numbers is that the FEP unit number, but only for Symbolics XL machines, is 7 greater than the SCSI address, with the first SCSI disk of a machine having the SCSI address 0.

1.  Connect the SCSI disk to the NXP1000 or XL machine and power up the disk

2.  Boot your machine using the current Genera version available on FEP0 or FEP7

3.  Unless explicitly requested, in the following always log in as LISP-MACHINE

4.  Type in the command "Show machine configuration", followed by return

5.  Retrieve the SCSI address of the new SCSI disk from the system's response, i.e if 
    only two disks are connected, the new disk should have SCSI address 1

6.  Issue the following command to format the SCSI disk 1 at the lowest level

    command:  **Format SCSI Disk (SCSI address) 1  :sector size 1280**

7.  On completion, warm boot the Genera version available on FEP0 or FEP7

8.  Issue the following command to create an Initial FEP File System on unit 1

    command:  **Create  Initial  FEP Filesystem (FEP unit number)  1**        ; or 8 for FEP8

9.  Type in the command "Show machine configuration", followed by return

10. This time, both FEP0 or FEP7 and either FEP1 or FEP8 is referred to by the operating system

The next step is to copy the IDS world Genera_8_3_y2k.ilod created above, see section related to Distribution Worlds, from FEP0 to FEP1 or from FEP7 to FEP8, depending on the machine type, using the "Copy World" Command.

Note, however, that the "Copy World" Command makes a copy of a world load file. This includes the specified world as well as any IDS worlds on which it was built. After you issue the "Copy World" Command, unless ":Query No" was specified, Genera pops up a menu allowing you to specify the actions you want it to take. The default values are fine, so just select <end> use these values. That is, in order to copy the world Genera_8_3_y2k.ilod from FEP0 to FEP1 issue the command

command:  **copy world (from FEP files(s) [default ...]) FEP0:>genera_8_3_y2k.ilod  FEP1:>**

This will copy to FEP1 or FEP8 also the Distribution world genera_8_3.ilod on which the IDS world genera_8_3_y2k.ilod was built.

In order to boot a world, the destination FEP needs using the appropriate FEP overlays. That is, I328 FEP overlays for SCSI disks up to 1GB, and I333 FEP overlays for disks over 1GB. So, if the required overlays are already available on FEP0 or FEP7, just copy them over to FEP1 or FEP8, i.e to the destination Disk Unit 1 or 8, using the "Copy Flod Files" Command shown below.

command:  **copy flod files  :disk unit 1  :version i333**

On iMACH machines, this command copies flod files and FEP kernel from host SYS:IFEP to the specified destination Disk Unit, it makes sure that FEP kernel and overlay versions are consistent with one another, and also installs the previous FEP kernel, if any, as the FEP backup kernel.

If no I333 FEP overlays are available on your machine, contact Symbolics-dks, i.e sales@symbolics-dks.com, to get these overlays, put them onto a CD-ROM titled Overlays, and restore them from CD-ROM Overlays onto FEP1 or FEP8, as described below.

1.  Insert the CD-ROM Overlays into the CD/DVD drive of your PC or Mac

2.  Run Select activity restore distribution to restore the content of the CD-ROM
    Overlays onto your machine,

    Note: If you placed the CD-ROM into the Mac's CD/DVD drive, check that the Volume 
    Overlays is exported on your Mac, as shown in the file /etc/exports for the Volume 
    Genera_8_3.

3.  Copy i333 flod files and FEP kernel from host SYS:IFEP over to FEP1 or FEP8,i.e 
    to the destination Disk Unit 1 or 8, using the "Copy Flod Files" Command, 
    described above.

Now, in order to boot the world Genera_8_3_y2k.ilod from the destination FEP, i.e FEP1 or FEP8, you need either to create from new or to copy the two files hello.boot and boot.boot from CD-ROM Downloads to the destination FEP using the "Copy file" Command, and to update these files using Zmacs, to point both to FEP1 or FEP8 and to Genera_8_3_y2k.ilod, as appropriate. If you placed the CD-ROM into the Mac's CD/DVD drive, before copying check that the Volume Downloads is exported on your Mac, as shown in /etc/exports for the Volume Genera_8_3.

You are now ready to boot the world Genera_8_3_y2k.ilod from the destination disk FEP1 or FEP8, and complete the configuration of your new SCSI disk, as described below.

1.  Shut down the machine and boot Genera_8_3_y2k.ilod from FEP1 or FEP8

2.  Unless explicitly requested, in the following always log in as LISP-MACHINE

3.  See section Adding an LMFS Partition in Genera handbook Site Operations

4.  Press Select F, to select the File System Maintenance Program (FSMP)

5.  Create an LMFS New File System of 500000 blocks on FEP1 or FEP8

6.  Issue the following commands to create two paging files on FEP1 or FEP8

    command:  **Create  FEP  File (FEP file [default ...])  fep1:>paging-1.page  200000**

    command:  **Create  FEP  File (FEP file [default ...])  fep1:>paging-2.page  200000**

7.  Issue the following command to define a new namespace called "site-name"

    command:  **Define Site (site name)  site-name**

    You will now be asked to specify the name of the local machine that shall be the 
    primary namespace server, SYS host, host for storing the namespace database 
    files, and host for bug reports. See document Site Operations for more details.

    **Note**:  In the following, HOME is used as site-name and VENUS as host-name

8.  Shut down and reboot Genera_8_3_y2k.ilod from FEP1 or FEP8, as before

9.  Log in and configure the local world as an existing site using the command

    command:  **Set Site (site name [default ...])  home**        ; as specified by Define Site

10. Issue the following command in order to save the current world incrementally

    command:  **Save World (Complete or Increm... [...]) Incremental  Initial.ilod**

11. Using Zmacs, create a boot.boot file that points to world Initial.ilod

12. Shut down and reboot the world Initial.ilod from FEP1 or FEP8, as before

13. Create an LMFS directory "special" to hold the files from CD-ROM Downloads

14. Copy the files from CD-ROM Downloads to the appropriate LMFS directory

    **Note**: It's assumed that the CD-ROM is placed in Pluto's PC CD/DVD drive. If you
    placed the CD-ROM into the MacPro's CD/DVD drive, in place of pluto:/CDROM/ use
    macpro:/Volumes/Downloads/.

    Note also that copying the files from the CD-ROM to an LMFS directory is 
    possible at this time, only because NFS Client is included in Genera_8_3.

    In the following for simplicity it is assumed that the iMACH workstation you are 
    logged on is called VENUS

    command:  **copy file (pathname of files [default ...])  pluto:/CDROM/*.lisp (to [default ...])  venus:>special>**

    command:  **copy file (pathname of files [default ...])  pluto:/CDROM/*.reel (to [default ...])  venus:>special>**
    
    command:  **copy file (pathname of files [default ...])  pluto:/CDROM/*.translations (to [default ...]  venus:>sys>site>**

16. Invoke the following command to compile one at a time the copied Lisp files, i.e init-time.lisp, merlin-ii-patch-2.lisp and w83.lisp

    command:  **Compile File (file) venus:>special>filename.lisp**

17. Restore Genera_8_3 Distribution Systems and Sources from CD-ROM, using "Select 
    activity restore distribution", as shown in the section related to Distribution 
    Worlds

18. Shut down and reboot the world Initial.ilod from FEP1 or FEP8, as before

19. Login and press "Function M 1" to toggle global ****More**** processing to on. An 
    argument of 1 turns it on; 0 turns it off.

20. Dependent on the machine type load the following files into the current session

    command:  **Load  File (file [default ...]) venus:>special>init-time**        ; if no Time from calendar clock is available

    command:  **Load  File (file [default ...]) venus:>special>merlin-ii-patch-2**        ; for XL1200 machines only

    command:  **Load  File (file [default ...]) venus:>special>w83**        ; for all Ivory machines

21. In Genera's Dynamic Lisp Listener call the following function without arguments

    command:  **(wform)**

22. Move the mouse pointer over the left or right most parenthesis of the PROGN form 
    that appears on the screen to select it, and click it left to activate the form

23. Put the mouse pointer away to avoid highlighting objects by screen scrolling

24. On completion, issue the following command to save the current world as

    command:  **save  world (Complete or Incremental [...]) Complete Symbolics.ilod**

25. Create a new version of boot.boot that points to the world Symbolics.ilod

26. Shut down and reboot the world Symbolics.ilod from FEP1 or FEP8, as before

27. If you own a license put Macsyma's CD into the PC's or the Mac's CD/DVD drive

28. Issue the command: **Select activity restore distribution** to restore the Macsyma system

29. Shut down and reboot the world Symbolics.ilod from FEP1 or FEP8, as before

30. Invoke the following command to load macsyma into the current Genera session

    command:  **load  system (a system) macsyma  :version  released**

31. Put the mouse pointer away to avoid highlighting objects by screen scrolling

32. On completion, save the current world incrementally using the command

    command:  **Save  World (Complete or Incremental [...]) Incremental  Macsyma.ilod**

33. Create a new version of boot.boot that points to the world Macsyma.ilod

34. Issue the command: **Select activity restore distribution** to restore the tape home.reel

35. Shut down and reboot the world Macsyma.ilod from FEP1 or FEP8, as before

36. Invoke the following commands to load into the current Genera session the systems 
    below

    command:  **load  system (a system) home-site  :version  released**

    command:  **load  system (a system) home-tools  :version  released**

37. Put the mouse pointer away to avoid highlighting objects by screen scrolling

38. On completion, save the current world as Complete using the command

    command:  **Save  World (Complete or Incremental [...]) Complete  Standard.ilod**

39. Create a new version of boot.boot that points to the world Standard.ilod

40. Shut down and reboot the world Standard.ilod from FEP1 or FEP8, as before

41. Login and create a user "xyz" in the namespace database, using the users "jm" or 
    "bb" of VENUS's namespace file home-objects.text as example

    command:  **create  namespace  object (class)  user (name)  xyz**

42. Copy the following files to the appropriate destinations, as shown below

    command:  **copy file (pathname of files [default ...])  venus:>special>lispm-init.lisp
    (to [default ...]) venus:>xyz>**        ; i.e the home directory of user xyz

    command:  **copy file (pathname of files [default ...])  venus:>special>autoboot.boot
    (to [default ...]) FEP1:>**        ; or FEP8, as appropriate

44. Dependent on whether you plan to substitute the current Disk unit 0 by the 
    SCSI Disk unit 1 or not, modify the above files and the files hello.boot and 
    boot.boot using Zmacs to point to the appropriate FEP, and to satisfy Lisp 
    initialisation preferences

45. Logout, issue the command: **halt machine :query no**, shutdown and switch your iMACH 
    machine again on, this time, to allow it auto-booting

46. Login as the user "xyz", add other users, printers and hosts in the namespace 
    database of your machine, using the contents of the VENUS's namespace file home-
    objects.text as example.

You have now a complete, configured, and customised Genera 8.3 world on your NXP1000's or XL machine's high-capacity SCSI disk.

For completeness, three Macsyma-related screenshots, namely [Venus Macsyma Listener on Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Venus%20Macsyma%20Listener%20on%20Server%20via%20the%20Intranet.png), [Venus Macsyma 3D Plot 1 on Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Venus%20Macsyma%203D%20Plot%201%20on%20Server%20via%20the%20Intranet.png) and [Venus Macsyma 3D Plot 2 on Server via the Intranet](https://github.com/JMlisp/genera/blob/main/screenshots/Venus%20Macsyma%203D%20Plot%202%20on%20Server%20via%20the%20Intranet.png) are provided.
