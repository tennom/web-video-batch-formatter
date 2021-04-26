#!/bin/bash


# compress videos for web videos
for v in *.mp4; do 
    ffmpeg -i "$v" -vf scale=960:-1 -c:v libx264 -b:v 160K -maxrate 180K -bufsize 1M -b:a 98K "web/$v"
done

# make new lesson folders
for i in $(seq 0 9); do
    mkdir lesson$i; 
done
# mkdir res and vs${lesId}r1
for d in */; do 
    mkdir ${d}res; 
    mkdir ${d}vs${d:6:-1}r1; 
done
# rename videos to video.mp4 and mv to vs${lesId}r1
for l in */; do 
    mv ${l}*.mp4 ${l}vs${l:6:-1}r1/video.mp4; 
done
# copy placeholders: data.js to res/ and poster.jpg, res.js to vs${lesId}r1
for l in */; do 
    cp data.js "${l}res/"; 
    cp poster.jpg "${l}vs${l:6:-1}r1/"; 
    cp res.js "${l}vs${l:6:-1}r1/"; 
done
# check video length for each video
for i in */; do 
    ffprobe -i ${i}vs*/video.mp4 -show_entries format=duration -v quiet -of csv="p=0"; 
    echo $i; 
    echo "========================"; 
done
# check video length for each video
for v in *.mp4; do
    num=`echo "$v" | sed -r "s/^([0-9]+).*\.mp4$/\1/g"`;
    num=$((num-1)); 
    vlen=`ffprobe -i "$v" -show_entries format=duration -v quiet -of csv="p=0"`;  
    vlen_int=`echo "$vlen" | awk '{printf("%d\n",$0)}'`;
    let vlength=$(echo "$vlen_int<$vlen" | bc)==1?$vlen_int+1:$vlen_int
    echo "$num: $vlength"; 
done
# image scaling 
 1957  for i in *.jpg; do ffmpeg -i "$i" -vf scale=268:151 tiles/"$i".png; done
 1958  for i in *.jpg; do ffmpeg -i "$i" -vf scale=960:-1 posters/"$i"; done

# image sprite maker regx, find the link in bookmark
# find and replace
^\.bg-([0-9]+).+\{$
#pbt$1r1,\n#photo$1thumb {


#image tile stuff
for i in *.jpg; do
    num=`echo $i | sed -r "s/^([0-9]+)\..*\.jpg$/\1/g"`;
    num=$((num-1));
    yes | cp -rf "$i" /opt/apache-2.4.35/htdocs/tennom.net/video-shooting/lesson${num}/vs${num}r1/;
    mv "/opt/apache-2.4.35/htdocs/tennom.net/video-shooting/lesson${num}/vs${num}r1/$i" /opt/apache-2.4.35/htdocs/tennom.net/video-shooting/lesson${num}/vs${num}r1/poster.jpg;
done

# screen capture for tiles
seconds=(600 271 271 938)
for v in *.mp4; do 
    num=`echo "$v" | sed -r "s/^([0-9]+).*\.mp4$/\1/g"`; 
    ffmpeg -ss ${seconds[$((num-1))]} -i "$v" -vframes 1 -q:v 4 images/$num.jpg; 
done