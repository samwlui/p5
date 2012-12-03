class Mapping {
	Mesh m1;
	Mesh m2;
	HashMap<Integer, List<Integer>> vtof;
	HashMap<Integer, List<pt>> ftov;
	HashMap<Edge, List<Edge>> etoe;

   Mapping(Mesh tempA, Mesh tempB) {
		this.m1 = tempA;
		this.m2 = tempB;
		vtof = new HashMap<Integer, List<Integer>>();
		ftov = new HashMap<Integer, List<pt>>();
		etoe = new HashMap<Edge, List<Edge>>();
		faceToVertex();
		vertexToFace();
		edgeToEdge();
	}
      void faceToVertex() {
        for (int i = 0; i < m1.nt; i++) {
	ArrayList<pt> vertices = new ArrayList<pt>();
	  for (int j = 0; j < m2.nc; j++) {
	    if (checklsd(m1.Nt[i], m2, m2.V[j])) {
	      vertices.add(m2.G[m2.V[j]]);
	    }
	      }
	ftov.put(i, vertices);
          }
	}
    void vertexToFace() {
      for (int i = 0; i < m1.nc; i++) {
	ArrayList<Integer> faces = new ArrayList<Integer>();
	 for (int j = 0; j < m2.nt; j++) {
          if (checklsd(m2.Nt[j], m1, m1.V[i])) {
	   faces.add(j);
	    }
        vtof.put(i, faces);
			}
		}
	}
  boolean checklsd(vec N, Mesh m, int v) {
	  List<Edge> edges = m.eMap.get(v);
	  for (Edge edge : edges) {
	    if (d(N, V(edge)) >= 0) return false;
	  }
	return true;
	}
  void edgeToEdge() {
	for (Edge e : m1.edges) {
	  ArrayList<Edge> eList = new ArrayList<Edge>();
	   for (Edge e2 : m2.edges) {
	   if(verifyE(e,m1,e2,m2)){
		eList.add(e2);
            }
	      }
	  etoe.put(e, eList);
	    }
	}
 boolean verifyE(Edge e1, Mesh a, Edge e2, Mesh b){
  vec norm = getNormal(e1,e2);
  ArrayList<vec> e1tangents = getTangents(e1,a);
  ArrayList<vec> e2tangents = getTangents(e2,b);
     for (vec e1tangent : e1tangents){
  	if ( d(norm,e1tangent) >= 0 ){
  	return false;
  	}
   }
  for(vec e2tangent : e2tangents){
    if ( d(norm,e2tangent) >= 0){
      return false;
      }
      }
    return true;
    }
   pt get2MV(int v) {
    return m2.G[m2.V[v]];
    }
  void clear() {
    m1 = null;
    m2 = null;
    vtof.clear();
    ftov.clear();
    etoe.clear();
  }
  void remap() {
    vtof.clear();
    ftov.clear();
    etoe.clear();
    faceToVertex();
    vertexToFace();
    edgeToEdge();
   }
  vec getNormal(Edge e, Mesh m){
    return V(m.Nt[e.tr.get(0)],m.Nt[e.tr.get(1)]);
  }
  vec getNormal(Edge a, Edge b){
    return N(V(a),V(b));
  }
  vec getTangent(Edge e, vec v){
    return N(V(e),v);
  }
     ArrayList<vec> getTangents(Edge e, Mesh m){
    	ArrayList<vec> tans = new ArrayList<vec>();
    	for(int tri : e.tr){
      	  tans.add(getTangent(e,m.Nt[tri]));
    	}
    	return tans;
  	}
 
}
