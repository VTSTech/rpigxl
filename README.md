# rpigxl - RetroPie gamelist.xml Art Injector

<img src="https://i.gyazo.com/ebf503caa9bdbf143852b694c5e14a8b.png">
<pre>
Usage:

./rpigxl.sh -type video -core snes -art /opt/retropie/configs/all/emulationstation/downloaded_media/snes/videos/

* rpigxl.sh assumes you have generated an empty gamelist.xml use -gen to do this *

-core specify single core, all lowercase ie: nes, snes, psx, arcade
-gen  Generate empty gamelist.xml using SkyScraper, Requires -core be set
-art  full path to directory with art, do not use .
-type XML Tag to replace, Supported values: image, video
-v    verbosity level, 1 displays found matches use -vv for more

Changelog:

v0.1-alpha4

Added missing </gameList> to generated xml

v0.1-alpha3

Added second verbosity level
minor code cleanup
Added missing Skyscraper -s import before generation
Error Handling: Now quits when not enough arguments supplied

v0.1-alpha2

Now copies generated gamelist.xml to the emulationstation folder when finished, prompting user to overwrite.
Added -gen option to generate empty gamelist.xml using Skyscraper

</pre>