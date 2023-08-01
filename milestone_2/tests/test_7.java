class Calculator {
    int add(int x, int y) {
        int result = x + y;
        return result;
    }

    int subtract(int x, int y) {
        int result = x - y;
        return result;
    }

    int multiply(int x, int y) {
        int result = x * y;
        return result;
    }

    int divide(int x, int y) {
        int result = x / y;
        return result;
    }
}

public class test_7{
    public static void main(String[] args) {
        Calculator calc = new Calculator();
        int x = 5;
        int y = 3;
        int result = calc.add(x, y);
        System.out.println("Result of add: " + result);
        result = calc.subtract(x, y);
        System.out.println("Result of subtract: " + result);
        result = calc.multiply(x, y);
        System.out.println("Result of multiply: " + result);
        result = calc.divide(x, y);
        System.out.println("Result of divide: " + result);
    }
}
