# rpigxl
 rpigxl - RetroPie gamelist.xml Art Injector

<img src="https://i.gyazo.com/d6cdb1714286205803389be5801a6b34.png">
<pre>
Usage:

./rpigxl.sh -type video -core snes -art /opt/retropie/configs/all/emulationstation/downloaded_media/snes/videos/


* rpigxl.sh assumes you have run SkyScraper and generated an empty game list with your Rom Names and Filenames *
* future versions of rpigxl.sh will simply do this for you. For now do it prior to running rpigxl.sh           *


-core specify single core, all lowercase ie: nes, snes, psx, arcade
-art  full path to directory with art, do not use .
-type XML Tag to replace, Supported values: image, video
-v    verbosity level, 1 displays found matches
<pre>
