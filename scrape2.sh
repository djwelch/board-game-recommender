#!/bin/bash
set -e

data_dir="data"
output_dir="$data_dir/output"
total_lines=`cat $data_dir/sitemap_geekitems_boardgame.xml | wc -l`
start_offset=0
if [[ -f $data_dir/last_offset ]]; then
  start_offset=$((`cat $data_dir/last_offset` + 0))
fi

limit=10

for (( offset=start_offset; offset<$total_lines; offset=offset+$limit ))
do
  ids=`cat data/sitemap_geekitems_boardgame.xml | tail -n +$offset | head -$limit | parallel --no-notice --colsep '/' echo {5} | awk -vORS=, '{ print $1 }' | sed 's/,$/\n/'`
  url="https://www.boardgamegeek.com/xmlapi/boardgame/$ids?stats=1&comments=1"

  curl -s -A "$user_agent" -o $output_dir/$offset.xml $url

  echo $offset > $data_dir/last_offset
  sleep 20
done




