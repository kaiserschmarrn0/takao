#ifndef IDT_H
#define IDT_H

#include <stdint.h>

typedef struct {
	uint16_t low;	/* Low entry */
	uint16_t sel;	/* Selector entry */
	uint8_t ist;	/* Reserved */
	uint8_t flags;	/* Flags */
	uint16_t mid;	/* Middle entry */
	uint32_t high;	/* High entry */
	uint32_t null;
} __attribute__((packed)) idtentry_t;

typedef struct {
	uint64_t base;	/* Base address of the IDT */
	uint16_t limit;	/* Limit of the IDT */
} __attribute__((packed)) idtpointer_t;

idtpointer_t idtr;
idtentry_t idt[256];

void idt_init();
void idt_load();
void idt_set_gate(uint8_t n, uint64_t base, uint16_t sel, uint8_t flags);

#endif
