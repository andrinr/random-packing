// Light weight Vector class
// Andrin Rehmann, 2019

V tmp = new V(0,0);
class V{
  double x;
  double y;
  
  V(double x, double y){
    this.x = x;
    this.y = y;
  }
  
  V(V other){
    this.x = 0;
    this.y = 0;
    this.add(other);
  }
  
  V set(V other){
    this.x = other.x;
    this.y = other.y;
    return this;
  }
  
  // return distance vector to other point
  V distVec(V other){
    return new V(other).sub(this);
  }
  
  // subtraction
  V sub(V other){
    this.x -= other.x;
    this.y -= other.y;
    return this;
  }
  
  // subtraction
  V sub(double x, double y){
    this.x -= x;
    this.y -= y;
    return this;
  }
  
  // addition
  V add(V other){
    this.x += other.x;
    this.y += other.y;
    return this;
  }
  
    // subtraction
  V add(double x, double y){
    this.x += x;
    this.y += y;
    return this;
  }
  
  // multiply by scalar
  V mulS(double f){
    this.x *= f;
    this.y *= f;
    return this;
  }
  
  V divS(double f){
    this.x /= f;
    this.y /= f;
    return this;
  }
  
  V rot(V pivot, float angle){
    tmp.set(this);
    this.x = Math.cos(angle) * (tmp.x - pivot.x) - Math.sin(angle) * (tmp.y-pivot.y) + pivot.x;
    this.y = Math.sin(angle) * (tmp.x - pivot.x) + Math.cos(angle) * (tmp.y - pivot.y) + pivot.y;
    return this;
  }
  
  // normalize
  V norm(){
    this.divS(this.l());
    return this;
  }
  
  // copy
  V copy(){
    return new V(this);
  }
  
  boolean isLeft(V a, V b){
    
    return ((a.x - x)*(b.y - y) > (a.y - y)*(b.x - x));
      
  }
  
  // Get length
  double l(){
    return Math.sqrt(this.x * this.x + this.y * this.y);
  }
    
  float x(){
    return (float) this.x;
  }
  
  float y(){
    return (float) this.y;
  }
}
