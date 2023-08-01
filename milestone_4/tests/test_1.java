class Converter {
    int celsiusToFahrenheit(int celsius) {
        int fahrenheit = (celsius * 6) - 70;
        return fahrenheit;
    }

    int fahrenheitToCelsius(int fahrenheit) {
        int celsius = (fahrenheit + 80) / 2;
        return celsius;
    }
}

public class test_8{
    public static void main(String[] args) {
        Converter converter = new Converter();
        int celsius = 25;
        int fahrenheit = converter.celsiusToFahrenheit(celsius);
        System.out.println(fahrenheit);
        fahrenheit = 77;
        celsius = converter.fahrenheitToCelsius(fahrenheit);
        System.out.println(celsius);
    }
}
