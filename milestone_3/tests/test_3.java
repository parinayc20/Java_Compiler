class Person {
  String name;
  int age;

  public void sayHello() {
    System.out.println("Hello, my name is " + name + " and I'm " + age + " years old.");
  }
}
public class test_3{
  public static void main (String[] args) {
    Person person1 = new Person();
    person1.name = "John";
    person1.age = 30;
    person1.sayHello();
  }
}
