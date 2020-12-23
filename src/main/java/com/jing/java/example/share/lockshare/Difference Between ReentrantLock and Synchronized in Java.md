# Difference Between ReentrantLock and Synchronized in Java

[Java](https://www.tutorialspoint.com/questions/category/Java)[Object Oriented Programming](https://www.tutorialspoint.com/questions/category/Object-Oriented-Programming)[Programming](https://www.tutorialspoint.com/questions/category/Programming)

------

<iframe frameborder="0" src="https://e79083cf8ef159e8821d0bdd7eb164c1.safeframe.googlesyndication.com/safeframe/1-0-37/html/container.html" id="google_ads_iframe_/21766281334/901_Tutorialspoint.com/901_Tutorialspoint.com_32_0" title="3rd party ad content" name="" scrolling="no" marginwidth="0" marginheight="0" width="650" height="150" data-is-safeframe="true" sandbox="allow-forms allow-popups allow-popups-to-escape-sandbox allow-same-origin allow-scripts allow-top-navigation-by-user-activation" data-google-container-id="3" data-load-complete="true" style="border: 0px; vertical-align: bottom;"></iframe>

------

There are two ways to get a lock on the shared resource by multiple threads. One is Reentrant Lock (Or ReadWriteLock ) and the other is by using the Synchronized method.

ReentrantLock class has been provided in Java concurrency package from Java 5. 

It is the implementation of Lock interface and According to java docs, implementation of Lock interface provides more extensive operation than can be obtained using synchronized method.

| Sr. No. |         Key          |                        ReentrantLock                         |                         Synchronized                         |
| ------- | :------------------: | :----------------------------------------------------------: | :----------------------------------------------------------: |
| 1       |     Acquire Lock     | Reentrant lock class provides lock() methods to get a lock  on the shared resource by thread | You need to just write synchronized keyword to acquire a lock |
| 2       |     Release Lock     |  To release lock , programmers have to call unlock() method  |                    It is done implicitly                     |
| 3       | Ability to interrupt | lockInterruptibly() method can be used to interrupt the thread |           There is no way to interrupt the thread            |
| 4       |       Fairness       | Constructor of this class has fairness parameter. If it is set to true then locks favor granting access to the longest-waiting  * thread |     Lock does not guarantee any particular  access orde      |
| 5       |  Lock Release Order  |              Lock can be released in any order               | Lock should be released in the same order in which they were acquired |

## Example of ReentrantLock

```
public class ReentrantLockExample implements Runnable{
   private Lock lock=new ReentrantLock();
   @Override
   public void run() {
      try {
         lock.lock()
         //Lock some resource

      }
      catch (InterruptedException e) {
         e.printStackTrace();
      }
      finally {
         lock.unlock();
      }
   }
}
```

## Example of SynchronizedLock

```
public class SynchronizedLockExample implements Runnable{
   @Override
   public void run() {
      synchronized (resource) {
         //Lock some resource
      }
   }
```