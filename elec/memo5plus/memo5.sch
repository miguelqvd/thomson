EESchema Schematic File Version 2  date 01/01/2012 21:34:43
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:dips-s
LIBS:memo5-cache
EELAYER 25  0
EELAYER END
$Descr User 6000 5000
encoding utf-8
Sheet 1 1
Title ""
Date "1 jan 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Text Label 2450 1650 0    60   ~ 0
A17
Text Label 2450 1750 0    60   ~ 0
A16
Text Label 2450 1850 0    60   ~ 0
A15
Text Label 2450 1950 0    60   ~ 0
A14
Wire Wire Line
	3000 2100 3000 1650
Wire Wire Line
	1850 1950 2050 1950
Wire Wire Line
	1850 1850 2050 1850
Wire Wire Line
	1850 1750 2050 1750
Wire Wire Line
	1850 1650 2050 1650
Connection ~ 3000 1750
Wire Wire Line
	3000 1650 2850 1650
Connection ~ 3000 1950
Wire Wire Line
	3000 1850 2850 1850
Wire Wire Line
	3900 2900 3900 3050
Wire Wire Line
	550  700  700  700 
Wire Wire Line
	550  2000 550  1900
Wire Wire Line
	550  1900 700  1900
Wire Wire Line
	700  700  700  800 
Wire Wire Line
	3000 1950 2850 1950
Wire Wire Line
	3000 1750 2850 1750
Connection ~ 3000 1850
Connection ~ 3000 1650
$Comp
L DIPS_04 SW1
U 1 1 4F00C0D0
P 2650 1800
F 0 "SW1" V 2400 1800 60  0000 C CNN
F 1 "DIPS_04" V 2900 1800 60  0000 C CNN
	1    2650 1800
	0    1    1    0   
$EndComp
$Comp
L VCC #PWR01
U 1 1 4EF4CCD1
P 3900 2500
F 0 "#PWR01" H 3900 2600 30  0001 C CNN
F 1 "VCC" H 3900 2600 30  0000 C CNN
	1    3900 2500
	0    -1   -1   0   
$EndComp
$Comp
L VCC #PWR02
U 1 1 4EF4CBD7
P 2100 2550
F 0 "#PWR02" H 2100 2650 30  0001 C CNN
F 1 "VCC" H 2100 2650 30  0000 C CNN
	1    2100 2550
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 4EF4CBD1
P 2100 2950
F 0 "#PWR03" H 2100 2950 30  0001 C CNN
F 1 "GND" H 2100 2880 30  0001 C CNN
	1    2100 2950
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4EF4CBCA
P 2100 2750
F 0 "C1" H 2150 2850 50  0000 L CNN
F 1 "C" H 2150 2650 50  0000 L CNN
	1    2100 2750
	1    0    0    -1  
$EndComp
$Comp
L RR8 RR1
U 1 1 4EF4C2C0
P 1500 1500
F 0 "RR1" H 1550 2050 70  0000 C CNN
F 1 "RR8" V 1530 1500 70  0000 C CNN
	1    1500 1500
	-1   0    0    1   
$EndComp
$Comp
L VCC #PWR04
U 1 1 4EF4C2A4
P 1850 1150
F 0 "#PWR04" H 1850 1250 30  0001 C CNN
F 1 "VCC" H 1850 1250 30  0000 C CNN
	1    1850 1150
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR05
U 1 1 4EF4C29D
P 3000 2100
F 0 "#PWR05" H 3000 2100 30  0001 C CNN
F 1 "GND" H 3000 2030 30  0001 C CNN
	1    3000 2100
	1    0    0    -1  
$EndComp
Text Label 2050 1950 0    60   ~ 0
A17
Text Label 2050 1850 0    60   ~ 0
A16
Text Label 2050 1750 0    60   ~ 0
A15
Text Label 2050 1650 0    60   ~ 0
A14
$Comp
L GND #PWR06
U 1 1 4EF4AD59
P 3900 3050
F 0 "#PWR06" H 3900 3050 30  0001 C CNN
F 1 "GND" H 3900 2980 30  0001 C CNN
	1    3900 3050
	1    0    0    -1  
$EndComp
Text Label 3900 2800 0    60   ~ 0
/CS
Text Label 700  1000 0    60   ~ 0
/CS
Text Label 700  900  0    60   ~ 0
A13
$Comp
L GND #PWR07
U 1 1 4EF4ACD8
P 550 2000
F 0 "#PWR07" H 550 2000 30  0001 C CNN
F 1 "GND" H 550 1930 30  0001 C CNN
	1    550  2000
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR08
U 1 1 4EF4ACC9
P 550 700
F 0 "#PWR08" H 550 800 30  0001 C CNN
F 1 "VCC" H 550 800 30  0000 C CNN
	1    550  700 
	1    0    0    -1  
$EndComp
Text Label 700  1100 0    60   ~ 0
D7
Text Label 700  1200 0    60   ~ 0
D6
Text Label 700  1300 0    60   ~ 0
D5
Text Label 700  1400 0    60   ~ 0
D4
Text Label 700  1500 0    60   ~ 0
D3
Text Label 700  1600 0    60   ~ 0
D2
Text Label 700  1700 0    60   ~ 0
D1
Text Label 700  1800 0    60   ~ 0
D0
Text Label 700  2200 0    60   ~ 0
A12
Text Label 700  2300 0    60   ~ 0
A11
Text Label 700  2400 0    60   ~ 0
A10
Text Label 700  2500 0    60   ~ 0
A9
Text Label 700  2600 0    60   ~ 0
A8
Text Label 700  2700 0    60   ~ 0
A7
Text Label 700  2800 0    60   ~ 0
A6
Text Label 700  2900 0    60   ~ 0
A5
Text Label 700  3000 0    60   ~ 0
A4
Text Label 700  3100 0    60   ~ 0
A3
Text Label 700  3200 0    60   ~ 0
A2
Text Label 700  3300 0    60   ~ 0
A1
Text Label 700  3400 0    60   ~ 0
A0
NoConn ~ 700  3500
NoConn ~ 700  2100
NoConn ~ 700  2000
NoConn ~ 700  600 
Text Label 3900 2400 0    60   ~ 0
A17
Text Label 3900 2300 0    60   ~ 0
A16
Text Label 3900 2200 0    60   ~ 0
A15
Text Label 3900 2100 0    60   ~ 0
A14
Text Label 3900 2000 0    60   ~ 0
A13
Text Label 3900 1900 0    60   ~ 0
A12
Text Label 3900 1800 0    60   ~ 0
A11
Text Label 3900 1700 0    60   ~ 0
A10
Text Label 3900 1600 0    60   ~ 0
A9
Text Label 3900 1500 0    60   ~ 0
A8
Text Label 3900 1400 0    60   ~ 0
A7
Text Label 3900 1300 0    60   ~ 0
A6
Text Label 3900 1200 0    60   ~ 0
A5
Text Label 3900 1100 0    60   ~ 0
A4
Text Label 3900 1000 0    60   ~ 0
A3
Text Label 3900 900  0    60   ~ 0
A2
Text Label 3900 800  0    60   ~ 0
A1
Text Label 3900 700  0    60   ~ 0
A0
Text Label 5300 1400 0    60   ~ 0
D7
Text Label 5300 1300 0    60   ~ 0
D6
Text Label 5300 1200 0    60   ~ 0
D5
Text Label 5300 1100 0    60   ~ 0
D4
Text Label 5300 1000 0    60   ~ 0
D3
Text Label 5300 900  0    60   ~ 0
D2
Text Label 5300 800  0    60   ~ 0
D1
Text Label 5300 700  0    60   ~ 0
D0
$Comp
L CONN_30 P1
U 1 1 4EF4AB1F
P 1050 2050
F 0 "P1" V 1001 2050 60  0000 C CNN
F 1 "CONN_30" V 1100 2050 60  0000 C CNN
	1    1050 2050
	1    0    0    -1  
$EndComp
$Comp
L 27C020 U1
U 1 1 4EF4A9F7
P 4600 1600
F 0 "U1" H 4400 2600 70  0000 C CNN
F 1 "27C020" H 4600 200 70  0000 C CNN
	1    4600 1600
	1    0    0    -1  
$EndComp
$EndSCHEMATC
