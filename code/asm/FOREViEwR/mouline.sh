#!sh
png2mo5 -m 40c -t $1 final.scr
binxploder final.scr
exoraw -b -o FORME.dat final.scr.01
exoraw -b -o COLOR.dat final.scr.03

echo "ASSEMBLING..."
echo "============="
lwasm loader.s

echo "DISK IMAGE"
echo "=========="
mv a.out E.BIN

rm ${1}.sap
sapfs -c ${1}.sap
sapfs -f ${1}.sap
sapfs -a ${1}.sap E.BIN

saptofd ${1}.sap
cp ${1}.fd ../../../../dcto8d/

rm final.scr* *.dat *.sap
