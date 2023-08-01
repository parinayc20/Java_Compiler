class Math{
    public static int max(int a, int b) {
        if (a > b) 
            return a; 
        else
            return b;
    }
}
public class test_5 {
    public static void main(String[] args) {
        int[] values = new int[3];
        int[] weights = new int[3];
        int capacity = 50;
        values[0] = 60;
        values[1] = 100;
        values[2] = 120;
        weights[0] = 10;
        weights[1] = 20;
        weights[2] = 30;
        int n = 3;
        int[][] dp = new int[n+1][capacity+1];

        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= capacity; j++) {
                if (weights[i-1] > j) {
                    dp[i][j] = dp[i-1][j];
                } else {
                    dp[i][j] = Math.max(dp[i-1][j], dp[i-1][j-weights[i-1]] + values[i-1]);
                }
            }
        }

        System.out.println("Maximum value that can be obtained: " + dp[n][capacity]);
    }
}
