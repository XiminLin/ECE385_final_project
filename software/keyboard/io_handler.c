//io_handler.c
#include "io_handler.h"
#include <stdio.h>
#include "alt_types.h"
#include "system.h"

#define otg_hpi_address		(volatile int*) 	OTG_HPI_ADDRESS_BASE
#define otg_hpi_data		(volatile int*)	    OTG_HPI_DATA_BASE
#define otg_hpi_r			(volatile char*)	OTG_HPI_R_BASE
#define otg_hpi_cs			(volatile char*)	OTG_HPI_CS_BASE //FOR SOME REASON CS BASE BEHAVES WEIRDLY MIGHT HAVE TO SET MANUALLY
#define otg_hpi_w			(volatile char*)	OTG_HPI_W_BASE


void IO_init(void)
{
	*otg_hpi_cs = 1;
	*otg_hpi_r = 1;
	*otg_hpi_w = 1;
	*otg_hpi_address = 0;
//	printf("before init otg_hpi_data = %x\n", *otg_hpi_data);
	*otg_hpi_data = 0;
//	printf("after  init otg_hpi_data = %x\n", *otg_hpi_data);
}

void IO_write(alt_u8 Address, alt_u16 Data)
{
//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	*otg_hpi_r 		 = 1;
	*otg_hpi_address = Address & 0x3;
	*otg_hpi_data	 = Data;
//	printf("Data = %x\n", Data & 0xffff);
//	printf("Address = %x\n", Address & 0x3);
	*otg_hpi_cs 	 = 0;

	*otg_hpi_w		 = 0;

//	printf("otg_hpi_data = %x\n", *otg_hpi_data & 0xffff);
//	printf("otg_hpi_address = %x\n", *otg_hpi_address & 0x3);

	*otg_hpi_w 		 = 1;
	*otg_hpi_cs 	 = 1;
}

alt_u16 IO_read(alt_u8 Address)
{
	volatile alt_u16 temp;

//*************************************************************************//
//									TASK								   //
//*************************************************************************//
//							Write this function							   //
//*************************************************************************//
	*otg_hpi_w 		 = 1;
	*otg_hpi_address = Address & 0x3;
	*otg_hpi_cs 	 = 0;
	*otg_hpi_r		 = 0;

//	printf("IO_read Address = %x\n", Address & 0x3);
//	printf("IO_read otg_hpi_address = %x\n", *otg_hpi_address & 0x3);
//	printf("IO_read otg_hpi_data = %x\n", *otg_hpi_data & 0xffff);

	temp 	 		 = *otg_hpi_data & 0xffff;

	*otg_hpi_r 	 	 = 1;
	*otg_hpi_cs 	 = 1;
	return temp;
}
