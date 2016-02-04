define Profile/LININO_CHIWAWA
        NAME:=Linino Chiwawa
        PACKAGES:=kmod-usb-core kmod-usb2
endef

define Profile/LININO_CHIWAWA/Description
        Package set optimized for the Linino Chiwawa based on
        Atheros AR9331.
endef

$(eval $(call Profile,LININO_CHIWAWA))
