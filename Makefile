# Linux-цели выполняются внутри Ubuntu. RARS — на macOS.
CROSS ?= riscv64-linux-gnu-
CC_RV := $(CROSS)gcc
AS_RV := $(CROSS)as
LD_RV := $(CROSS)ld
READELF := $(CROSS)readelf
OBJDUMP := $(CROSS)objdump
QEMU ?= qemu-riscv64
JAVA ?= java
RARS_JAR ?= tools/rars.jar
BUILD := build
ARCH := -march=rv64im -mabi=lp64
.PHONY: all linux check-linux inspect sections extensions rars check-rars clean
all: linux
linux: $(BUILD)/first $(BUILD)/poly $(BUILD)/hello $(BUILD)/hello-static $(BUILD)/linked
$(BUILD):
	mkdir -p $@
$(BUILD)/%.o: linux/%.s | $(BUILD)
	$(AS_RV) $(ARCH) -g -o $@ $<
$(BUILD)/first: $(BUILD)/first.o
	$(LD_RV) -e _start -o $@ $<
$(BUILD)/poly: $(BUILD)/poly.o
	$(LD_RV) -e _start -o $@ $<
$(BUILD)/linked: $(BUILD)/first.o $(BUILD)/layout.o $(BUILD)/reloc.o
	$(LD_RV) -e _start -o $@ $^
$(BUILD)/hello: linux/hello.c | $(BUILD)
	$(CC_RV) -march=rv64gc -mabi=lp64d -g -O0 $< -o $@
$(BUILD)/hello-static: linux/hello.c | $(BUILD)
	$(CC_RV) -march=rv64gc -mabi=lp64d -g -O0 -static $< -o $@
check-linux: linux
	@status=0; $(QEMU) $(BUILD)/first || status=$$?; test $$status -eq 42
	@status=0; $(QEMU) $(BUILD)/poly || status=$$?; test $$status -eq 41
	@status=0; $(QEMU) $(BUILD)/linked || status=$$?; test $$status -eq 42
	@test "$$($(QEMU) -L /usr/riscv64-linux-gnu $(BUILD)/hello)" = 'Hello, RISC-V!'
	@test "$$($(QEMU) $(BUILD)/hello-static)" = 'Hello, RISC-V!'
	@echo 'OK: 5 Linux programs'
inspect: $(BUILD)/first $(BUILD)/linked
	file $(BUILD)/first.o $(BUILD)/first
	$(READELF) -h $(BUILD)/first
	$(READELF) -A $(BUILD)/first
	$(OBJDUMP) -dr -M no-aliases $(BUILD)/first.o
	$(READELF) -SW $(BUILD)/layout.o
	$(READELF) -sW $(BUILD)/layout.o
	$(READELF) -rW $(BUILD)/reloc.o
	$(READELF) -sW $(BUILD)/linked
	$(READELF) -lW $(BUILD)/linked
sections: $(BUILD)/data_big.o $(BUILD)/bss_big.o
	ls -l $^
	$(CROSS)size $^
	$(READELF) -SW $^
$(BUILD)/extensions.o: linux/extensions.s | $(BUILD)
	$(AS_RV) -march=rv64im_zba_zbb_zbs -mabi=lp64 -o $@ $<
extensions: $(BUILD)/extensions.o
	$(OBJDUMP) -d $<
	$(READELF) -A $<
rars:
	$(JAVA) -jar "$(RARS_JAR)"
check-rars:
	JAVA="$(JAVA)" RARS_JAR="$(RARS_JAR)" bash tools/check-rars.sh
clean:
	rm -rf $(BUILD)
