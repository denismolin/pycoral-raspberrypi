--- pycoral_original/Makefile	2026-02-01 16:57:15.141049000 +0100
+++ pycoral/Makefile	2026-01-11 16:01:24.138244000 +0100
@@ -135,6 +135,10 @@
     > $(TFLITE_RUNTIME_DIR)/debian/changelog
 endef
 
+define patch_pybind11_for_py311
+$(PYTHON) $(MAKEFILE_DIR)/scripts/patch_pybind11_py311.py
+endef
+
 .PHONY: all \
         pybind \
         tflite \
@@ -146,18 +150,51 @@
         tflite-deb \
         help
 
+define patch_ruy_limits
+RUYC="$$(bazel info output_base)/external/ruy/ruy/block_map.cc"; \
+test -f "$$RUYC"; \
+grep -qE '^\s*#include\s*<limits>\s*$$' "$$RUYC" || sed -i '1i#include <limits>' "$$RUYC";
+endef
+
 all: pybind tflite
 
 pybind:
+	PYTHON_BIN_PATH=$(PYTHON) bazel fetch //src:_pywrap_coral
+	$(call patch_ruy_limits)
+	# Pass 1: patch external pybind11 (output_base/external/...)
+	$(PYTHON) $(MAKEFILE_DIR)/scripts/patch_pybind11_py311.py
+	# Force Bazel to materialize bazel-out/.../_virtual_includes/... (no compilation)
+	PYTHON_BIN_PATH=$(PYTHON) bazel build --nobuild $(BAZEL_BUILD_FLAGS) //src:_pywrap_coral
+	# Pass 2: patch again (now it will also hit bazel-out/.../_virtual_includes/...)
+	$(PYTHON) $(MAKEFILE_DIR)/scripts/patch_pybind11_py311.py
+	# Real build
 	PYTHON_BIN_PATH=$(PYTHON) bazel build $(BAZEL_BUILD_FLAGS) \
-	    --embed_label='TENSORFLOW_COMMIT=$(TENSORFLOW_COMMIT)' \
-	    --stamp \
-	    //src:_pywrap_coral
+		--embed_label='TENSORFLOW_COMMIT=$(TENSORFLOW_COMMIT)' \
+		--stamp \
+		//src:_pywrap_coral
 	mkdir -p $(CORAL_WRAPPER_OUT_DIR)
 	touch $(CORAL_WRAPPER_OUT_DIR)/__init__.py
 	cp -f $(BAZEL_OUT_DIR)/src/_pywrap_coral.so $(CORAL_WRAPPER_OUT_DIR)/$(CORAL_WRAPPER_NAME)
 
+pybind:
+	PYTHON_BIN_PATH=$(PYTHON) bazel fetch //src:_pywrap_coral
+	$(call patch_ruy_limits)
+	# Patch external pybind11 first
+	$(PYTHON) $(MAKEFILE_DIR)/scripts/patch_pybind11_py311.py
+	# Force Bazel to materialize bazel-out/.../_virtual_includes/...
+	PYTHON_BIN_PATH=$(PYTHON) bazel build --nobuild $(BAZEL_BUILD_FLAGS) //src:_pywrap_coral
+	# Patch again (now bazel-out virtual includes exist and will be patched)
+	$(PYTHON) $(MAKEFILE_DIR)/scripts/patch_pybind11_py311.py
+	# Real build
+	PYTHON_BIN_PATH=$(PYTHON) bazel build $(BAZEL_BUILD_FLAGS) \
+		--embed_label='TENSORFLOW_COMMIT=$(TENSORFLOW_COMMIT)' \
+		--stamp \
+		//src:_pywrap_coral
+
 tflite:
+	PYTHON_BIN_PATH=$(PYTHON) bazel fetch //src:_pywrap_coral
+	$(call patch_ruy_limits)
+	$(call patch_pybind11_for_py311)
 	PYTHON_BIN_PATH=$(PYTHON) bazel build $(TFLITE_BAZEL_BUILD_FLAGS) $(TFLITE_WRAPPER_TARGET)
 	mkdir -p $(TFLITE_WRAPPER_OUT_DIR)
 	cp -f $(BAZEL_OUT_DIR)/external/org_tensorflow/tensorflow/lite/python/interpreter_wrapper/_pywrap_tensorflow_interpreter_wrapper.so \
