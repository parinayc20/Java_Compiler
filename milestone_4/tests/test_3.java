public class test_3 {
   public static int factorial(int n) {
        if(n == 0) {
            return 1;
        } else {
            return n * factorial(n-1);
        }
    }

    public static int main() {
        int n = 10;
        int fib = factorial(n);
        System.out.println(fib);
        return 0;
    }
}
