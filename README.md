SCRIPTS
=============

## ffmpegcut.sh 

Cut video to parts. Join parts into one video and replace existing. For each action there is question if you want to execute it.
 * usage: 
  `./ffmpegcut.sh my-video.mp4`

For parts you need to provide start and end in seconds format. You can use math calculations:
  * eg. 1:25:47 (h:mm:ss) provide `60*60+25*60+47`, this will be calculated into `5147 seconds`
