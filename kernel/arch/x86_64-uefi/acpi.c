// File: acpi.c
//
// Description: Rescues the acpi tables and returns the info
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "acpi.h"

KABI struct XSDTHeader* find_acpi_table(const struct uefi *uefi, uint8_t signature[4])
{
	EFI_GUID acpi_guid = EFI_ACPI_TABLE_GUID;
	
	struct RSDP* acpi_table = find_configuration_table(uefi, &acpi_guid);
	struct XSDTHeader* xsdt_table = (struct XSDTHeader *)acpi_table->xsdt;
	uint64_t* xsdt_table_data = (uint64_t *)(xsdt_table + 1);
	uint64_t xsdt_entries = (xsdt_table->length - sizeof(struct XSDTHeader)) / 8;
	
	for(int i = 0; i < xsdt_entries; i++, xsdt_table_data++) {
		struct XSDTHeader* descr_table = (struct XSDTHeader *)*xsdt_table_data;
		if(memcmp(descr_table->signature, signature, 4) == 0) return descr_table;
    	}
	
	return NULL;
}
