.global _start
_start:
1:
.rept   512
	c.j 1b
.endr
