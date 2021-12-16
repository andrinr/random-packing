// Light weight Vector class
// Andrin Rehmann, 2019

Vector tmp = new Vector(0,0);
class Vector{
  double x;
  double y;
  
  Vector(double x, double y){
    this.x = x;
    this.y = y;
  }
  
  Vector(Vector other){
    this.x = 0;
    this.y = 0;
    this.add(other);
  }
  
  Vector set(Vector other){
    this.x = other.x;
    this.y = other.y;
    return this;
  }
  
  // return distance vector to other point
  Vector distVec(Vector other){
    return new Vector(other).sub(this);
  }
  
  // subtraction
  Vector sub(Vector other){
    this.x -= other.x;
    this.y -= other.y;
    return this;
  }
  
  // subtraction
  Vector sub(double x, double y){
    this.x -= x;
    this.y -= y;
    return this;
  }
  
  // addition
  Vector add(Vector other){
    this.x += other.x;
    this.y += other.y;
    return this;
  }
  
  // addition
  Vector add(double x, double y){
    this.x += x;
    this.y += y;
    return this;
  }
  
  // multiply by scalar
  Vector mulS(double f){
    this.x *= f;
    this.y *= f;
    return this;
  }
  
  Vector divS(double f){
    this.x /= f;
    this.y /= f;
    return this;
  }
  
  Vector rot(Vector pivot, float angle){
    tmp.set(this);
    this.x = Math.cos(angle) * (tmp.x - pivot.x) - Math.sin(angle) * (tmp.y-pivot.y) + pivot.x;
    this.y = Math.sin(angle) * (tmp.x - pivot.x) + Math.cos(angle) * (tmp.y - pivot.y) + pivot.y;
    return this;
  }
  
  // normalize vector
  Vector norm(){
    this.divS(this.l());
    return this;
  }
  
  // Copy current vector to create new instance and make computations on
  Vector copy(){
    return new Vector(this);
  }
  
  boolean isLeft(Vector a, Vector b){
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
