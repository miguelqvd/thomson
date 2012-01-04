EESchema Schematic File Version 2  date 04/01/2012 23:03:39
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
LIBS:thomson
LIBS:MegaROM-cache
EELAYER 25  0
EELAYER END
$Descr User 10699 5000
encoding utf-8
Sheet 1 1
Title ""
Date "4 jan 2012"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Wire Wire Line
	4650 1150 4650 1350
Wire Wire Line
	6750 3000 6600 3000
Wire Wire Line
	6600 3000 6600 3200
Wire Wire Line
	4650 1350 4250 1350
Wire Wire Line
	5200 3200 5200 3600
Wire Wire Line
	5200 3600 4750 3600
Wire Wire Line
	8600 2900 8600 3200
Wire Wire Line
	8600 3200 6600 3200
Connection ~ 6600 3100
Wire Wire Line
	8150 2600 8600 2600
Wire Wire Line
	8150 2500 8600 2500
Wire Wire Line
	8150 2400 8600 2400
Wire Wire Line
	8150 2300 8600 2300
Wire Wire Line
	8150 2200 8600 2200
Wire Wire Line
	8150 2100 8600 2100
Wire Wire Line
	4750 2700 5200 2700
Wire Wire Line
	5200 2700 5200 3000
Wire Wire Line
	3200 2600 3550 2600
Wire Wire Line
	6600 3100 6400 3100
Text Label 6750 3100 0    60   ~ 0
/RES
Text Label 5850 1250 0    60   ~ 0
/RES
$Comp
L GND #PWR01
U 1 1 4F036704
P 4250 1850
F 0 "#PWR01" H 4250 1850 30  0001 C CNN
F 1 "GND" H 4250 1780 30  0001 C CNN
	1    4250 1850
	1    0    0    -1  
$EndComp
$Comp
L VCC #PWR02
U 1 1 4F0366FC
P 4250 950
F 0 "#PWR02" H 4250 1050 30  0001 C CNN
F 1 "VCC" H 4250 1050 30  0000 C CNN
	1    4250 950 
	1    0    0    -1  
$EndComp
Text Label 2000 2700 0    60   ~ 0
E
Text Label 2000 2500 0    60   ~ 0
/CSN
Text Label 8600 2800 0    60   ~ 0
/CSN
Text Label 1350 3100 0    60   ~ 0
R/W
Text Label 1350 3000 0    60   ~ 0
E
Text Label 1350 2900 0    60   ~ 0
/CSN
$Comp
L GND #PWR03
U 1 1 4F03667F
P 1350 3200
F 0 "#PWR03" H 1350 3200 30  0001 C CNN
F 1 "GND" H 1350 3130 30  0001 C CNN
	1    1350 3200
	0    -1   -1   0   
$EndComp
$Comp
L VCC #PWR04
U 1 1 4F036678
P 1350 2800
F 0 "#PWR04" H 1350 2900 30  0001 C CNN
F 1 "VCC" H 1350 2900 30  0000 C CNN
	1    1350 2800
	0    1    1    0   
$EndComp
Text Label 1350 1300 0    60   ~ 0
D0
Text Label 1350 1200 0    60   ~ 0
D1
Text Label 1350 1100 0    60   ~ 0
D2
Text Label 1350 1000 0    60   ~ 0
D3
Text Label 1350 900  0    60   ~ 0
D4
Text Label 1350 800  0    60   ~ 0
D5
Text Label 1350 700  0    60   ~ 0
D6
Text Label 1350 600  0    60   ~ 0
D7
Text Label 1350 2700 0    60   ~ 0
A13
Text Label 1350 2600 0    60   ~ 0
A12
Text Label 1350 2500 0    60   ~ 0
A11
Text Label 1350 2400 0    60   ~ 0
A10
Text Label 1350 2300 0    60   ~ 0
A9
Text Label 1350 2200 0    60   ~ 0
A8
Text Label 1350 2100 0    60   ~ 0
A7
Text Label 1350 2000 0    60   ~ 0
A6
Text Label 1350 1900 0    60   ~ 0
A5
Text Label 1350 1800 0    60   ~ 0
A4
Text Label 1350 1700 0    60   ~ 0
A3
Text Label 1350 1600 0    60   ~ 0
A2
Text Label 1350 1500 0    60   ~ 0
A1
Text Label 1350 1400 0    60   ~ 0
A0
$Comp
L MEMO7 J1
U 1 1 4F036638
P 750 1850
F 0 "J1" V 750 2550 60  0000 C CNN
F 1 "MEMO7" V 750 1200 60  0000 C CNN
	1    750  1850
	1    0    0    -1  
$EndComp
Text Label 3550 2800 0    60   ~ 0
A12
Text Label 3550 4200 0    60   ~ 0
A13
Text Label 3550 3900 0    60   ~ 0
A11
Text Label 3550 3600 0    60   ~ 0
A10
Text Label 3550 4000 0    60   ~ 0
A9
Text Label 3550 4100 0    60   ~ 0
A8
Text Label 3550 3000 0    60   ~ 0
A7
Text Label 3550 3100 0    60   ~ 0
A6
Text Label 3550 3200 0    60   ~ 0
A5
Text Label 3550 3300 0    60   ~ 0
A4
Text Label 3550 3400 0    60   ~ 0
A3
Text Label 3550 3500 0    60   ~ 0
A2
Text Label 3550 3800 0    60   ~ 0
A1
Text Label 3550 3700 0    60   ~ 0
A0
Text Label 6750 2600 0    60   ~ 0
D5
Text Label 6750 2500 0    60   ~ 0
D4
Text Label 6750 2400 0    60   ~ 0
D3
Text Label 6750 2300 0    60   ~ 0
D2
Text Label 6750 2200 0    60   ~ 0
D1
Text Label 6750 2100 0    60   ~ 0
D0
Text Label 8150 2600 0    60   ~ 0
A19
Text Label 8150 2500 0    60   ~ 0
A18
Text Label 8150 2400 0    60   ~ 0
A17
Text Label 8150 2300 0    60   ~ 0
A16
Text Label 8150 2200 0    60   ~ 0
A15
Text Label 8150 2100 0    60   ~ 0
A14
Text Label 10000 1400 0    60   ~ 0
D7
Text Label 10000 1300 0    60   ~ 0
D6
Text Label 10000 1200 0    60   ~ 0
D5
Text Label 10000 1100 0    60   ~ 0
D4
Text Label 10000 1000 0    60   ~ 0
D3
Text Label 10000 900  0    60   ~ 0
D2
Text Label 10000 800  0    60   ~ 0
D1
Text Label 10000 700  0    60   ~ 0
D0
Text Label 8600 2600 0    60   ~ 0
A19
Text Label 8600 2500 0    60   ~ 0
A18
Text Label 8600 2400 0    60   ~ 0
A17
Text Label 8600 2300 0    60   ~ 0
A16
Text Label 8600 2200 0    60   ~ 0
A15
Text Label 8600 2100 0    60   ~ 0
A14
Text Label 8600 2000 0    60   ~ 0
A13
Text Label 8600 1900 0    60   ~ 0
A12
Text Label 8600 1800 0    60   ~ 0
A11
Text Label 8600 1700 0    60   ~ 0
A10
Text Label 8600 1600 0    60   ~ 0
A9
Text Label 8600 1500 0    60   ~ 0
A8
Text Label 8600 1400 0    60   ~ 0
A7
Text Label 8600 1300 0    60   ~ 0
A6
Text Label 8600 1200 0    60   ~ 0
A5
Text Label 8600 1100 0    60   ~ 0
A4
Text Label 8600 1000 0    60   ~ 0
A3
Text Label 8600 900  0    60   ~ 0
A2
Text Label 8600 800  0    60   ~ 0
A1
Text Label 8600 700  0    60   ~ 0
A0
$Comp
L R R1
U 1 1 4F0361AF
P 4250 1600
F 0 "R1" V 4330 1600 50  0000 C CNN
F 1 "R" V 4250 1600 50  0000 C CNN
	1    4250 1600
	1    0    0    -1  
$EndComp
$Comp
L C C1
U 1 1 4F0361A8
P 4250 1150
F 0 "C1" H 4300 1250 50  0000 L CNN
F 1 "C" H 4300 1050 50  0000 L CNN
	1    4250 1150
	1    0    0    -1  
$EndComp
$Comp
L 74LS373 U4
U 1 1 4F036198
P 7450 2600
F 0 "U4" H 7450 2600 60  0000 C CNN
F 1 "74LS373" H 7500 2250 60  0000 C CNN
	1    7450 2600
	1    0    0    -1  
$EndComp
$Comp
L 74LS133 U3
U 1 1 4F036181
P 4150 3600
F 0 "U3" H 4150 3700 60  0000 C CNN
F 1 "74LS133" H 4150 3500 60  0000 C CNN
	1    4150 3600
	1    0    0    -1  
$EndComp
$Comp
L 74HC02 U1
U 1 1 4F036165
P 2600 2600
F 0 "U1" H 2600 2650 60  0000 C CNN
F 1 "74HC02" H 2650 2550 60  0000 C CNN
	1    2600 2600
	1    0    0    -1  
$EndComp
$Comp
L 74HC02 U1
U 2 1 4F036160
P 5800 3100
F 0 "U1" H 5800 3150 60  0000 C CNN
F 1 "74HC02" H 5850 3050 60  0000 C CNN
	2    5800 3100
	1    0    0    -1  
$EndComp
$Comp
L 74HC00 U2
U 2 1 4F036158
P 5250 1250
F 0 "U2" H 5250 1300 60  0000 C CNN
F 1 "74HC00" H 5250 1150 60  0000 C CNN
	2    5250 1250
	1    0    0    -1  
$EndComp
$Comp
L 74HC00 U2
U 1 1 4F036155
P 4150 2700
F 0 "U2" H 4150 2750 60  0000 C CNN
F 1 "74HC00" H 4150 2600 60  0000 C CNN
	1    4150 2700
	1    0    0    -1  
$EndComp
$Comp
L 27C080 U5
U 1 1 4F036146
P 9300 1600
F 0 "U5" H 9100 2600 70  0000 C CNN
F 1 "27C080" H 9300 200 70  0000 C CNN
	1    9300 1600
	1    0    0    -1  
$EndComp
$EndSCHEMATC
