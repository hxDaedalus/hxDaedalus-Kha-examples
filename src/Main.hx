package;
#if js
import js.Browser;
import js.html.CanvasElement;
#end
import kha.System;

// !!! DEMO CHOICES !!!
import Basic;
import Pathfinding;
import BitmapPathfinding;
import PathfindingMaze;

class Main {
    public static var wid: Int;
    public static var hi:  Int;
    public static var resize: Void->Void;
    public static function main() {        
        //wid = 1024;
        //hi = 768;

        var document = Browser.window.document;
        var window = Browser.window;
        document.documentElement.style.padding = "0";
        document.documentElement.style.margin = "0";
        document.body.style.padding = "0";
        document.body.style.margin = "0";
        document.body.style.color = "0x9B7031";
        var canvas = cast(document.getElementById("khanvas"), CanvasElement);
        canvas.style.display = "block";

        resize = function() {
            canvas.width = Std.int(window.innerWidth * window.devicePixelRatio);
            canvas.height = Std.int(window.innerHeight * window.devicePixelRatio);
            wid = Std.int( canvas.width/window.devicePixelRatio );
            hi = Std.int( canvas.height/window.devicePixelRatio );
            canvas.style.width = document.documentElement.clientWidth + "px";
            canvas.style.height = document.documentElement.clientHeight + "px";
        }
        window.onresize = resize;
        resize();



        System.init({title: "hxDaedalus BitmapPathfinding", width: 1024, height: 768, samplesPerPixel: 4}
            , function() {
                // !!!!!  CHANGE CLASS HERE FOR DEMO YOU WANT TO TRY !!!!
                new BitmapPathfinding();
            });
    }
}