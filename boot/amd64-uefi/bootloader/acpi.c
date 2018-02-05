// File: acpi.c
//
// Description: ACPI things
//
// License: GNU GPL v2, check LICENSE file under the distributed package for details.

#include "acpi.h"

int acpi_memcmp(const void *d1, const void *d2, uint64_t len);

struct XSDTHeader* find_acpi_table(const struct uefi *uefi, uint8_t signature[4])
{
	EFI_GUID acpi_guid = EFI_ACPI_TABLE_GUID;

	struct RSDP* acpi_table = find_configuration_table(uefi, &acpi_guid);
	struct XSDTHeader* xsdt_table = (struct XSDTHeader *)acpi_table->xsdt;
	
	uint64_t* xsdt_table_data = (uint64_t *)(xsdt_table + 1);
	uint64_t xsdt_entries = (xsdt_table->length - sizeof(struct XSDTHeader)) / 8;
	
	for(int i = 0; i < xsdt_entries; i++, xsdt_table_data++) {
		struct XSDTHeader* descr_table = (struct XSDTHeader *)*xsdt_table_data;
		if(acpi_memcmp(descr_table->signature, signature, 4) == 0) return descr_table;
	}
	return NULL;
}

int acpi_memcmp(const void *d1, const void *d2, uint64_t len)
{
	const uint8_t *d1_ = d1, *d2_ = d2;
	for(uint64_t i = 0; i < len; i += 1, d1_++, d2_++){
		if(*d1_ != *d2_) return *d1_ < *d2_ ? -1 : 1;
	}
	return 0;
}