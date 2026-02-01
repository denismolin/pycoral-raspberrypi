--- pycoral_original/scripts/build.sh	2026-02-01 16:57:15.241049000 +0100
+++ pycoral/scripts/build.sh	2026-01-11 16:54:16.283526000 +0100
@@ -17,8 +17,8 @@
 
 readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
 readonly MAKEFILE="${SCRIPT_DIR}/../Makefile"
-readonly DOCKER_CPUS="${DOCKER_CPUS:=k8 aarch64 armv7a}"
-PYTHON_VERSIONS="36 37 38 39"
+readonly DOCKER_CPUS="${DOCKER_CPUS:=k8 aarch64}"
+PYTHON_VERSIONS="311"
 
 while [[ $# -gt 0 ]]; do
   case "$1" in
@@ -40,10 +40,11 @@
 function docker_image {
   case $1 in
     36) echo "ubuntu:18.04" ;;
-    37) echo "debian:buster" ;;
+    37) echo "debian:bookworm" ;;
     38) echo "ubuntu:20.04" ;;
-    39) echo "debian:bullseye" ;;
-    *) echo "Unsupported python version: $1" 1>&2; exit 1 ;;
+    39) echo "debian:bookworm" ;;
+    311) echo "debian:bookworm" ;;
+   *) echo "Unsupported python version: $1" 1>&2; exit 1 ;;
   esac
 }
 
