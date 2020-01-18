# rpigxl
 rpigxl - RetroPie gamelist.xml Art Injector

<img src="https://i.gyazo.com/d0ab3f6d9906f20f5ef5f3bd55f7a710.png">
<pre>
Usage:

./rpigxl.sh -type video -core snes -art /opt/retropie/configs/all/emulationstation/downloaded_media/snes/videos/

* rpigxl.sh assumes you have generated an empty gamelist.xml use -gen to do this *

-core specify single core, all lowercase ie: nes, snes, psx, arcade
-gen  Generate empty gamelist.xml using SkyScraper, Requires -core be set
-art  full path to directory with art, do not use .
-type XML Tag to replace, Supported values: image, video
-v    verbosity level, 1 displays found matches

<pre>
