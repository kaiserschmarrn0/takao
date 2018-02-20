# Error codes

Format:

```
Error code => Cause [Where its declared, absolute path starting from kernel root dir]
```

AMD64:

1 => End of the kernel function was reached [main/main.cpp]
2 => Out of memory [arch/amd64/mem/pages.cpp]
3 => Requested pages at bad level (out of 0-3) [arch/amd64/mem/pages.cpp]
4 => The kernel was requested to set a physical memory entry in a bad physical address [arch/amd64/mem/pages.cpp]
