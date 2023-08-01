class Converter {
    double celsiusToFahrenheit(double celsius) {
        double fahrenheit = (celsius * 1.8) + 32;
        return fahrenheit;
    }

    double fahrenheitToCelsius(double fahrenheit) {
        double celsius = (fahrenheit - 32) / 1.8;
        return celsius;
    }
}

public class test_8{
    public static void main(String[] args) {
        Converter converter = new Converter();
        double celsius = 25.0;
        double fahrenheit = converter.celsiusToFahrenheit(celsius);
        System.out.println(celsius + " degrees Celsius is " + fahrenheit + " degrees Fahrenheit.");
        fahrenheit = 77.0;
        celsius = converter.fahrenheitToCelsius(fahrenheit);
        System.out.println(fahrenheit + " degrees Fahrenheit is " + celsius + " degrees Celsius.");
    }
}
