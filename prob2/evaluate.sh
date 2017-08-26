#!/bin/bash
for i in $@; do
option="$(cut -d'=' -f1 <<<"$i")";
if [ "$option" == "--Mdir" ]; then
mdir="$(cut -d'=' -f2 <<<"$i")";
elif [ "$option" == "--E" ]; then
e_loc="$(cut -d'=' -f2 <<<"$i")";
elif [ "$option" == "--T" ]; then
t_loc="$(cut -d'=' -f2 <<<"$i")";

elif [ "$option" == "--G" ]; then
g_loc="$(cut -d'=' -f2 <<<"$i")";
else
dev="$(cut -d'=' -f1 <<<"$i")";
fi
done;
`fstinvert "$t_loc" > tinv.fst`
c_spell=`awk '{print $2}' "$dev"`
id=$(awk '{ORS="\n";print $1}' "$dev")
read -ra id -d '' <<<"${id[0]}"
#echo ${arr[3]}
read -ra c_spell -d '' <<<"${c_spell[0]}"
echo "Read files"
#`fstminimize "$e_loc" > "$e_loc"`
#m=`fstarcsort -sort_type=olabel "$m" > tempm.fst`
e=`fstarcsort -sort_type=ilabel "$e_loc" > tempe.fst`
t_i=`fstarcsort -sort_type=ilabel tinv.fst > temptinv.fst`
g=`fstarcsort -sort_type=ilabel "$g_loc" > tempg.fst`
echo $t_i $g
`fstcompose temptinv.fst tempg.fst > tng.fst`
`fstcompose tempe.fst tng.fst > entng.fst`
echo "Before loop"
correct=0;
incorrect=0;
for ((j=0;j<${#c_spell[@]};j++)); do
#echo "0 " "$cnt"" $j " "${j:0:1}" > ~/m.sh
echo "--------------------------------------------------------"
file=$mdir/${id[$j]}.fsa
`fstcompose "$file" entng.fst > "${id[$j]}".ffsa`
#`fstcompose "$m" "$e" |  fstcompose - "$t_i"| fstcompose - "$g_loc" "$id".fst`
echo "ID: " ${id[$j]} "Done"
`fstshortestpath "${id[$j]}".ffsa >  "${id[$j]}".sp`
`fstprint --isymbols=lets.vocab -osymbols=words.vocab "${id[$j]}".sp > "${id[$j]}".pred_word`
`rm "${id[$j]}".ffsa`
pred=`awk 'NR<2 {print $4}' "${id[$j]}".pred_word`;
echo "Predicted Word: " $pred " Correct spelling: " ${c_spell[$j]};
if [ "$pred" == "${c_spell[$j]}" ];then
echo "Match !"
correct=$((correct+1));
else
echo "different"
incorrect=$((incorrect+1));
fi
`rm "${id[$j]}".pred_word`
`rm "${id[$j]}".sp`
done;
echo "---------------------------------------------------------"

echo "Processing Completed"
echo "Correct count: "$correct " Incorrect count: "$incorrect;
acc=`bc -l <<< "$correct"/"$((correct+incorrect))"`
echo "Accuracy = ""`bc -l <<< "$correct"/100`"
