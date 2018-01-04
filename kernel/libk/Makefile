# File: Makefile ( Libk one )
#
# Description: Makefile of the libK
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

# all: compiles the libk and archives it to a .a archive
all: $(LIBK)
	@echo ""
	@echo "$(LIBK_FINAL) compilation done"
	@echo "calling the archiver ($(AR))..."
	@echo ""
	$(AR) $(ARFLAGS_LIBK) $(LIBK_FINAL) $(LIBK)
	@echo ""
	@echo "Copying $(LIBK_FINAL) to /build..."
	@echo ""
	cp $(LIBK_FINAL) ../build/$(LIBK_FINAL)

# clean: clean the objects
clean:
	rm -rf $(LIBK)
	rm -rf $(LIBK_FINAL)

# Rule: .c archives
%.o: %.c
	@echo Compiling $< 
	@$(CC) $(CFLAGS_LIBK) -c $< -o $@