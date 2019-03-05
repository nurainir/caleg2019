# author : Nur Aini Rakhmawati
# License : Apache 
# February 2019
# Cara menjalankan: ./dpr.sh linkdpr
# peringatan: gunakan dengan bijaksana tanpa membebani server 
filename=$1
n=1
echo "dapil;partai;nama;jk;lokasi;umur;agama;nikah;pasangan;pendidikan;pekerjaan;status;motivasi;target" > hasildpr.csv
while read line; do
	echo "Line No. $n : $line"
	n=$((n+1))
	curl -k -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)" -o temp -L --silent  --connect-timeout 20 "$line" > /dev/null
	daerah=`echo $line |cut -d/ -f 5`
	if [[ -f temp ]]; then
		awk '/odd/,/tbody/' temp > temp1
		sed 's/<a href=\"//g' temp1 > temp
		sed 's/\" target=\"_blank\" rel=\"noopener\">Detail<\/a>//g' temp > temp1
		sed -e 's/<[^>]*>//g' temp1 > temp
		grep . temp > temp1
		while read data; do
			partai=$data
			read data
			read data
			nama=$data
			read data
			jk=$data
			read data
			lokasi=$data
			read data
			url=$data
			echo "$partai;$nama;$jk;$lokasi"
			agama="-"
			nikah="-"
			pasangan="-"
			edu="-"
			kerja="-"
			status="-"
			motivasi="-"
			target="-"
			umur="-"
			curl -k -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8)" -o temp -L --silent  --connect-timeout 20 "$url/$x" > /dev/null
    			if [[ -f temp ]]; then
    				grep "col-sm-9" temp > temp2
    				jml=$(wc -l < temp2)
     				if [[ "$jml" -gt 5 ]] 
        			then
   					sed -e 's/<[^>]*>//g' temp2 | awk '{$1=$1;print}' > temp
					tahun=`awk 'NR==8' temp| cut -d "-" -f 3`
					if [[ $tahun =~ ^(19|20)\d{2}$ ]];  then
	    					umur=$((2019-$tahun))
        				else
            					umur='-'
       				 	fi
					echo $tahun
					agama=`awk 'NR==10' temp`
					nikah=`awk 'NR==11' temp`
					pasangan=`awk 'NR==12' temp`
 					edu=`awk 'NR==15' temp`
 					kerja=`awk 'NR==16' temp`
					status=`awk 'NR==17' temp`
 					motivasi=`awk 'NR==18' temp`
 					target=`awk 'NR==19' temp`
					rm temp temp2
				fi
     			fi
			echo "$daerah;$partai;$nama;$jk;$lokasi;$tahun;$agama;$nikah;$pasangan;$edu;$kerja;$status;$motivasi;$target" >> hasildpr.csv
			sleep 1
		done < temp1
		rm temp1 temp temp2
	fi
done < $filename
