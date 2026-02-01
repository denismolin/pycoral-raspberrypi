# PyCoral Python 3.12 Adaptation Guide for Raspberry Pi

This guide explains how to adapt the [PyCoral](https://github.com/google-coral/pycoral) repository to support **Python 3.12** on **Raspberry Pi**. The changes include patching `pybind11`, updating build scripts, and ensuring compatibility with Python 3.12.

---

## Table of Contents
1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [File Replacements](#file-replacements)
4. [Build Process](#build-process)
5. [Optional: Debian Package](#optional-debian-package)
6. [Optional: Docker Build](#optional-docker-build)
7. [Troubleshooting](#troubleshooting)

---

## Overview
This adaptation allows PyCoral to compile and run on **Raspberry Pi** with **Python 3.12**. The key changes involve:
- Patching `pybind11` for Python 3.12 compatibility.
- Updating build scripts and environment variables.
- Modifying the Dockerfile for containerized builds.

---

## Prerequisites
- Raspberry Pi (64-bit OS recommended).
- Python 3.12 and `python3.12-dev` installed:
  ```bash
  sudo apt update
  sudo apt install python3.12 python3.12-dev
  ```
- Cloned PyCoral repository:
  ```bash
  git clone --recurse-submodules https://github.com/google-coral/pycoral.git
  ```

---

## File Replacements
Replace the following files in the PyCoral repository with the modified versions from this repository:

| File Path                          | Description                                      |
|------------------------------------|--------------------------------------------------|
| `scripts/patch_pybind11_py311.py`  | Patches `pybind11` for Python 3.12 compatibility. |
| `scripts/build.sh`                 | Main build script (calls the patch script).      |
| `scripts/build_deb.sh`             | Builds Debian package for Python 3.12.           |
| `Makefile`                         | Updated build targets for Python 3.12.           |
| `libcoral/docker/Dockerfile`       | Docker image with Python 3.12 support.           |

**Command to replace files:**
```bash
cp scripts/patch_pybind11_py311.py pycoral/scripts/
cp scripts/build.sh pycoral/scripts/
cp scripts/build_deb.sh pycoral/scripts/
cp Makefile pycoral/
cp libcoral/docker/Dockerfile pycoral/libcoral/docker/
```

Make the patch script executable:
```bash
chmod +x pycoral/scripts/patch_pybind11_py311.py
```

---

## Build Process
1. Navigate to the PyCoral directory:
   ```bash
   cd pycoral
   ```
2. Run the build script:
   ```bash
   ./scripts/build.sh
   ```
   - This script automatically calls `patch_pybind11_py311.py` and compiles PyCoral for Python 3.12.

---

## Optional: Debian Package
To build a Debian package for Python 3.12:
```bash
./scripts/build_deb.sh
```

---

## Optional: Docker Build
To build a Docker image with Python 3.12 support:
```bash
docker build -t pycoral:3.12 -f libcoral/docker/Dockerfile .
```

---

## Troubleshooting
- **Missing Python Headers:** Ensure `python3.12-dev` is installed.
- **Patch Errors:** Check the output of `patch_pybind11_py311.py` for details.
- **Permission Issues:** Use `chmod +x` for scripts and `sudo` if necessary.

---

## License
This adaptation is provided under the same license as the original PyCoral repository.
