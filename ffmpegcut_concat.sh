#!/bin/bash


function segment (){
while true; do
    echo "Would you like to cut out a segment ?"
    echo -e "1) Yes\n2) No\n3) Quit"
    read CHOICE
    if [ "$CHOICE" == "3" ]; then
        exit
    elif [ "$CHOICE" == "2" ]; then
        clear
        break
    elif [ "$CHOICE" == "1" ]; then
        clear
        ((segments++))
        echo "What time does segment $segments start ?"
        read SEGMENTSTART
        clear
                SEGSTART=$(bc <<< $SEGMENTSTART)
        echo -e "Segment $segments start set to $SEGSTART\n"
        echo "What time does segment $segments end ?"
        read SEGMENTEND
        clear
        SEGEND=$(bc <<< $SEGMENTEND)
        echo -e "Segment $segments end set to $SEGEND\n"
        break
    else
        clear
        echo -e "Bad option"
        segment
    fi
done
if [ "$CHOICE" == "1" ]; then
        concat_lines[concat_lines_key]="file '$(pwd)/$file'"
        ((concat_lines_key++))
        concat_lines[concat_lines_key]="inpoint $SEGSTART"
        ((concat_lines_key++))
        concat_lines[concat_lines_key]="outpoint $SEGEND"
        ((concat_lines_key++))
    clear
    echo -e "Part $segments starting at $SEGSTART and ending at $SEGEND\n"
    segment
fi
}

file="$1"
filename="${file%.*}"
extension="${file##*.}"
clear
segments=0
SEGSTART=0
SEGEND=0
concat_lines=()
concat_lines_key=0
segment
clear
echo "Cutting file $file at defined segments and joining into one file"
ffmpeg -f concat -safe 0 -i <(for i in ${!concat_lines[@]};do echo "${concat_lines[$i]}";done;) -c:a copy -c:v copy "$filename-segmented.$extension" > /dev/null 2>&1

clear

if [ "$OPTION" == "3" ]; then
        rm "$file"
        mv "$filename-segmented.$extension" "$file"
else
        echo "Would you like to replace the original file with the result of your changes ?"
        OPTIONS="Yes No Quit"
        select opt in $OPTIONS; do
                clear
                if [ "$opt" == "Quit" ]; then
                        exit
                elif [ "$opt" == "Yes" ]; then
                        rm "$file"
                        mv "$filename-segmented.$extension" "$file"
                        break
                elif [ "$opt" == "No" ]; then
                        break
                else
                        clear
                        echo -e "Bad option\n"
                fi
        done
fi
