#
#   SOFTWARE SETTINGS
#
CONF_SW_VERSION     = 0.1
CONF_SW_NAME        = ATSTART
CONF_SW_SERIAL      = 1
CONF_SW_BINNAME     = atstar
#
#   CPU SETTINGS
#
#CONF_CPU            = atmega2560
CONF_CPU            = atmega328p
CONF_FCPU           = 16000000UL
#CONF_FCPU           = 20000000UL
#
#   PROGRAMMER SETTINGS
#
CONF_AVRDUDECONF    = /etc/avrdude.conf
CONF_PROGRAMMER     = avrispmkII
#CONF_PROGRAMMER     = usbasp
#CONF_PROGRAMMER     = arduino
CONF_TTY            = usb
#CONF_TTY            = /dev/ttyUSB0
CONF_BAUDRATE       = 115200
#
#   COMPILER SETTINGS
#
CONF_CFLAGS         =
CONF_LFLAGS         =

