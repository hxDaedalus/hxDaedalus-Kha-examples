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
import hxDaedalus.data.ConstraintSegment;
import hxDaedalus.data.Mesh;
import hxDaedalus.data.Object;
import hxDaedalus.data.Vertex;
import hxDaedalus.factories.RectMesh;
import hxDaedalus.view.KSimpleView;
import kha.graphics2.Graphics;
class Basic {
    var _mesh:      Mesh;
    var _view:      KSimpleView;
    var _object:    Object;

    public function new() {
        Assets.loadEverything( loadAll );
    }
    function loadAll(){
        setup();
        System.notifyOnRender( render );
        Scheduler.addTimeTask( update, 0, 1 / 60 );
    }
    
    public function setup(){
        _view = new KSimpleView();
        // build a rectangular 2 polygons mesh of 600x400
        _mesh = RectMesh.buildRectangle(600, 400);
        // SINGLE VERTEX INSERTION / DELETION
        // insert a vertex in mesh at coordinates (550, 50)
        var vertex : Vertex = _mesh.insertVertex(550, 50);
        
        // SINGLE CONSTRAINT SEGMENT INSERTION / DELETION
        // insert a segment in mesh with end points (70, 300) and (530, 320)
        var segment : ConstraintSegment = _mesh.insertConstraintSegment(70, 300, 530, 320);
        
        // CONSTRAINT SHAPE INSERTION / DELETION
        // insert a shape in mesh (a crossed square)
        var shape = _mesh.insertConstraintShape( [
                         50.,  50., 100.,  50.,      /* 1st segment with end points (50, 50) and (100, 50)       */
                        100.,  50., 100., 100.,      /* 2nd segment with end points (100, 50) and (100, 100)     */
                        100., 100.,  50., 100.,      /* 3rd segment with end points (100, 100) and (50, 100)     */
                         50., 100.,  50.,  50.,      /* 4rd segment with end points (50, 100) and (50, 50)       */
                         20.,  50., 130., 100.       /* 5rd segment with end points (20, 50) and (130, 100)      */
                                                ] );
                                                
        // OBJECT INSERTION / TRANSFORMATION / DELETION
        // insert an object in mesh (a cross)
        var objectCoords : Array<Float> = new Array<Float>();

        _object = new Object();
        _object.coordinates = [ -50.,   0.,  50.,  0.,
                                  0., -50.,   0., 50.,
                                -30., -30.,  30., 30.,
                                 30., -30., -30., 30.
                                ];
        _mesh.insertObject( _object );  // insert after coordinates are setted

        // you can transform objects with x, y, rotation, scaleX, scaleY, pivotX, pivotY
        _object.x = 400;
        _object.y = 200;
        _object.scaleX = 2;
        _object.scaleY = 2;
        
    }
    function update(): Void {
        // objects can be transformed at any time
        _object.rotation += 0.05;
        _mesh.updateObjects();  // don't forget to update
    }
    inline function renderDaedalus( g2: Graphics ){
        _view.drawMesh( g2, _mesh );
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