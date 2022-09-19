# SW-Update Helper Scripts

This are some helper and demo scripts showed in the [qt-swupdate](https://embear.ch/blog/sw-update-concepts) article. As base rootfs we can use any rootfs e.g. this one for the [Verdin iMX8MP](https://www.toradex.com/computer-on-modules/verdin-arm-family/nxp-imx-8m-plus) from Toradex: 
[https://files.embear.ch/embear-initial.tar.zst](https://files.embear.ch/embear-initial.tar.zst)

# Untar image

To get the base rootfs we can extract embear-initial.tar.zst:
```bash
mkdir rootfs 
tar -xf embear-initial.tar.zst -C rootfs
```

The other overlay directories are part of this repository.

# Build Image with swupdate

This is the version 2.0.0 Image which shows how swupdate works:
```bash
fakeroot ./create-tar.sh rootfs overlay_base overlay_swupdate
cp -f -l swupdate-image.tar.zst swupdate/image.tar.zst
./create-swu.sh swupdate-image 2.0.0
```

The output will be `swupdate/swupdate-image_2.0.0.swu`.

# Build Image with qtota

This will create version 3.0.0 of the demo image with qt ota (OSTree) enabled.
```bash
fakeroot ./create-qt-image.sh rootfs/ overlay_base/ overlay_qtota/
cp -f -l qtota-image.tar.zst swupdate/image.tar.zst
./create-swu.sh qtota-image 3.0.0
```
The output will be `swupdate/qtota-image_3.0.0.swu` and is installable by swupdate.

To serve ostree we can do:
```bash
cd ostree-repo
pyhton3 -m http.server 8080
```

qtota on the device expects the server to run on 192.168.1.254:8080.

# Build all images

Run create-all.sh to create image for swupdate which contain the qt example applicaiton and qtota.
