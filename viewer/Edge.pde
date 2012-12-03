class Edge{
  
  pt A = P(); 
  pt B = P();
  List<Integer> tr;
  public Edge(pt tempA, pt tempB){
    this.A = tempA; 
    this.B = tempB; 
    tr = new ArrayList<Integer>();
  }
 Edge(pt A, pt B, int nt) {
    this(A, B);
    tr.add(nt);
  }
   
  public boolean equals(Object o) {
    Edge e = (Edge) o;
    return (this.A == e.A && this.B == e.B) || (this.A == e.B && this.A == e.B);
  }
  public int hashCode() {
    return (int) (A.x + A.y + A.z + B.x + B.y + B.z);
  }
  
  void addTri(int t) {
      tr.add(t);
  }

}




