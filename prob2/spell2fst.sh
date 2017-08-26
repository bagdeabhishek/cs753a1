#!/bin/bash
for i in $@; do
option="$(cut -d'=' -f1 <<<"$i")";
if [ "$option" == "--odir" ]; then
opdir="$(cut -d'=' -f2 <<<"$i")";
elif [ "$option" == "--vocab" ]; then
vocab="$(cut -d'=' -f2 <<<"$i")";
else
ip="$(cut -d'=' -f1 <<<"$i")";
fi
done;

echo "Output directory given: " $opdir " Vocabulary file: "$vocab " input file: " $ip;
`mkdir $opdir`

let=`awk '{print $3}' "$ip"`
id=$(awk '{ORS="\n";print $1}' "$ip")
read -ra id -d '' <<<"${id[0]}"
#echo ${arr[3]}
read -ra let -d '' <<<"${let[0]}"
#${num[$i]} :${words[$i]}:
#echo ${let[0]}
#for j in $let ; do
for ((j=0;j<${#let[@]};j++)); do
#echo "0 " "$cnt"" $j " "${j:0:1}" > ~/m.sh
file=$opdir/${id[$j]}
cnt=0
for (( i=0; i<${#let[$j]}; i++ )); do
echo "$cnt ""$(($cnt + 1)) ""${let[$j]:$i:1}" "${let[$j]:$i:1}" >> $file.txt
cnt=$((cnt + 1))
done;
echo $cnt >>  $file.txt
`fstcompile --isymbols=lets.vocab --osymbols=lets.vocab $file.txt > $file.fsa`
#cnt=$((cnt + 1))
done;

