#!/bin/bash
ServiceCenter=`cat ServiceCenter.h`

lines=`awk '{print NR}' ServiceCenter.h|tail -n1`
echo $lines
rm -rf note.xml
echo "<?xml version="1.0" encoding="utf-8"?>" >> note.xml

echo "" >>note.xml

echo "<resource>">>note.xml
echo "">>note.xml
for ((i=1;i<=$lines;i++))
    do
        center_name=`sed -n ${i}p ServiceCenter.h`
        nums=`sed -n ${i}p ContactNo.h`   
        add=`sed -n ${i}p Address.h`
        echo "  <center>" >> note.xml
            echo "      <name>${center_name}</name>" >> note.xml
            echo "      <numbers>${nums}</numbers>" >> note.xml
            echo "      <address>${add}</address>" >> note.xml
        echo "  </center>" >> note.xml
        echo "" >> note.xml
    done
echo "</resource>">>note.xml
cat note.xml    