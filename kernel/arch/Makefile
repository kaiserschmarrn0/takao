# File: Makefile ( arch-dependent )
#
# Description: Makefile of the arch dependent files
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

# all: compiles the arch dependent archives
all: $(ARCHDEPENDENT)
	@echo ""
	@echo "$(ARCHDEPENDENT_FINAL) compilation done"
	@echo ""
	@echo "calling the archiver ($(AR))..."
	@echo ""
	$(AR) $(ARFLAGS_ARCHDEPENDENT) $(ARCHDEPENDENT_FINAL) $(ARCHDEPENDENT)
	@echo "Copying $(ARCHDEPENDENT_FINAL) to /build..."
	@echo ""
	cp $(ARCHDEPENDENT_FINAL) ../build/$(ARCHDEPENDENT_FINAL)

# clean: clean the objects
clean:
	rm -rf $(ARCHDEPENDENT)
	rm -rf $(ARCHDEPENDENT_FINAL)

# Rule: .c archives
%.o: %.c
	@echo Compiling $< 
	@$(CC) $(CFLAGS_ARCHDEPENDENT) -c $< -o $@

# Rule: .S archives
%.o: %.S
	@echo Compiling $< 
	@$(CC) $(CFLAGS_ARCHDEPENDENT) -c $< -o $@