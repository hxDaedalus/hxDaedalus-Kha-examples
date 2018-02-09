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
import hxDaedalus.data.math.RandGenerator;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.KSimpleView;
import kha.input.Keyboard;
import kha.input.KeyCode;
class PathfindingMaze {
    var _mesh : Mesh;
    var _view : KSimpleView;
    var _entityAI : EntityAI;
    var _pathfinder : PathFinder;
    var _path : Array<Float>;
    var _pathSampler : LinearPathSampler;
    var _newPath:Bool = false;
    var x: Float = 0;
    var y: Float = 0;
    var rows: Int = 15;
    var cols: Int = 15;
    public function new() {
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        setup();
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
        Mouse.get().notify( onMouseDown, onMouseUp, onMouseMove, null, null );// wheelListener, leaveListener );
        Keyboard.get().notify( null, null, pressListener );
    }
    function pressListener( str: String ){
        if( str == ' ' ){ reset( true ); }
    }
    function setup() {
        // build a rectangular 2 polygons mesh of 600x600
        _mesh = RectMesh.buildRectangle(600, 600);
        // create viewports
        _view = new KSimpleView();
        // populate mesh with many square objects
        var object : Object;
GridMaze.generate(600, 600, cols, rows);
        _mesh.insertObject(GridMaze.object);
        _view.constraintsWidth = 4;


        // we need an entity
        _entityAI = new EntityAI();
        // set radius as size for your entity
        _entityAI.radius = GridMaze.tileWidth * .3;
        // set a position
        _entityAI.x = GridMaze.tileWidth / 2;
        _entityAI.y = GridMaze.tileHeight / 2;
        // now configure the pathfinder
        _pathfinder = new PathFinder();
        _pathfinder.entity = _entityAI;  // set the entity
        _pathfinder.mesh = _mesh;  // set the mesh
        // we need a vector to store the path
        _path = new Array<Float>();
        // then configure the path sampler
        _pathSampler = new LinearPathSampler();
        _pathSampler.entity = _entityAI;
        _pathSampler.samplingDistance = GridMaze.tileWidth * .7;
        _pathSampler.path = _path;
    }
    function reset(newMaze:Bool = false):Void {
        var seed = Std.int(Math.random() * 10000 + 1000);
        if( newMaze ) {
            _mesh = RectMesh.buildRectangle(600, 600);
            GridMaze.generate(600, 600, 30, 30, seed);
            GridMaze.object.scaleX = .92;
            GridMaze.object.scaleY = .92;
            GridMaze.object.x = 23;
            GridMaze.object.y = 23;
            _mesh.insertObject(GridMaze.object);
        }
        _entityAI.radius = GridMaze.tileWidth * .27;
        _pathSampler.samplingDistance = GridMaze.tileWidth * .7;
        _pathfinder.mesh = _mesh;
        _entityAI.x = GridMaze.tileWidth / 2;
        _entityAI.y = GridMaze.tileHeight / 2;
        _path = [];
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
            //
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