
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
         int result = 17;
         result = 31 * result + age;
         result = 31 * result + name.hashCode();
         return result;
     }
 }
 ```
 - 数组
 >  可以一个一个算，也可以直接调用Arrays.hashCode()
 #### 问题： 为什么要用 31 这个数
 - 使用素数减少信息丢失
 - 用移位和减法代替乘法，性能会更好 。例子：
  ``` 
  31 * i == (i << 5) - i;
  ```
 ### 4、hash冲突
  - jdk1.8 hashMap
  ```
    static final int hash(Object key) {
          int h;
          return (key == null) ? 0 : (h = key.hashCode()) ^ (h >>> 16);
     }
  ```
  - jdk1.7 hashMap 
  ```
      final int hash(Object k) {
          int h = hashSeed;
          if (0 != h && k instanceof String) {
              return sun.misc.Hashing.stringHash32((String) k);
          }
  
          h ^= k.hashCode();
  
          // This function ensures that hashCodes that differ only by
          // constant multiples at each bit position have a bounded
          // number of collisions (approximately 8 at default load factor).
          h ^= (h >>> 20) ^ (h >>> 12);
          return h ^ (h >>> 7) ^ (h >>> 4);
      }
      
      public static int murmur3_32(int var0, char[] var1, int var2, int var3) {
      			int var4 = var0;
      			int var5 = var2;
      
      			int var6;
      			int var7;
      			for(var6 = var3; var6 >= 2; var4 = var4 * 5 + -430675100) {
      				var7 = var1[var5++] & '\uffff' | var1[var5++] << 16;
      				var6 -= 2;
      				var7 *= -862048943;
      				var7 = Integer.rotateLeft(var7, 15);
      				var7 *= 461845907;
      				var4 ^= var7;
      				var4 = Integer.rotateLeft(var4, 13);
      			}
      
      			if (var6 > 0) {
      				char var8 = var1[var5];
      				var7 = var8 * -862048943;
      				var7 = Integer.rotateLeft(var7, 15);
      				var7 *= 461845907;
      				var4 ^= var7;
      			}
      
      			var4 ^= var3 * 2;
      			var4 ^= var4 >>> 16;
      			var4 *= -2048144789;
      			var4 ^= var4 >>> 13;
      			var4 *= -1028477387;
      			var4 ^= var4 >>> 16;
      			return var4;
      }
  ```
 ### 5、链地址法
 - 优势：处理hash冲突比较简单、 链表是动态的，大小不固定、节省空间、增删的操作比较简单、
 - 劣势： 当冲突比较多的时候，慢，另一个是指针需要额外空间
 
 ### 6、redis
  #### hash 算法-- MurmurHash2
   + 是一种非加密hash算法，适用于基于hash查找的场景
   + 能给出一个很好的随机分布性
   ______
   #### rehash
  - rehash
  - 渐进rehash