# Interrupts:
#### Author: TheStr3ak5

In CKA, the interrupt initialization and some of them are arch-dependent, that 
means that the setup method and the content of the handlers of these 
interrupts will vary between targets and builds.

In our kernel model, the main kernel should use only arch-independent 
constructions, in order to ease portability and other reasons that are treated 
in other documentation. 

For this purpose, the kernel will use an arch-independent interrupt layout, 
but with arch-dependent contents, with this, we can use the things that every 
architecture provides without sacrificing the arch-independence of our 
main kernel.
This documentation is dedicated to defining the order, number, disposition and 
behaviour of these interrupts in order to provide an arch-independent 
interface, necessary for our kernel. 
