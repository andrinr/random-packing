// Random Packing
// Andrin Rehmann, 2019

ArrayList<Shape> shapes;
ArrayList<V> points;

// Set the distance to other squares
float off = 0.01;

// Color 
float r = 0;
float g = 220;

// Set maximal shape size (s x s)
float s = 700;

void setup(){
  background(0);
  size(1000,1000);
  stroke(255);
  strokeWeight(1);
  
  shapes = new ArrayList<Shape>();
  points = new ArrayList<V>();
  
  //new Shape(width*2,height/12,new V(width/2,height/2)).testAndAdd();
}

void draw(){
  
  // Color animation
  r += (255 - r) * 0.003;
  g -= g * 0.003;
  stroke(120,r,g);
  
  Shape instance;
  for (int i = 0; i< 20; i++){
    do{
      
      instance = new Shape(
        random(1,s),
        random(1,s), 
        new V(random(width),random(height))
      );
      
    }
    while(!instance.testAndAdd());
  }
  
  // Decrease size, no accurate calculations behind this
  // this increases the efficency of the algorithm 
  // since over time the empty spaces get smaller
  if (s > 40)
    s-= 0.2;
  
}

class Shape{
  ArrayList<V> corners;
  ArrayList<V> vis;
  
  Shape(float w, float h, V pos){
    
    corners = new ArrayList<V>();
    
    corners.add(pos.copy().add(-w/2,-h/2)); 
    corners.add(pos.copy().add(w/2,-h/2));
    corners.add(pos.copy().add(w/2,h/2));
    corners.add(pos.copy().add(-w/2,h/2));
  
    // Visual represenation with additional offset
    vis = new ArrayList<V>();
    
    vis.add(corners.get(0).copy().add(off*w,off*h));
    vis.add(corners.get(1).copy().add(-off*w,off*h));
    vis.add(corners.get(2).copy().add(-off*w,-off*h));
    vis.add(corners.get(3).copy().add(off*w,-off*h));
  }
  
  void draw(){
    for (int i = 0; i < vis.size(); i++){
      V a = vis.get(i);
      V b = vis.get((i+1)%vis.size());
      line(a.x(), a.y(), b.x(), b.y());
    }
  }
  
  boolean isInside(V point){
    int j = 0;
      
      for (int i = 0; i < corners.size(); i++){
        
        V a = corners.get(i);
        V b = corners.get((i+1)%corners.size());
        
        if (point.isLeft(a,b))
          j++;
        
      }
      
      return j == corners.size();
  }
  
  boolean testAndAdd() {
    
    // Check if any point is inside this shape
    for (V point : points) 
      if (isInside(point))
        return false;
        
   
    for (Shape shape : shapes){
      // Check if any corner point is inside other shape
      for (V corner : corners)
        if (shape.isInside(corner))
          return false;
      
      // Check if any line intersects with other lines
      for (int i = 0; i < corners.size(); i++){
         
        V a = corners.get(i);
        V b = corners.get((i+1)%corners.size());  
         
        for (int j = 0; j < shape.corners.size(); j++){
          
          V c = shape.corners.get(j);
          V d = shape.corners.get((j+1)%shape.corners.size());  
           
          if (linesDoIntersect(a,b,c,d))
            return false;
            
         }
      }
    }
    
    // update data structure
    for (V corner : corners)
      points.add(corner);
      
    shapes.add(this);
    
    // draw shape
    this.draw();
    
    return true;
  }
  
  // Copy-pasta line intersection
  boolean linesDoIntersect(V p0, V p1, V p2, V p3)
  {
    double s1_x, s1_y, s2_x, s2_y;
    s1_x = p1.x - p0.x;  s1_y = p1.y - p0.y;
    s2_x = p3.x - p2.x;  s2_y = p3.y - p2.y;

    double s, t;
    s = (-s1_y * (p0.x - p2.x) + s1_x * (p0.y - p2.y)) / (-s2_x * s1_y + s1_x * s2_y);
    t = ( s2_x * (p0.y - p2.y) - s2_y * (p0.x - p2.x)) / (-s2_x * s1_y + s1_x * s2_y);

    return (s >= 0 && s <= 1 && t >= 0 && t <= 1);

  }
}

void keyPressed(){
  saveFrame("line-######.png");
}
