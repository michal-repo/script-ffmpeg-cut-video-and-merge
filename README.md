ffmpegcut.sh 
=============

Cut video to parts. Join parts into one video and replace existing. For each action there is question if you want to execute it.
 * usage: 
  `./ffmpegcut.sh my-video.mp4`

For parts you need to provide start and end in seconds format. You can use math calculations:
  * eg. 1:25:47 (h:mm:ss) provide `60*60+25*60+47`, this will be calculated into `5147 seconds`

Original script by rianoc @ https://superuser.com/a/719610


ffmpegcut_concat.sh 
=============

Modified version of first script.
Define parts, then cut and merge in one run of ffmpeg. Faster if you want to cut multiple parts and merge them in one out file.
 * usage: 
  `./ffmpegcut_concat.sh my-video.mp4`

For parts you need to provide start and end in seconds format. You can use math calculations:
  * eg. 1:25:47 (h:mm:ss) provide `60*60+25*60+47`, this will be calculated into `5147 seconds`