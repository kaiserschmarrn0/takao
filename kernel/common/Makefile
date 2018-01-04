# File: Makefile ( Common files )
#
# Description: Makefile of the common files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

# all: compiles the arch independent archives
all: $(ARCHINDEPENDENT)
	@echo ""
	@echo "$(ARCHINDEPENDENT_FINAL) compilation done"
	@echo ""
	@echo "calling the archiver ($(AR))..."
	@echo ""
	$(AR) $(ARFLAGS_ARCHINDEPENDENT) $(ARCHINDEPENDENT_FINAL) $(ARCHINDEPENDENT)
	@echo "Copying $(ARCHINDEPENDENT_FINAL) to /build..."
	@echo ""
	cp $(ARCHINDEPENDENT_FINAL) ../build/$(ARCHINDEPENDENT_FINAL)

# clean: clean the objects
clean:
	rm -rf $(ARCHINDEPENDENT)
	rm -rf $(ARCHINDEPENDENT_FINAL)

# Rule: .c archives
%.o: %.c
	@echo Compiling $< 
	@$(CC) $(CFLAGS_ARCHINDEPENDENT) -c $< -o $@