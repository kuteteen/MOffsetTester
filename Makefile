ARCHS = arm64
THEOS_PACKAGE_DIR_NAME = debs
include /opt/theos/makefiles/common.mk

TWEAK_NAME = customview

customview_FILES = Tweak.xm \
$(wildcard MaskPatcher/*.mm) \
$(wildcard MaskPatcher/*.m) \

customview_FRAMEWORKS = UIKit MessageUI Social QuartzCore CoreGraphics Foundation AVFoundation Accelerate GLKit SystemConfiguration
customview_LDFLAGS += -Wl,-segalign,4000,-lstdc++
customview_CFLAGS ?= -DALWAYS_INLINE=1 -Os -std=c++11 -w -s


include /opt/theos/makefiles/tweak.mk

include /opt/theos/makefiles/aggregate.mk
