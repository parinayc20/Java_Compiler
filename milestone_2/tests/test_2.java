public class test_2 { 

    public static void main(String[] args) {
        int input = 0;
        
        while (input != 4) {
            System.out.println("Please select an option:");
            System.out.println("1. Print 'Hello'");
            System.out.println("2. Print 'World'");
            System.out.println("3. Print 'Hello World'");
            System.out.println("4. Exit");
            
            input = 2;
            
            switch (input) {
                case 1:
                    System.out.println("Hello");
                    break;
                case 2:
                    System.out.println("World");
                    break;
                case 3:
                    System.out.println("Hello World");
                    break;
                case 4:
                    System.out.println("Exiting program...");
                    break;
                default:
                    System.out.println("Invalid input, please try again.");
                    break;
            }
        }
    }
}
