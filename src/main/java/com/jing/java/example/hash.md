 # 简单介绍hash
 ### 1、hash是什么
 ### 2、hash与equal的关系
  - 相等的对象必须具有相等的hash值
  - hash值相等不一定相等
 ### 3、如何算hash
  -  Boolean  
  ```
      hash = （value? 1 : 0）
  ```
  -  byte、char、short、int  
  ```
      hash = int ( value )
  ```
  -  long 
  ```
     hash = (int)( value ^ ( value >>> 32) )
  ```
  -  float 
  ```
      hash = Float.floatToIntBits( value )
  ```
  -  double 
  ```    
      long = Double.doubleToLongBits( value ) <br/>
      hash = (int)( long ^ (long >>> 32) )
  ```
  -  String 
  ```
  int h = hash;
  if (h == 0 && value.length > 0) {
      char val[] = value;
  
      for (int i = 0; i < value.length; i++) {
          h = 31 * h + val[i];
      }
      hash = h;
  }
 ```
 - 对象
 ```
 public class User{
     private int age;
     private String name;
     public int hashCode() {
         int 
     
     }
    
 
 }
 ```