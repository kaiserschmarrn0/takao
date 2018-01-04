# File: Makefile ( Main function one )
#
# Description: Makefile of the main function
#
# License: GNU GPL v2, check LICENSE file under the distributed package for details.

# all: compiles the main.c to main,o
all: $(MAIN)
	@echo ""
	@echo "$(MAIN_FINAL) compilation done"
	@echo ""
	@echo "Copying $(MAIN_FINAL) to /build..."
	@echo ""
	cp $(MAIN_FINAL) ../build/$(MAIN_FINAL)

# clean: clean the objects
clean:
	rm -rf $(MAIN)
	rm -rf $(MAIN_FINAL)

# Rule: .c archives
%.o: %.c
	@echo Compiling $< 
	@$(CC) $(CFLAGS_MAIN) -c $< -o $@