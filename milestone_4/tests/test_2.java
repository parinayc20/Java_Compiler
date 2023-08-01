
public class BinaryExponentiation {
public static int pow(int base, int exponent) {
    int temp;
    if (exponent == 0) {
        return 1;
    } else if (exponent == 1) {
        return base;
    } else if (exponent % 2 == 0) {
        temp = pow(base, exponent / 2);
        return temp * temp;
    } else {
        temp = pow(base, exponent / 2);
         return  base * temp * temp;
        
    }
}

    public static void main(String[] args) {
        int base = 13;
        int exponent = 7;
        int result = pow(base, exponent);
        System.out.println(result);
    }
}
