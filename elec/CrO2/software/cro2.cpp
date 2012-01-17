/* Name: powerSwitch.c
 * Project: PowerSwitch based on AVR USB driver
 * Author: Christian Starkjohann
 * Creation Date: 2005-01-16
 * Tabsize: 4
 * Copyright: (c) 2005 by OBJECTIVE DEVELOPMENT Software GmbH
 * License: GNU GPL v2 (see License.txt) or proprietary (CommercialLicense.txt)
 * This Revision: $Id: powerSwitch.c 472 2008-01-21 18:21:59Z cs $
 */

/*
General Description:
This program controls the PowerSwitch USB device from the command line.
It must be linked with libusb, a library for accessing the USB bus from
Linux, FreeBSD, Mac OS X and other Unix operating systems. Libusb can be
obtained from http://libusb.sourceforge.net/.
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

#include <lusb0_usb.h>    /* this is libusb, see http://libusb.sourceforge.net/ */

#define USBDEV_SHARED_VENDOR    0x16C0  /* VOTI */
#define USBDEV_SHARED_PRODUCT   0x05DC  /* Obdev's free shared PID */
/* Use obdev's generic shared VID/PID pair and follow the rules outlined
 * in firmware/usbdrv/USBID-License.txt.
 */

#define VENDORSTRING "pulkomandy.ath.cx"
#define PRODUCTSTRING "CrO2"

/* These are the vendor specific SETUP commands implemented by our USB device */
#define PSCMD_CONFIG  0
#define PSCMD_GET   1
#define PSCMD_PUT   2
#define PSCMD_STATUS   3

static void usage(char *name)
{
    fprintf(stderr, "usage:\n");
    fprintf(stderr, "  %s status\n", name);
    fprintf(stderr, "  %s on <port> [<duration>]\n", name);
    fprintf(stderr, "  %s off <port> [<duration>]\n", name);
    fprintf(stderr, "  %s test\n\n", name);
    fprintf(stderr, "Ports are single digits in the range 0...7\n");
    fprintf(stderr, "The pulse duration for switching temporarily is given in seconds.\n");
}


static int  usbGetStringAscii(usb_dev_handle *dev, int index, int langid, char *buf, int buflen)
{
char    buffer[256];
int     rval, i;

    if((rval = usb_control_msg(dev, USB_ENDPOINT_IN, USB_REQ_GET_DESCRIPTOR, (USB_DT_STRING << 8) + index, langid, buffer, sizeof(buffer), 1000)) < 0)
        return rval;
    if(buffer[1] != USB_DT_STRING)
        return 0;
    if((unsigned char)buffer[0] < rval)
        rval = (unsigned char)buffer[0];
    rval /= 2;
    /* lossy conversion to ISO Latin1 */
    for(i=1;i<rval;i++){
        if(i > buflen)  /* destination buffer overflow */
            break;
        buf[i-1] = buffer[2 * i];
        if(buffer[2 * i + 1] != 0)  /* outside of ISO Latin1 range */
            buf[i-1] = '?';
    }
    buf[i-1] = 0;
    return i-1;
}


/* PowerSwitch uses the free shared default VID/PID. If you want to see an
 * example device lookup where an individually reserved PID is used, see our
 * RemoteSensor reference implementation.
 */

#define USB_ERROR_NOTFOUND  1
#define USB_ERROR_ACCESS    2
#define USB_ERROR_IO        3

static int usbOpenDevice(usb_dev_handle **device, int vendor, char *vendorName, int product, char *productName)
{
struct usb_bus      *bus;
struct usb_device   *dev;
usb_dev_handle      *handle = NULL;
int                 errorCode = USB_ERROR_NOTFOUND;
static int          didUsbInit = 0;

    if(!didUsbInit){
        didUsbInit = 1;
        usb_init();
    }
    usb_find_busses();
    usb_find_devices();
    for(bus=usb_get_busses(); bus; bus=bus->next){
        for(dev=bus->devices; dev; dev=dev->next){
            if(dev->descriptor.idVendor == vendor && dev->descriptor.idProduct == product){
                char    string[256];
                int     len;
                handle = usb_open(dev); /* we need to open the device in order to query strings */
                if(!handle){
                    errorCode = USB_ERROR_ACCESS;
                    fprintf(stderr, "Warning: cannot open USB device: %s\n", usb_strerror());
                    continue;
                }
                if(vendorName == NULL && productName == NULL){  /* name does not matter */
                    break;
                }
                /* now check whether the names match: */
                len = usbGetStringAscii(handle, dev->descriptor.iManufacturer, 0x0409, string, sizeof(string));
                if(len < 0){
                    errorCode = USB_ERROR_IO;
                    fprintf(stderr, "Warning: cannot query manufacturer for device: %s\n", usb_strerror());
                }else{
                    errorCode = USB_ERROR_NOTFOUND;
                    /* fprintf(stderr, "seen device from vendor ->%s<-\n", string); */
                    if(strcmp(string, vendorName) == 0){
                        len = usbGetStringAscii(handle, dev->descriptor.iProduct, 0x0409, string, sizeof(string));
                        if(len < 0){
                            errorCode = USB_ERROR_IO;
                            fprintf(stderr, "Warning: cannot query product for device: %s\n", usb_strerror());
                        }else{
                            errorCode = USB_ERROR_NOTFOUND;
                            /* fprintf(stderr, "seen product ->%s<-\n", string); */
                            if(strcmp(string, productName) == 0)
                                break;
                        }
                    }
                }
                usb_close(handle);
                handle = NULL;
            }
        }
        if(handle)
            break;
    }
    if(handle != NULL){
        errorCode = 0;
        *device = handle;
    }
    return errorCode;
}

void hexdump(unsigned char* bytes, int len)
{
	for(int i = 0; i <len; i++)
		printf("%X ",bytes[i]);
	puts("");
}

int main(int argc, char **argv)
{
usb_dev_handle      *handle = NULL;
unsigned char       buffer[275];
int                 nBytes;

    if(argc < 2){
        usage(argv[0]);
        exit(1);
    }
    usb_init();
    if(usbOpenDevice(&handle, USBDEV_SHARED_VENDOR, VENDORSTRING, USBDEV_SHARED_PRODUCT, PRODUCTSTRING) != 0){
        fprintf(stderr, "Could not find USB device \""PRODUCTSTRING"\" with vid=0x%x pid=0x%x\n", USBDEV_SHARED_VENDOR, USBDEV_SHARED_PRODUCT);
        exit(1);
    }
/* We have searched all devices on all busses for our USB device above. Now
 * try to open it and perform the vendor specific control operations for the
 * function requested by the user.
 */
    if(strcmp(argv[1], "get") == 0){
		memset(buffer, 0, 275);
		nBytes = usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN, PSCMD_GET, 0,0, (char*)buffer, 200, 5000);
		hexdump(buffer, sizeof(buffer));
    }else if(strcmp(argv[1], "put") == 0){

		do
		{
			// Wait for motor on
			nBytes = usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | USB_ENDPOINT_IN, PSCMD_STATUS, 0,0, (char*)buffer, 1, 5000);
			usleep(1000000);
		} while (buffer[0] & 8);


		FILE* fptr = fopen(argv[2], "rb");
		int blockid;
		uint8_t blktype, blksize;
		sscanf(argv[3], "%d", &blockid);

		do
		{
			do
			{
				fread(&blktype, 1, 1, fptr);
				if (feof(fptr))
				{
					fprintf(stderr, "end of file.\n");
					fclose(fptr);
					usb_close(handle);
					exit(0);
				}
			}
			while(blktype != 0x5A); // skip sync header

			fread(&blktype, 1, 1, fptr);
			fread(&blksize, 1, 1, fptr);
			blksize -= 2;
			fread(buffer, 1, blksize + 1, fptr);
			if (blktype == 0)
			{
				// new file
				printf("%.11s\n",buffer);
			}
		}
		while (blockid --);

		fclose(fptr);

		hexdump(buffer, blksize);
		int rqtype = (blksize == 0) ? USB_ENDPOINT_IN:USB_ENDPOINT_OUT;
		nBytes = usb_control_msg(handle, USB_TYPE_VENDOR | USB_RECIP_DEVICE | rqtype, PSCMD_PUT, blktype,0 /*checksum*/, (char*)buffer, blksize, 5000);
    }else{
		fprintf(stderr,"Unknown command: %s.\n", argv[1]);
		usage(argv[0]);
		nBytes = 0;
		// TODO manage return code
    }

	if (nBytes < 0) fprintf(stderr, "USB error %s\n", usb_strerror());
    usb_close(handle);
    return 0;
}

