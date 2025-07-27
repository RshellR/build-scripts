# Infinity-X for Chime

# Remove some stuffs
rm -rf .repo/local_manifests/ 
rm -rf  vendor/xiaomi
rm -rf  kernel/xiaomi
rm -rf  device/xiaomi
echo "===================================="
echo "Removing stuffs success..."
echo "===================================="

# Clone local_manifests repository
git clone https://github.com/RshellR/local_manifest_chime.git -b 23.0 .repo/local_manifests
echo "===================================="
echo "Cloning local_manifests was success..."
echo "===================================="

# Initialize repo
repo init --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault
echo "===================================="
echo "Initializing repo was success..."
echo "===================================="

# Sync the repositories
/opt/crave/resync.sh
echo "===================================="
echo "Syncing the repositories was success..."
echo "===================================="

# Exports
echo "===================================="
echo "Adding exports..."
echo "===================================="
export BUILD_USERNAME=user
export BUILD_HOSTNAME=localhost

# Device setup for blossom
echo "===================================="
echo "Configuring device setup for Chime..."
echo "===================================="
cd device/xiaomi/chime

cat AndroidProducts.mk | sed -e s/lineage/infinity/g > AndroidProducts.mk.1
mv AndroidProducts.mk.1 AndroidProducts.mk
cat lineage_chime.mk | sed -e s/lineage/infinity/g > lineage_chime.mk.1
mv lineage_chime.mk.1 lineage_chime.mk
cat lineage_chime.mk | grep -v RESERVE_SPACE_FOR_GAPPS > lineage_chime.mk.1
mv lineage_chime.mk.1 lineage_chime.mk
cat lineage_chime.mk | grep -v WITH_GAPPS > lineage_chime.mk.1
mv lineage_chime.mk.1 lineage_chime.mk
mv lineage_chime.mk infinity_chime.mk
echo 'WITH_GAPPS := true' >> infinity_chime.mk
echo 'RESERVE_SPACE_FOR_GAPPS := false' >> infinity_chime.mk
echo 'INFINITY_MAINTAINER := "Rone"' >> infinity_chime.mk

echo 'ro.product.marketname=POCO M3 / Redmi 9T' >> configs/props/system.prop
echo 'ro.infinity.soc=Qualcomm SM6115 Snapdragon 662' >> configs/props/system.prop
echo 'ro.infinity.battery=6000 mAh' >> configs/props/system.prop
echo 'ro.infinity.display=1080 x 2340' >> configs/props/system.prop
echo 'ro.infinity.camera=48MP + 8MP' >> configs/props/system.prop

cat device.mk | grep -v "include vendor/lineage-priv/keys/keys.mk" > device.mk.1
mv device.mk.1 device.mk

cd ../../../


# Patches
patch -f -p 1 < wfdservice.rc.patch
cd packages/modules/Connectivity/ && git reset --hard && cd ../../../
patch -f -p 1 < InterfaceController.java.patch
rm -f InterfaceController.java.patch wfdservice.rc.patch strings.xml.*
rm -f vendor/xiaomi/chime/proprietary/system_ext/etc/init/wfdservice.rc.rej
rm -f packages/modules/Connectivity/staticlibs/device/com/android/net/module/util/ip/InterfaceController.java.rej


cd hardware/xiaomi/
git reset --hard
cd ../../
echo 'diff --git a/vibrator/effect/Android.bp b/vibrator/effect/Android.bp
index 7cb806b..eaa7f2b 100644
--- a/hardware/xiaomi/vibrator/effect/Android.bp
+++ b/hardware/xiaomi/vibrator/effect/Android.bp
@@ -14,8 +14,5 @@ cc_library_shared {
         "libcutils",
         "libutils",
     ],
-    static_libs: [
-        "libc++fs",
-    ],
     export_include_dirs: ["."],
 }
' > hardware_xiaomi.patch
patch -p 1 -f < hardware_xiaomi.patch

# Set up build environment
echo "===================================="
echo "Setting up build environment..."
echo "===================================="
source build/envsetup.sh

# Building Infinity-X
echo "===================================="
echo "Building Infinity-X..."
echo "===================================="
lunch infinity_chime-user
mka installclean
m bacon