public class test_4 {
    public static void main(String[] args) {
        int n = 987;

        while (n != 1) {
            System.out.println(n + " -> ");
            if (n % 2 == 0) {
                n = n / 2;
            } else {
                n = 3 * n + 1;
            }
        }

        System.out.println(n);
        System.out.println("Collatz Conjecture is verified for the number 987.");
    }
}
