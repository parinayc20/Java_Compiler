public class test_10 {
   public static int fibonacci(int n) {
        int prev1 = 0;
        int prev2 = 1;
        int fib = 0;
        if (n <= 1) {
            return n;
        }
        System.out.println(prev2);
        // fib =0;
        for (int i = 2; i <= n; i++) {
            fib = prev1 + prev2;
            prev1 = prev2;
            prev2 = fib;
            System.out.println(fib);
        }
        return fib;
    }

    public static int main() {
        int mn = 10;
        int fib = fibonacci(mn);
        return 0;
    }
}