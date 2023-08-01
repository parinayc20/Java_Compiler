class Person {
    String name;
    int age;

    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }

    void sayHello() {
        System.out.println("Hello, my name is " + name + ".");
    }

    void sayAge() {
        System.out.println("I am " + age + " years old.");
    }
}

public class test_9{
    public static void main(String[] args) {
        Person person1 = new Person("Alice", 25);
        person1.sayHello();
        person1.sayAge();

        Person person2 = new Person("Bob", 30);
        person2.sayHello();
        person2.sayAge();
    }
}
