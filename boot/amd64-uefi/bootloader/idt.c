#include <idt.h>

void idt_load()
{
	/* Load the IDT */
	asm volatile ("lidt %0" :: "m"(idtr));
}

void idt_init()
{
	idtr.base = (uint64_t) base;
	idtr.limit = (sizeof(idtentry_t) * 256) - 1;

	/* memset(&idt, 0, sizeof(idt)); */

	/* Until we don't have memset */
	for(size_t i = 0; i < 256; i++) {
		idt[i].low = 0;
		idt[i].mid = 0;
		idt[i].high = 0;
		idt[i].sel = 0;
		idt[i].flags = 0;
		idt[i].ist = 0;
		idt[i].null = 0;
	}

	/* Set any idt gates over here! */

	idt_load();
}

void idt_set_gate(uint8_t n, uint64_t base, uint16_t sel, uint8_t flags)
{
	idt[n].base = base & 0xFFFF;				/* Set the base entry */
	idt[n].mid = (base >> 16) & 0xFFFF;			/* Set the mid entry */
	idt[n].hight = (base >> 32) & 0xFFFFFFFF;	/* Set the high entry */
	
	idt[n].sel = sel;
	idt[n].flags = flags;

	idt[n].ist = 0;
	idt[n].null = 0;
}
