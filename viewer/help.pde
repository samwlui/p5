void writeHelp () {fill(dblue);
    int i=0;
    scribe("CS 3451-Project 4-3D view (Sean Chiem, Sam Lui)",i++);
    scribe("The red and blue spheres are my curve, with the blue spheres being my control points",i++);
    scribe("The the blue and black sphere is my particle generator and the little green spheres are my particles",i++);
    scribe("For the curve---press s : move control point along XY, press a : move control point along XZ",i++);
     scribe("press e and click on control point: add a control point using lerp with the next 2 points",i++);
     scribe("press d and click on control point: delete point where clicked",i++);
    //scribe("MESH L:load, .:pick corner, Y:subdivide, E:smoothen, W:write, N:next, S.swing ",i++);
    scribe("For viewing--press space : pick focus, press [ : reset",i++);
    scribe("For the particle and line closest to curve---press i : view it",i++);
    scribe("For the particle---press p : move particle along XY, press o : move particle along XZ",i++);
    scribe("press q :to go back to default screen, also press r : to turn off collision",i++);
    scribe("30 particles per second is the default for the number of particles emitted from the generator",i++);
    scribe("press 1-9 : for the amount of particles that is to be generated per second with corresponding keys, 9 is default",i++);
    scribe("press 0: for 30 particles generated per second",i++);
    scribe("press k: to turn on dynamic velocity, press it again to turn it off",i++);
    scribe("press ?: to go back",i++);
    scribe("",i++);

   }
void writeFooterHelp () {fill(dbrown);
    scribeFooter("Sean Chiem, Sam Lui, and Robert Heck-Project 5.  ",1);
  }
void scribeHeader(String S) {text(S,10,20);} // writes on screen at line i
void scribeHeaderRight(String S) {text(S,width-S.length()*15,20);} // writes on screen at line i
void scribeFooter(String S) {text(S,10,height-10);} // writes on screen at line i
void scribeFooter(String S, int i) {text(S,10,height-10-i*20);} // writes on screen at line i from bottom
void scribe(String S, int i) {text(S,10,i*30+20);} // writes on screen at line i
void scribeAtMouse(String S) {text(S,mouseX,mouseY);} // writes on screen near mouse
void scribeAt(String S, int x, int y) {text(S,x,y);} // writes on screen pixels at (x,y)
void scribe(String S, float x, float y) {text(S,x,y);} // writes at (x,y)
void scribe(String S, float x, float y, color c) {fill(c); text(S,x,y); noFill();}
;
