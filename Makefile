# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                               USER CONFIGURATIONS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#defaults TODO
CONF_SW_BINNAME      = xminilab
CONF_CPU             = atxmega32a4u
CONF_FCPU            = 32000000UL
CONF_AVRDUDECONF     = /etc/avrdude.conf
CONF_PROGRAMMER      = avrispmkII
CONF_TTY             = usb
CONF_BAUDRATE        = 115200
CONF_CFLAGS          =
CONF_LFLAGS          =

PS_MFLASH  = 72504
PS_MSRAM   = 4096
PS_MEEPROM = 1024

# get user defined settings
#include config.mk


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                               COMPILER AND LINKER
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
PS_CC    = avr-gcc
PS_LD    = avr-gcc
PS_SIZE  = avr-size
PS_USAGE = ./tootils/usage
PS_CDEFS = -D${CONF_CPU} -DF_CPU=${CONF_FCPU}
#PS_CF    = -mmcu=${CONF_CPU} -ffunction-sections -fdata-sections -Os ${PS_CDEFS} ${CONF_CFLAGS}
#PS_LF    = -mmcu=${CONF_CPU} -Wl,-Os -Wl,--gc-sections -Wl,-u,vfprintf -lprintf_flt -lm ${CONF_LFLAGS}
PS_CF    = -mmcu=${CONF_CPU} -ffunction-sections -fdata-sections -Os ${PS_CDEFS} ${CONF_CFLAGS}
PS_LF    = -mmcu=${CONF_CPU} -Wl,-Os -Wl,--gc-sections -Wl,-u,vfprintf -lprintf_flt -lm ${CONF_LFLAGS}


# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                 FILES AND PATHS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# paths
SRC             = src/
BUILD           = build/
# output files
BUILD          := ${BUILD}${CONF_CPU}/
BUILDBIN        = ${BUILD}${CONF_SW_BINNAME}
BUILDELF        = ${BUILDBIN}.elf
BUILDFLASH      = ${BUILDBIN}.flash.hex
BUILDEEPROM     = ${BUILDBIN}.eeprom.hex
# .o files
BUILDOBJ        = ${BUILD}obj/
OBJSFROMC       = $(patsubst %.c,%.o,$(subst $(SRC),,$(shell find ${SRC} -type f -name '*.c')))
OBJSFROMCPP     = $(patsubst %.cpp,%.o,$(subst $(SRC),,$(shell find ${SRC} -type f -name '*.cpp')))
OBJSFROMS       = $(patsubst %.S,%.o,$(subst $(SRC),,$(shell find ${SRC} -type f -name '*.S')))
OBJALL          = ${OBJSFROMC} ${OBJSFROMCPP} ${OBJSFROMS}

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                   TARGETS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

# console colours
CGREEN   = "\\e[32m"
CYELLOW  = "\\e[33m"
CCYAN    = "\\e[36m"
CLCYAN   = "\\e[96m"
CBOLD    = "\\e[1m"
CNONE    = "\\e[0m"
CVOID    = "                        "


# default target: compile and link everything
all: ${BUILDELF} usage ${BUILDFLASH} ${BUILDEEPROM}
	@printf "${CLCYAN}${CBOLD}Done${CNONE}${CLCYAN} for ${CONF_CPU}${CNONE}\n"

# link
${BUILDELF}: $(addprefix ${BUILDOBJ}, $(OBJALL))
	@printf "${CYELLOW}${CBOLD}Linking...${CNONE}\r"
	@${PS_LD} ${PS_LF} -DCPUARCH=${PS_CPU} -o $@ $^
	@${SLOWMOT}
	@printf "\r${CYELLOW}Linked    ${CNONE}\n"

# compile *.c
${BUILDOBJ}%.o: ${SRC}%.c
	@printf "${CGREEN}${CBOLD}Compiling $<...${CNONE}\r"
	@mkdir -p "$(@D)"
	@${PS_CC} ${PS_CF} -DCPUARCH=${PS_CPU} -o $@ -c $<
	@#FCOMP=$(shell date +%s.%6N)
	@${SLOWMOT}
	@printf "\r${CGREEN}Compiled $<     ${CNONE}\n"

# compile *.S
${BUILDOBJ}%.o: ${SRC}%.S
	@printf "${CGREEN}${CBOLD}Compiling $<...${CNONE}\r"
	@mkdir -p "$(@D)"
	@${PS_CC} ${PS_CF} -DCPUARCH=${PS_CPU} -o $@ -c $<
	@#FCOMP=$(shell date +%s.%6N)
	@${SLOWMOT}
	@printf "\r${CGREEN}Compiled $<     ${CNONE}\n"

# print memory usage
usage: ${BUILDELF}
	@printf ${CCYAN}
	@${PS_USAGE} $^ ${PS_MFLASH} ${PS_MSRAM} ${PS_MEEPROM} ${PS_SIZE}
	@printf ${CNONE}

# extract flash in hex format
${BUILDFLASH}: ${BUILDELF}
	@avr-objcopy -O ihex -R .eeprom $^ $@

# extract eeprom in hex format
${BUILDEEPROM}: ${BUILDELF}
	@#avr-objcopy -j .eeprom --change-section-lma .eeprom=0 -O ihex $^ $@

run: all
	@$(call UPLOAD_FLASH,${BUILDFLASH})

# clean the build directory
clean:
	@rm -rf ${BUILD}

# clean and build
fresh: clean all


