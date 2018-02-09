# hxDaedalus-Kha-examples
Examples of hxDaedalus with Kha see links below.

[Basic, ](https://hxdaedalus.github.io/hxDaedalus-Kha-examples/build/basic/)
[Pathfinding, ](https://hxdaedalus.github.io/hxDaedalus-Kha-examples/build/pathfinding/)
[BitmapPathfinding, ](https://hxdaedalus.github.io/hxDaedalus-Kha-examples/build/bitmapPathfinding/)
[Maze. ](https://hxdaedalus.github.io/hxDaedalus-Kha-examples/build/maze/)

To run:
Make sure you have Kha folder ( clone Empty ) and also the three hxDaedalus folders in your src folder.
Adjust the Main.hx class to run example you prefer from the current selection BitmapPathfinding.
```code 
System.init({title: "hxDaedalus BitmapPathfinding", width: 1024, height: 768, samplesPerPixel: 4}
            , function() {
                // !!!!!  CHANGE CLASS HERE FOR DEMO YOU WANT TO TRY !!!!
                new BitmapPathfinding();
            });
 ```
