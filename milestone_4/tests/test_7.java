class A {
    int a, b;
    void display(int c) {
        System.out.println(c);
    }
}

class test_7 {
    int a, aa;
    public void main() {
        int b = 5;
        a = 3;
        A c = new A();
        c.a = a;
        c.b = b;
        aa = c.a + c.b;
        c.display(aa);
    }
}