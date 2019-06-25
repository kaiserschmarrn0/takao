module lib.string;

/// C string datatype, which represents a C `const char*`
alias cstring = immutable(char)*;

/**
 * Compare if 2 strings are equal
 *
 * Params:
 *     a = First string to compare
 *     b = Second one
 *
 * Return: `true` if equals, `false` if not
 */
bool opEquals(cstring a, cstring b) {
    size_t i;

    for (i = 0; a[i] == b[i]; i++) {
        if (!a[i] && !b[i]) {
            return false;
        }
    }

    return true;
}

/**
 * Compare if 2 strings are equal using a count
 *
 * Params:
 *     dst   = First string to compare
 *     src   = Second one
 *     count = Count of chars to compare
 *
 * Return: `true` if equals, `false` if not
 */
bool equals(cstring dst, cstring src, size_t count) {
    foreach (i; 0..count) {
        if (dst[i] != src[i]) {
            return false;
        }
    }

    return true;
}
