//*********************************************************************
//**                            3D template                          **
//**                 Jarek Rossignac, Oct  2012                      **   
//*********************************************************************
import processing.opengl.*;                // load OpenGL libraries and utilities
import javax.media.opengl.*; 
import java.util.Map.Entry;
import javax.media.opengl.glu.*; 
import java.nio.*;
GL gl; 
GLU glu; 

// ****************************** GLOBAL VARIABLES FOR DISPLAY OPTIONS *********************************
Boolean 
  showMesh=false,
  translucent=false,   
  showSilhouette=true, 
  showNMBE=true,
  showSpine=true,
  showControl=true,
  showTube=true,
  showFrenetQuads=false,
  showFrenetNormal=false,
  filterFrenetNormal=true,
  showTwistFreeNormal=false, 
  showHelpText=false; 
  
  boolean makeConvex = false; 
  boolean canMesh = false; 
  
  boolean printRs = false;
  int smode = 4;
  
int kj = 6;
vec dj = V(0,1,0);
  

// String SCC = "-"; // info on current corner
   
// ****************************** VIEW PARAMETERS *******************************************************
pt F = P(0,0,0); pt T = P(0,0,0); pt E = P(0,0,1000); vec U=V(0,1,0);  // focus  set with mouse when pressing ';', eye, and up vector
pt Q=P(0,0,0); vec I=V(1,0,0); vec J=V(0,1,0); vec K=V(0,0,1); // picked surface point Q and screen aligned vectors {I,J,K} set when picked
void initView() {Q=P(0,0,0); I=V(1,0,0); J=V(0,1,0); K=V(0,0,1); F = P(0,0,0); E = P(0,0,1000); U=V(0,1,0); } // declares the local frames

// ******************************** MESHES ***********************************************
Mesh M=new Mesh(); // meshes for models M0 and M1
Mesh M1=new Mesh();
Mesh M2=new Mesh();
Mesh M3=new Mesh();

float volume1=0, volume0=0;
float sampleDistance=1;
// ******************************** CURVES & SPINES ***********************************************
//Curve C0 = new Curve(15), S0 = new Curve(), C1 = new Curve(15), S1 = new Curve(), S2 = new Curve(), S3 = new Curve();  // control points and spines 0 and 1

Curve C = new Curve(5,0);
Curve C1 = new Curve(5, 1);
Curve C2 = new Curve(5, 2);
Curve C3 = new Curve(5, 3);
//Curve C= new Curve(8, 130, P());

//Random xGen = new Random();
//Random yGen = new Random();
//Random signGen = new Random (); 
//pt centerPGen = P(175,45, 0); 
//int r = 15; 
//particle[] particles = new particle[5000];
//int partCount = 0; 

float time = 0; 
float delt = 0.01;

boolean computeGeom = false; 

//particle p = new particle(P(-150,-100,0), C0);
int mode = 0; 

int partGenSec = 9;




int nsteps=250; // number of smaples along spine
float sd=10; // sample distance for spine
pt sE = P(), sF = P(); vec sU=V(); //  view parameters (saved with 'j'




// *******************************************************************************************************************    SETUP
void setup() {
  size(1000, 700, OPENGL);  
  for(int i =0; i<C.n; i++){
 // println(C.P[i].x);
  }
  setColors(); sphereDetail(7); 
 // texmap = loadImage("world32k.jpg");    
 // initializeSphere(sDetail);
// texturedSphere(5, texmap); 
  PFont font = loadFont("GillSans-24.vlw"); textFont(font, 20);  // font for writing labels on //  PFont font = loadFont("Courier-14.vlw"); textFont(font, 12); 
  // ***************** OpenGL and View setup
  glu= ((PGraphicsOpenGL) g).glu;  PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  gl = pgl.beginGL();  pgl.endGL();
  initView(); // declares the local frames for 3D GUI
 

  // ***************** Load meshes
  M.declareVectors();
  M.resetMarkers().computeBox().updateON(); // makes a cube around C[8]
  
  M1.declareVectors();
  M1.resetMarkers().computeBox().updateON(); // makes a cube around C[8]
  
  M2.declareVectors();
  M2.resetMarkers().computeBox().updateON(); // makes a cube around C[8]
  
  M3.declareVectors();
  M3.resetMarkers().computeBox().updateON(); // makes a cube around C[8]
  
  

  // ***************** Load Curve
  //C.loadPts();
  
  // ***************** Set view
  
// for(int i = 0; i<C.n; i++){ 
// M.addVertex(C.P[i]);
// }
 
//  int a = M.addVertex(C.P[3]);
//  int b = M.addVertex(C.P[2]);
//  int c = M.addVertex(C.P[1]);
//  
// 
//  M.addTriangle(a,b,c);
  
 
  
 for(int i=0; i<M.nv; i++){
 if((i+1)%3 == 0){
// M.addTriangle();
 }
 }
  
 
  F=P(); E=P(0,0,500);
  for(int i=0; i<10; i++) vis[i]=true; // to show all types of triangles
  }
  
// ******************************************************************************************************************* DRAW      
void draw() {  
  background(white);

  // -------------------------------------------------------- Help ----------------------------------
  if(showHelpText) {
    camera(); // 2D display to show cutout
    lights();
    fill(black); writeHelp();
    return;
    } 
    
  // -------------------------------------------------------- 3D display : set up view ----------------------------------
  camera(E.x, E.y, E.z, F.x, F.y, F.z, U.x, U.y, U.z); // defines the view : eye, ctr, up
  vec Li=U(A(V(E,F),0.1*d(E,F),J));   // vec Li=U(A(V(E,F),-d(E,F),J)); 
  directionalLight(255,255,255,Li.x,Li.y,Li.z); // direction of light: behind and above the viewer
  specular(255,255,0); shininess(5);

 

  
  // -------------------------- display and edit control points of the spines and box ----------------------------------   
    if(pressed) {
     if (keyPressed&&(key=='a'||key=='s')) {
       fill(white,0); noStroke(); if(showControl) C.showSamples(20);
       if(smode==0) C.pick(Pick());
       if(smode==1) C1.pick(Pick());
       if(smode==2) C2.pick(Pick());
       if(smode==3) C3.pick(Pick());
      }
     }
     
  // -------------------------------------------------------- create control curves  ----------------------------------   
 
//  C0.empty(); 
//  for (int i = 0; i<C.n; i++){
//    C0.append(C.P[i]);
//  }

  // stroke(green);
 //  for(int i = 0; i < 4; i++){
  // C0.subDivide(); 
  // }

//rs.subdivideCurves0(); 
   // -------------------------------------------------------- create and show spines  ----------------------------------   
  // S0=S0.makeFrom(C0,400).resampleDistance(sampleDistance);
 //  S1=S1.makeFrom2(C0,400).resampleDistance(sampleDistance);
  // stroke(green); noFill(); if(showSpine) S0.drawEdges(); 
   
   // -------------------------------------------------------- compute spine normals  ----------------------------------   
//   S0.prepareSpine(0); 
  
 
   // -------------------------------------------------------- create and move mesh ----------------------------------   
   //pt Q0=C.Pof(10); fill(red); show(Q0,4);
 //  M.moveTo(Q0);
  
     // -------------------------------------------------------- show mesh ----------------------------------   
   
  M.empty(); 
  M1.empty();
//  M2.empty();
 // M3.empty();
  // if(canMesh == true){
   //rs.formMeshes();   
  // canMesh = false; 
  // }
  
 
 
   
   RotateSweep rs = new RotateSweep(smode, M);
   RotateSweep rs1 = new RotateSweep(5, M1);
   

//   if(smode == 1){
//    rs = new RotateSweep(C1, smode, M);
//   }
//      else if(smode == 2){
//       rs = new RotateSweep(C2, smode, M);
//   }
//      else if(smode == 3){
//        rs = new RotateSweep(C3, smode, M);
//   }
   
  
   rs.formMeshes(); 
   rs1.formMeshes();
   
   M.normals();
  M1.normals();
  

  
 // println(M.eMap.get(0));
  //  M2.normals();
 // M3.normals();
  
  
  //  M.resetCounters();
    //M.revolve(rs);
  //  M1.resetCounters();
    //M1.revolve(rs1);
  println(rs.type);
  if(rs.type == 4){
  M.buildEMap();
  M1.buildEMap(); 
  M.map(0, M1);
  M.showMorph(time);
  }

   
//   if(printRs == true){
//   rs.printrs();
//   printRs = false;
//   }
   
  // stroke(red);
   
   
   //canMesh = false; 
 //  }
   
   if(showMesh) { 
     fill(yellow); 
     if(M.showEdges){ 
       stroke(white);
     }  
     else{ 
       noStroke();
     } 
   M.showFront(); 
   stroke(green); 
   M.showNormals();
   
  if(smode == 4){ 
   if(M1.showEdges){ 
       stroke(white);
     }  
     else{ 
       noStroke();
     } 
   M1.showFront(); 
   stroke(green); 
   M1.showNormals();
  } 
   } 
   
    // -------------------------- pick mesh corner ----------------------------------   
//   if(pressed) if (keyPressed&&(key=='.')) M.pickc(Pick());
 
 
     // -------------------------------------------------------- show mesh corner ----------------------------------   
//   if(showMesh) { fill(red); noStroke(); M.showc();} 
 
  // -------------------------------------------------------- graphic picking on surface and view control ----------------------------------   
  if (keyPressed&&key==' ') T.set(Pick()); // sets point T on the surface where the mouse points. The camera will turn toward's it when the ';' key is released
  SetFrame(Q,I,J,K);  // showFrame(Q,I,J,K,30);  // sets frame from picked points and screen axes
  // rotate view 
  if(!keyPressed&&mousePressed) {E=R(E,  PI*float(mouseX-pmouseX)/width,I,K,F); E=R(E,-PI*float(mouseY-pmouseY)/width,J,K,F); } // rotate E around F 
  if(keyPressed&&key=='D'&&mousePressed) {E=P(E,-float(mouseY-pmouseY),K); }  //   Moves E forward/backward
  if(keyPressed&&key=='d'&&mousePressed) {E=P(E,-float(mouseY-pmouseY),K);U=R(U, -PI*float(mouseX-pmouseX)/width,I,J); }//   Moves E forward/backward and rotatees around (F,Y)
   
  // -------------------------------------------------------- Disable z-buffer to display occluded silhouettes and other things ---------------------------------- 
  hint(DISABLE_DEPTH_TEST);  // show on top
  
  stroke(green);
 
if(mode == 1){

   if(pressed) {
     if (keyPressed&&(key=='a'||key=='s')) {
       fill(white,0); noStroke(); if(showControl) C.showSamples(20);
       if(smode==0) C.pick(Pick());
       if(smode==1) C1.pick(Pick());
       if(smode==2) C2.pick(Pick());
       if(smode==3) C3.pick(Pick());
      }
     }
//p.computeClosestPt();
//p.computeVelocity();
     
 
 // show(p.cen, p.rad);
 // show(p.cen, C0.P[p.closestPtIndex]); 
}
else{
//   for(int i = 0; i < partCount; i++){
//    if(particles[i].shouldDraw == true){
//     show(particles[i].cen, particles[i].rad);
//    }
//  }

// renderGlobe(); 
}


  
    if(showControl) {
      
      rs.showRot(); 
      if(smode == 4){
        rs1.showRot();
      }
    
      
      if(smode == 0){
      stroke(blue);
      for(int i = 0; i<C.n; i++){
      C.showSample(i,2);
      }
      stroke(red);
      for(int i=0; i<C.n-1;i++){
         show(C.P[i], C.P[i+1]);
      }
      }      
      
    //  rs1.showRot();
      
      if(smode == 1){
       stroke(blue);
      for(int i = 0; i<C1.n; i++){
      C1.showSample(i,2);
      }
       stroke(red);
      for(int i=0; i<C1.n-1;i++){
         show(C1.P[i], C1.P[i+1]);
      }  
      }
      
         if(smode == 2){
       stroke(blue);
      for(int i = 0; i<C2.n; i++){
      C2.showSample(i,2);
      }
       stroke(red);
      for(int i=0; i<C2.n-1;i++){
         show(C2.P[i], C2.P[i+1]);
      }  
      }
      
     if(smode == 3){
       stroke(blue);
      for(int i = 0; i<C3.n; i++){
      C3.showSample(i,2);
      }
       stroke(red);
      for(int i=0; i<C3.n-1;i++){
         show(C3.P[i], C3.P[i+1]);
      }  
      }
      
     
     }

//  stroke(red); if(showControl) {C0.showSamples(4);}
//  if(showMesh&&showSilhouette) {stroke(dbrown); M.drawSilhouettes(); }  // display silhouettes
//  strokeWeight(2); stroke(red);if(showMesh&&showNMBE) M.showMBEs();  // manifold borders
  camera(); // 2D view to write help text
  writeFooterHelp();
  hint(ENABLE_DEPTH_TEST); // show silouettes

  // -------------------------------------------------------- SNAP PICTURE ---------------------------------- 
   if(snapping) snapPicture(); // does not work for a large screen
    pressed=false;
    
 
   if(time>=1.0 || time<0){
    delt = -delt;
  }
 time += delt;
 

 } // end draw
 
 
 // ****************************************************************************************************************************** INTERRUPTS
Boolean pressed=false;

void mousePressed() {
 pressed=true; 
 
 if(keyPressed&&key=='i'){

  if(C.n < 16){
  C.pick(Pick());
  pt newP = D(C.P[C.p],C.P[C.p+1], C.P[C.p+2], 0.75); 
  C.insert(newP);
  }
  println(C.n);
  }
  
  if(keyPressed&&key=='d'){
  C.pick(Pick());
  C.delete();
  }
}
  
void mouseDragged() {
  if(keyPressed&&key=='a') {C.dragPoint( V(.5*(mouseX-pmouseX),I,.5*(mouseY-pmouseY),K) ); } // move selected vertex of curve C in screen plane
  if(keyPressed&&key=='s') {
 
    if(smode==0) C.dragPoint( V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); 
    if(smode==1) C1.dragPoint( V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); 
    if(smode==2) C2.dragPoint( V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); 
    if(smode==3) C3.dragPoint( V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); 
  
  } // move selected vertex of curve C in screen plane
  if(keyPressed&&key=='b') {C.dragAll(0,5, V(.5*(mouseX-pmouseX),I,.5*(mouseY-pmouseY),K) ); } // move selected vertex of curve C in screen plane
  if(keyPressed&&key=='v') {C.dragAll(0,5, V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); } // move selected vertex of curve Cb in XZ
 // if(keyPressed&&key=='x') {M.add(float(mouseX-pmouseX),I).add(-float(mouseY-pmouseY),J); M.normals();} // move selected vertex in screen plane
//  if(keyPressed&&key=='z') {M.add(float(mouseX-pmouseX),I).add(float(mouseY-pmouseY),K); M.normals();}  // move selected vertex in X/Z screen plane
  if(keyPressed&&key=='X') {M.addROI(float(mouseX-pmouseX),I).addROI(-float(mouseY-pmouseY),J); M.normals();} // move selected vertex in screen plane
  if(keyPressed&&key=='Z') {M.addROI(float(mouseX-pmouseX),I).addROI(float(mouseY-pmouseY),K); M.normals();}  // move selected vertex in X/Z screen plane 
  
  //drag particle 
 // if(keyPressed&&key=='o') {p.dragPart( V(.5*(mouseX-pmouseX),I,.5*(mouseY-pmouseY),K) ); } // move selected vertex of curve C in screen plane
 // if(keyPressed&&key=='p') {p.dragPart( V(.5*(mouseX-pmouseX),I,-.5*(mouseY-pmouseY),J) ); } // move selected vertex of curve C in screen plane

  }

void mouseReleased() {
     U.set(M(J)); // reset camera up vector
    }
  
void keyReleased() {
   if(key==' ') F=P(T);                           //   if(key=='c') M0.moveTo(C.Pof(10));
   U.set(M(J)); // reset camera up vector
   } 

 
void keyPressed() {
  if(key=='a') {} // drag curve control point in xz (mouseDragged)
  if(key=='b') {}  // move S2 in XZ
  if(key=='c') {
  
    makeConvex = true;
    
    if(smode==0) C.convex();
    if(smode==1) C1.convex();
    if(smode==2) C2.convex();
    if(smode==3) C3.convex();
    
  

  } // load curve
  if(key=='d') {} //delete control pt
  //if(key=='e') {} //add control pt
  if(key=='f') {filterFrenetNormal=!filterFrenetNormal; if(filterFrenetNormal) println("Filtering"); else println("not filtering");}
  if(key=='g') {} // change global twist w (mouseDrag)
  if(key=='h') {} // hide picked vertex (mousePressed)
  if(key=='e') {mode = 1;} 
  if(key=='j') {
    println(M.nv);
    printRs = !printRs; 
    //println(M.nt);
    
//  for(int i=0; i<M.nt;i++){
//    println(M.Nt[i].x);
//    println(M.Nt[i].y);
//    println(M.Nt[i].z);
//  }
  }
  if(key=='k') {

  }
  if(key=='l') { 
    println(M.nv);
    canMesh = !canMesh;
   if(canMesh == true){
 // rs.formMeshes();
     // canMesh = false;   
   }
   
  }
  if(key=='m') {showMesh=!showMesh; M.showEdges = !M.showEdges; M1.showEdges = !M1.showEdges;}
  if(key=='n') {showNMBE=!showNMBE;}
  if(key=='o') {}//drag particle on xz
  if(key=='p') {}//drag particle on xy
  if(key=='q') {mode = 0;}
  if(key=='r') {mode = 2;};
  if(key=='s') {} // drag curve control point in xy (mouseDragged)
  if(key=='t') {showTube=!showTube;}
  if(key=='u') {}
  if(key=='v') {} // move S2
  if(key=='w') {}
  if(key=='x') {} // drag mesh vertex in xy (mouseDragged)
  if(key=='y') {}
  if(key=='z') {} // drag mesh vertex in xz (mouseDragged)
   
  if(key=='A') {C.savePts();}
  if(key=='B') {}
  if(key=='C') {C.loadPts();} // save curve
  if(key=='D') {} //move in depth without rotation (draw)
  if(key=='E') {M.smoothen(); M.normals();}
  if(key=='F') {}
  if(key=='G') {}
  if(key=='H') {}
  if(key=='I') {}
  if(key=='J') {}
  if(key=='K') {}
  if(key=='L') {M.loadMeshVTS().updateON().resetMarkers().computeBox(); F.set(M.Cbox); E.set(P(F,M.rbox*2,K)); for(int i=0; i<10; i++) vis[i]=true;}
  if(key=='M') {}
  if(key=='N') {M.next();}
  if(key=='O') {}
  if(key=='P') {}
  if(key=='Q') {exit();}
  if(key=='R') {}
  if(key=='S') {M.swing();}
  if(key=='T') {}
  if(key=='U') {}
  if(key=='V') {} 
  if(key=='W') {M.saveMeshVTS();}
  if(key=='X') {} // drag mesh vertex in xy and neighbors (mouseDragged)
  if(key=='Y') {M.refine(); M.makeAllVisible();}
  if(key=='Z') {} // drag mesh vertex in xz and neighbors (mouseDragged)

  if(key=='`') {M.perturb();}
  if(key=='~') {showSpine=!showSpine;}
  if(key=='!') {snapping=true;}
  if(key=='@') {}
  if(key=='#') {}
  if(key=='$') {M.moveTo(C.Pof(10));} // ???????
  if(key=='%') {}
  if(key=='&') {}
  if(key=='*') {sampleDistance*=2;}
  if(key=='(') {}
  if(key==')') {showSilhouette=!showSilhouette;}
  if(key=='_') {M.flatShading=!M.flatShading;}
  if(key=='+') {M.flip();} // flip edge of M
  if(key=='-') {M.showEdges=!M.showEdges;}
  if(key=='=') {C.P[5].set(C.P[0]); C.P[6].set(C.P[1]); C.P[7].set(C.P[2]); C.P[8].set(C.P[3]); C.P[9].set(C.P[4]);}
  if(key=='{') {showFrenetQuads=!showFrenetQuads;}
  if(key=='}') {}
  if(key=='|') {}
  if(key=='[') {initView(); F.set(M.Cbox); E.set(P(F,M.rbox*2,K));}
  if(key==']') {F.set(M.Cbox);}
  if(key==':') {translucent=!translucent;}
  if(key==';') {showControl=!showControl;}
  if(key=='<') {}
  if(key=='>') {if (shrunk==0) shrunk=1; else shrunk=0;}
  if(key=='?') {showHelpText=!showHelpText;}
  if(key=='.') {kj = kj - 1;} // pick corner
  if(key==',') {kj = kj + 1;}
  if(key=='^') {} 
  if(key=='/') {} 
  //if(key==' ') {} // pick focus point (will be centered) (draw & keyReleased)

  if(key=='0') {}
  if(key=='1') {smode = 0;}
  if(key=='2') {smode = 1;}
  if(key=='3') {smode = 2;}
  if(key=='4') {smode = 3;}
  if(key=='5') {smode = 4;}
  if(key=='6') {partGenSec = 6;} 
  if(key=='7') {partGenSec = 7;}
  if(key=='8') {partGenSec = 8;} 
  if(key=='9') {partGenSec = 9;}
 
//  for(int i=0; i<10; i++) if (key==char(i+48)) vis[i]=!vis[i];
  
  } //------------------------------------------------------------------------ end keyPressed

float [] Volume = new float [3];
float [] Area = new float [3];
float dis = 0;
  
Boolean prev=false;

void showGrid(float s) {
  for (float x=0; x<width; x+=s*20) line(x,0,x,height);
  for (float y=0; y<height; y+=s*20) line(0,y,width,y);
  }
  
  // Snapping PICTURES of the screen
PImage myFace; // picture of author's face, read from file pic.jpg in data folder
int pictureCounter=0;
Boolean snapping=false; // used to hide some text whil emaking a picture
void snapPicture() {saveFrame("PICTURES/P"+nf(pictureCounter++,3)+".jpg"); snapping=false;}

 

