
# Panic error code meaning:                                     
#### Author: TheStr3ak5

CKA has 2 panic functions, one arch dependent and that is used in booting: 
```c
void low_panic(int errorcode);
```
declared in "lowpanic.c"
and one that is used by the main kernel and is arch-independent: 
```c
void panic(int errorcode);
```
declared in "highpanic.c"

low_panic error codes:

|Error code | Reason                               | Cause                                        | Solution:                    |
|:---------:|:-------------------------------------|:---------------------------------------------|:-----------------------------|
|1          | Processor has not SSE/SSE2 (cpuid).  | Is a hardware fault, CKA is not responsible. | No apparent solution for CKA.|
|3          | GDT Entry making failed.             | A resource related to GDT ran out            | Restart the system.          |
|7          | System does not support IA32e paging.| Is a hardware fault, CKA is not responsible. | No apparent solution for CKA.|

panic error codes:

|Error code | Reason                               | Cause                                        | Solution:                    |
|:---------:|:-------------------------------------|:---------------------------------------------|:-----------------------------|
|1          | Kernel reached the end of kernel_main| The kernel_main function jumped to end       |Restart or reinstall *1       |

*1 = If restarting does not fix the issue, and this issue is maintained over time, maybe it has something to do with a faulty build.
