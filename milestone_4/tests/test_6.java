public class test_6 { 

      public static void main(String[] args) {
            int n = 100;
               int[] isPrime = new int[n+1];
    for (int i = 2; i <= n; i++) {
        isPrime[i] = 1;
    }
    for (int i = 2; i*i <= n; i++) {
        if (isPrime[i] == 1) {
            for (int j = i*i; j <= n; j += i) {
                isPrime[j] = 0;
            }
        }
    }
    for (int i = 2; i <= n; i++) {
        if (isPrime[i] == 1) {
            System.out.println(i);
        }
    }
}
}