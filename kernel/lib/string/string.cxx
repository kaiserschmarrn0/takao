// string.cxx

// Description: strcat, strcmp, strcpy, strlen.

// Copyright 2018 The Takao Authors (AUTHORS.md). All rights reserved.
// Use of this source code is governed by a license that can be
// found in the LICENSE.md file, in the root directory of
// the source package.

#include "../string.hxx"

char* lib::strcat(char* dest,const char * src)
{
	char* result = dest;
	if((NULL != dest) && (NULL != src))
	{
		/* Iterate till end of dest string */
		while(NULL != *dest)
		{
			dest++;
		}
		/* Copy src string starting from the end NULL of dest */
		while(NULL != *src)
		{
			*dest++ = *src++;
		}
	/* put NULL termination */
 	*dest = NULL;
	}
	return result; 	 
}

int lib::strcmp(const char* s1, const char* s2)
{
	while(*s1 && (*s1 == *s2))
	{
		s1++;
		s2++;
	}
	return *(const unsigned char*)s1 - *(const unsigned char*)s2;
}

char* lib::strcpy(char * dest, const char * src)
{
	char* result = dest;
	if((NULL != dest) && (NULL != src))
	{
		/* Start copy src to dest */
		while (NULL != *src)
		{
			*dest++ = *src++;
		}
		/* put NULL termination */
		*dest = NULL;
	}
	return result;
 	 
}

uint64_t lib::strlen(const char *data) 
{
	uint64_t r;
	for(r = 0; *data != NULL; data++, r++);
	return r;
}
