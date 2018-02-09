package;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Color;
import kha.Assets;
import kha.Image;
import kha.Assets;
import kha.System;
import kha.FastFloat;
import kha.input.Mouse;
import kha.graphics2.Graphics;
import hxDaedalus.ai.EntityAI;
import hxDaedalus.ai.PathFinder;
import hxDaedalus.ai.trajectory.LinearPathSampler;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.BitmapObject;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.KSimpleView;
import haxe.io.Bytes;
import hxPixels.Pixels;
class BitmapPathfinding {
    var imgColor: Image;
    var imgBW: Image;
    var _mesh : Mesh;
    var _view : KSimpleView;
    var _entityAI : EntityAI;
    var _pathfinder : PathFinder;
    var _path : Array<Float>;
    var _pathSampler : LinearPathSampler;
    var _newPath:Bool = false;
    var x: Float = 0;
    var y: Float = 0;
    public function new() {
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        setup();
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
        Mouse.get().notify( onMouseDown, onMouseUp, onMouseMove, null, null );// wheelListener, leaveListener );
    }
    function setup() {
        imgBW       = Assets.images.galapagosBW;
        imgColor    = Assets.images.galapagosColor;
        // create empty Pixels 
        var pixels = new Pixels( imgBW.width, imgBW.height, true );
        // copy over pixels from the black and white image.
        for( y in 0...imgBW.height )for( x in 0...imgBW.width ) pixels.setPixel( x, y, imgBW.at( x, y ) );
        // build a rectangular 2 polygons mesh
        _mesh = RectMesh.buildRectangle( 1024, 780 );
        // create viewports
        _view = new KSimpleView();
        var object = BitmapObject.buildFromBmpData( pixels, 1.8 );
        object.x = 0;
        object.y = 0;
        _mesh.insertObject( object );
        // we need an entity
        _entityAI = new EntityAI();
        // set radius size for your entity
        _entityAI.radius = 4;
        // set a position
        _entityAI.x = 50;
        _entityAI.y = 50;
        // now configure the pathfinder
        _pathfinder = new PathFinder();
        _pathfinder.entity = _entityAI; // set the entity
        _pathfinder.mesh = _mesh; // set the mesh
        // we need a vector to store the path
        _path = new Array<Float>();
        // then configure the path sampler
        _pathSampler = new LinearPathSampler();
        _pathSampler.entity = _entityAI;
        _pathSampler.samplingDistance = 10;
        _pathSampler.path = _path;
    }
    public function onMouseDown( button: Int, x_: Int, y_: Int ): Void {
        if( button == 0 ){
            x = x_;
            y = y_;
            _newPath = true;
        }
    }
    public function onMouseUp( button: Int, x_: Int, y_: Int ): Void {
        if( button == 0 ){
            x = x_;
            y = y_;
            _newPath = false;
        }
    }
    public function onMouseMove( x_: Int, y_: Int, cx: Int, cy: Int ): Void {
        if( _newPath ){
            x = x_;
            y = y_;
        }
    }
    function update(): Void {
        
    }
    inline function renderDaedalus( g2: Graphics ){
        g2.drawImage( imgColor, 0, 0 );
        // show result mesh on screen
        _view.drawMesh( g2, _mesh );
        if( _newPath ){
            // find path !
            _pathfinder.findPath( x, y, _path );
            // show path on screen
            _view.drawPath( g2, _path );
             // show entity position on screen
            _view.drawEntity( g2, _entityAI ); 
            // reset the path sampler to manage new generated path
            _pathSampler.reset();
        }
        // animate !
        if ( _pathSampler.hasNext ) {
            // move entity
            _pathSampler.next();
        }
        // show entity position on screen
        _view.drawEntity( g2, _entityAI );        
    }
    var localWid: Int = 0;//1024;
    var localHi: Int  = 0;//768;
    function render( framebuffer: Framebuffer ):Void {
        if( Main.hi != localHi || Main.wid != localWid ){
            // if you wanted to scale code..
        }
        var g2 = framebuffer.g2;
        g2.begin();
        g2.clear( Color.fromValue( 0xffcccccc ) );
        g2.color = Color.White;
        g2.opacity = 1.;
        renderDaedalus( g2 );
        g2.end();
    }
}