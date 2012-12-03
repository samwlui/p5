class RotateSweep{
  
 

  Curve[] curves = new Curve[kj];
  int type; 
  
  int nCurves = 0; //keep track of number of curves in curves array
  
  Mesh mesh; 
  
  public RotateSweep(int tempType, Mesh M){
  this.mesh= M;
   if(tempType == 4 || tempType == 5){ 
    this.type = tempType-4;
   }
  else{
  this.type = tempType;
  } 

curves[0] = new Curve(5,type); 
//curves[0] = c; 

//f(tempType == 0){
curves[0].dragAll(V(300,V(1,0,0),0,V(0,0,0)));
//}
//if(tempType == 1){
//curves[0].dragAll(V(300,V(1,0,0),0,V(0,0,0)));
//}
nCurves++;


 
   float theta = radians(360.0/kj);
   dj.z = 1 - sq(dj.x) - sq(dj.y);
   
   Curve prevCurve = curves[0];
   
   for(int i = 1; i<curves.length;i++){
      curves[i] = new Curve(5, type);
       //curves[i] = c; 
       
      // if(tempType == 0){
       curves[i].dragAll(V(300,V(1,0,0),0,V(0,0,0)));
     //  }
     //  if(tempType == 1){
      // curves[i].dragAll(V(300,V(1,0,0),0,V(0,0,0)));
      // }
       
       for(int j=0; j<curves[i].n;j++){
          curves[i].P[j].x = (cos(theta) + sq(dj.x)*(1-cos(theta)))*prevCurve.P[j].x + (dj.x*dj.y*(1-cos(theta)) - dj.z*sin(theta))*prevCurve.P[j].y + (dj.x*dj.z*(1-cos(theta)) + dj.y*sin(theta))*prevCurve.P[j].z;
          curves[i].P[j].y = (dj.y*dj.x*(1-cos(theta)) + dj.z*sin(theta))*prevCurve.P[j].x + (cos(theta) + sq(dj.y)*(1-cos(theta)))*prevCurve.P[j].y + (dj.y*dj.z*(1-cos(theta)) - dj.x*sin(theta))*prevCurve.P[j].z;
          curves[i].P[j].z = (dj.z*dj.x*(1-cos(theta)) - dj.y*sin(theta))*prevCurve.P[j].x + (dj.z*dj.y*(1-cos(theta)) + dj.x*sin(theta))*prevCurve.P[j].y + (cos(theta) + sq(dj.z)*(1-cos(theta)))*prevCurve.P[j].z;
      //curves[i].P[j].x = prevCurve.P[j].z * sin(theta) + prevCurve.P[j].x * cos(theta);
        //  curves[i].P[j].z = prevCurve.P[j].z * cos(theta) - prevCurve.P[j].x * sin(theta);  
     }
       prevCurve = curves[i];
   }

//if in mode 4, drag all curves again
if(tempType == 4){
   for(int i=0;i<curves.length;i++){
     curves[i].dragAll(V(-200,V(1,0,0),0,V(0,0,0)));
   }
   this.type = tempType;
}
else if(tempType == 5){
   for(int i=0;i<curves.length;i++){
     curves[i].dragAll(V(200,V(1,0,0),0,V(0,0,0)));
   }
   

}
   
   
  

   
}// end constructor
  
  
  
// void subdivideCurves0(){
// for(int i = 0; i < curves0.length; i ++){
//   curves0[i].empty(); 
//  for (int j = 0; j<curves[i].n; j++){
//    curves0[i].append(curves[i].P[j]);
//  }
//
//  for(int k = 0; k < 4; k++){
//   curves0[i].subDivide(); 
//   }
// }  
// } 
  
  void showRot(){


//for(int i=0; i<curves.length;i++){
//  for(int j=0;j<curves[i].n;j++){
//  stroke(blue);
//  curves[i].showSample(j,2);
//  }
//  
//  stroke(red);
//      for(int j=0; j<curves[i].n-1;j++){
//         show(curves[i].P[j], curves[i].P[j+1]);
//      }      
//}

for(int i=0; i<kj;i++){
  
/* stroke(red);
      for(int j=0; j<curves[i].n-1; j++){
         show(curves[i].P[j], curves[i].P[j+1]);} */
  
  stroke(red);
      for(int j=0; j<curves[i].n-1;j++){
        if(i != 0){
          show(curves[i-1].P[j], curves[i].P[j], curves[i].P[j+1]);
          show(curves[i-1].P[j], curves[i].P[j+1], curves[i-1].P[j+1]);
        }
      }

  if(i == curves.length-1)
  {
    for(int j=0; j<curves[i].n-1; j++){
        if(i != 0){
          show(curves[i].P[j], curves[0].P[j], curves[0].P[j+1]);
          show(curves[i].P[j], curves[0].P[j+1], curves[i].P[j+1]);
        }
      }
  }
  for(int j=0;j<curves[i].n;j++){
  stroke(blue);
  curves[i].showSample(j,2); }    
 } 
}
  
void formMeshes(){
  
  int a=0,b=0,c=0,d=0,e=0,f=0,g=0,h=0; 
  for(int i=0; i<kj-1; i++){
  
  if(alreadyAddedVertex(curves[i+1].P[1]) != -1){
    a =  alreadyAddedVertex(curves[i+1].P[1]);
  }
  else{
     a =  mesh.addVertex(curves[i+1].P[1]);
  }
  
 if(alreadyAddedVertex(curves[i].P[0]) != -1){
   b = alreadyAddedVertex(curves[i].P[0]);
  }
  else{
    b = mesh.addVertex(curves[i].P[0]);
  }
  
  
  if(alreadyAddedVertex(curves[i].P[1]) != -1){
  c = alreadyAddedVertex(curves[i].P[1]);
  }
  else{
  c = mesh.addVertex(curves[i].P[1]);
  }
  
   //println("a: " + a + " b: " + b + " c: " + c);
  mesh.addTriangle(a,b,c);
  
  if(alreadyAddedVertex(curves[i].P[2]) != -1){
    d = alreadyAddedVertex(curves[i].P[2]);
  }
  else{
    d = mesh.addVertex(curves[i].P[2]);
  }
  mesh.addTriangle(a,c,d);
  
  if(alreadyAddedVertex(curves[i+1].P[2]) != -1){
  e = alreadyAddedVertex(curves[i+1].P[2]);
  }
  else{
  e = mesh.addVertex(curves[i+1].P[2]);
  }
  mesh.addTriangle(e,a,d);
  
 if(alreadyAddedVertex(curves[i].P[3]) != -1){
  f = alreadyAddedVertex(curves[i].P[3]);
  }
  else{
  f = mesh.addVertex(curves[i].P[3]);
  }
  mesh.addTriangle(e,d,f);
  
  if(alreadyAddedVertex(curves[i+1].P[3]) != -1){
  g = alreadyAddedVertex(curves[i+1].P[3]);
  }
  else{
    g = mesh.addVertex(curves[i+1].P[3]);
  }
  mesh.addTriangle(e,f,g);
  
  if(alreadyAddedVertex(curves[i].P[4]) != -1){
  h = alreadyAddedVertex(curves[i].P[4]);
  }
  else{
    h = mesh.addVertex(curves[i].P[4]);
  }
   mesh.addTriangle(g,f,h);
  // println("a: " + a + " b: " + b + " c: " + c + " d:" + d + " e:" + e);
   // println("a: " + a);
  
  }
  
  //account for last curve
  if(alreadyAddedVertex(curves[0].P[1]) != -1){
    a =  alreadyAddedVertex(curves[0].P[1]);
  }
  else{
     a =  mesh.addVertex(curves[0].P[1]);
  }
  
 if(alreadyAddedVertex(curves[kj-1].P[0]) != -1){
   b = alreadyAddedVertex(curves[kj-1].P[0]);
  }
  else{
    b = mesh.addVertex(curves[kj-1].P[0]);
  }
  
  
  if(alreadyAddedVertex(curves[kj-1].P[1]) != -1){
  c = alreadyAddedVertex(curves[kj-1].P[1]);
  }
  else{
  c = mesh.addVertex(curves[kj-1].P[1]);
  }
  
   //println("a: " + a + " b: " + b + " c: " + c);
  mesh.addTriangle(a,b,c);
  
  if(alreadyAddedVertex(curves[kj-1].P[2]) != -1){
    d = alreadyAddedVertex(curves[kj-1].P[2]);
  }
  else{
    d = mesh.addVertex(curves[kj-1].P[2]);
  }
  mesh.addTriangle(a,c,d);
  
  if(alreadyAddedVertex(curves[0].P[2]) != -1){
  e = alreadyAddedVertex(curves[0].P[2]);
  }
  else{
  e = mesh.addVertex(curves[0].P[2]);
  }
  mesh.addTriangle(e,a,d);
  
 if(alreadyAddedVertex(curves[kj-1].P[3]) != -1){
  f = alreadyAddedVertex(curves[kj-1].P[3]);
  }
  else{
  f = mesh.addVertex(curves[kj-1].P[3]);
  }
  mesh.addTriangle(e,d,f);
  
  if(alreadyAddedVertex(curves[0].P[3]) != -1){
  g = alreadyAddedVertex(curves[0].P[3]);
  }
  else{
    g = mesh.addVertex(curves[0].P[3]);
  }
  mesh.addTriangle(e,f,g);
  
  if(alreadyAddedVertex(curves[kj-1].P[4]) != -1){
  h = alreadyAddedVertex(curves[kj-1].P[4]);
  }
  else{
    h = mesh.addVertex(curves[kj-1].P[4]);
  }
   mesh.addTriangle(g,f,h);
  
//for(int i=0;i<curves[0].n;i++){
//  mesh.addVertex(curves[0].P[i]);
//}
//
//for(int i=0;i<curves[1].n;i++){
//  for(int j=0;j<mesh.nv;j++){
//  if(mesh.G[j].x != curves[1].P[i].x && mesh.G[j].y != curves[1].P[i].y && mesh.G[j].z != curves[1].P[i].z){
//    mesh.addVertex(curves[1].P[i]);
//  }
//}
//
//}
}

int alreadyAddedVertex(pt p){
  for(int j=0; j<mesh.nv; j++){
      //if(mesh.G[j] == p){
      if(mesh.G[j].x == p.x && mesh.G[j].y == p.y && mesh.G[j].z ==p.z){
       // println(j);
        return j;
      }
 }

//float tn = 9.01222222222;
//int test = Math.round(tn);
//println(test);
// println("p.x:" + Math.round(p.x) + " p.y:" + Math.round(p.y) + " p.z:" + Math.round(p.z));
// println("mesh.G[0].x" + Math.round(mesh.G[0].x) + " mesh.G[0].y:" + Math.round(mesh.G[0].y) + " mesh.G[0].z" + Math.round(mesh.G[0].z));
// println("mesh vertex size: " + mesh.nv);
 return -1;

}

void printrs(){
println("0x:" + curves[0].P[0].x);
println("0y:" + curves[0].P[0].y);
println("0z:" + curves[0].P[0].z);
println("1x:" + curves[1].P[0].x);
println("1y:" + curves[1].P[0].y);
println("1z:" + curves[1].P[0].z);
}

}
