#!/bin/bash
/bin/date >>segmenter.log

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
        segment "$segments"
    fi
done
if [ "$CHOICE" == "1" ]; then
    echo "Cutting file $file video segment $segments starting at $SEGSTART and ending at $SEGEND"
    ffmpeg -ss $SEGSTART -to $SEGEND -i "$file" -map 0:0 -map 0:1 -c:a copy -c:v copy "$filename-part$segments.$extension"  >> segmenter.log 2>&1
    clear
    echo -e "Cut file $filename-part$segments.$extension starting at $SEGSTART and ending at $SEGEND\n"                             
    segment "$segments"
fi
}

file="$1"
filename="${file%.*}"
extension="${file##*.}"
clear
segments=0
segment "$segments"
clear
if (("$segments"==1)); then
mv "$filename-part1."$extension "$filename-segmented.$extension"
elif (("$segments">1)); then
echo "Would you like to join the segments into one file ?"      
       OPTIONS="Yes No Quit"
       select opt in $OPTIONS; do
       clear
        if [ "$opt" == "Quit" ]; then
            exit
        elif [ "$opt" == "Yes" ]; then
            clear
            echo "Joining segments"
            ffmpeg -f concat -safe 0 -i <(for f in "$filename-part"*$extension;         do echo "file '$(pwd)/$f'"; done) -c:a copy -c:v copy "$filename-segmented.$extension" >>         segmenter.log 2>&1
            clear
            echo "Would you like to delete the part files ?"
            select opt in $OPTIONS; do
            clear
            if [ "$opt" == "Quit" ]; then
                exit
            elif [ "$opt" == "Yes" ]; then
                for f in "$filename-part"*$extension; do rm "$f"; done
                break
            elif [ "$opt" == "No" ]; then
                break
            else
                clear
                echo -e "Bad option\n"
            fi
            done
            break
        clear
        elif [ "$opt" == "No" ]; then
            exit
        else
            clear
            echo -e "Bad option\n"
        fi
    done
fi
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
