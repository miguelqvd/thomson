
asm("\n"
"	.area .text \n"
"	INCLUDEBIN ../POI03.CRU \n"
"color_poi		\n"
"	INCLUDEBIN ../POI01.CRU \n"
"forme_poi		\n"
);

int init_P()
{
	asm(
		" LDX #color_poi-1		\n"
		" LDU #forme_poi-1		\n"
		" LBSR decrunchpic			\n"
		:::"x","u", "y");

	return 0;
}
