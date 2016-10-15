GRLIB=../..
TOP=leon3mp
BOARD=altium-user-ep3c40
include $(GRLIB)/boards/$(BOARD)/Makefile.inc
DEVICE=$(PART)-$(PACKAGE)$(SPEED)
UCF=$(TOP).ucf
QSF=$(GRLIB)/boards/$(BOARD)/$(TOP).qsf
EFFORT=std
XSTOPT=
SYNPOPT="set_option -pipe 0; set_option -retiming 0; set_option -write_apr_constraint 0"
VHDLSYNFILES=ver.vhd tmx.vhd tmxmsf.vhd
VHDLSIMFILES=testbench.vhd
SIMTOP=testbench
BITGEN=$(GRLIB)/boards/$(BOARD)/default.ut
CLEAN=clean

TECHLIBS = altera altera_mf cycloneiii
LIBSKIP = core1553bbc core1553brm core1553brt gr1553 corePCIF \
	tmtc gsi openchip hynix cypress ihp usbhc spw subsys techmap eth opencores micron \
        spansion esa fmf xilinxcorelib gaisler trimetix
DIRSKIP = ambatest b1553 pcif leon2 leon2ft crypto satcan leon3ft ddr meiko mfpc \
	grusbhc can pci i2c dps6 cy7c67300 spacewire usb leon4 leon4v0 l2cache \
	slink ascs pwm gr1553b iommu l2cache/v2-pkg sparc dftlib eth opencores memctrl srmmu leon3v3 \
        greth spi grdmac leon3 irqmp net uart jtag arith l2cache debug
FILESKIP = grcan.vhd 

include $(GRLIB)/bin/Makefile


##################  project specific targets ##########################

