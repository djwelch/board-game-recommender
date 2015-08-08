#!/bin/bash
set -e

user_agent="iMacAppStore/1.0.1 (Macintosh; U; Intel Mac OS X 10.6.7; en) AppleWebKit/533.20.25" 
dir=1
output_dir="output"
if [[ ! -d $output_dir ]] ; then mkdir -p $output_dir ; fi
offset=1
limit=1
total_lines=`cat sitemap_geekitems_boardgame.xml | wc -l`
start_offset=$((`find output -type f -name "*.xml" | wc -l` + 1))
dir=$start_offset
if [[ $dir -lt 1 ]] ; then dir=1;start_offset=1 ; fi

echo $start_offset-$total_lines starting at dir $dir

dirn=`printf "%06d" $dir`
if [[ ! -d $output_dir/$dirn ]] ; then mkdir $output_dir/$dirn ; fi

bad=`find $output_dir/ -name '*.xml' -size -1000c -printf "%p %s\n" | sort | wc -l`
for (( offset=start_offset; offset<=$total_lines; offset=offset+$limit ))
do
	output_dir_count="`ls -1 $output_dir/$dirn | wc -l`"
	echo $offset
	if ! (($offset % 3)); then
		echo "Sleeping a bit"
		sleep 1
	fi
	bad2=`find $output_dir/ -name '*.xml' -size -1000c -printf "%p %s\n" | sort | wc -l`
	if [[ $bad -ne $bad2 ]]; then
		bad=$bad2
		echo "$bad bad ones"
	fi

	if [[ $output_dir_count -gt 100 ]]
	then
		sleep 1
		dir=$offset
		dirn=`printf "%06d" $dir`
		echo $dirn
	fi
	if [[ ! -d $output_dir/$dirn ]] ; then mkdir $output_dir/$dirn ; fi
	cat sitemap_geekitems_boardgame.xml | tail -n +$offset | head -$limit | parallel --colsep '/' curl -s -A \"$user_agent\" -o $output_dir/$dirn/\$\(printf "%09d" {5}\)-{6}.xml \"https://www.boardgamegeek.com/xmlapi/boardgame/{5}?stats=1\&comments=1\"
	sleep 1
done

