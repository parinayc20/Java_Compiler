// Java Program to Illustrate Static Nested Classes

// Importing required classes
import java.util.*;

// Class 1
// Outer class
class Outer {

	// Method
	private static void outerMethod()
	{

		// Print statement
		System.out.println("inside outerMethod");
	}

	// Class 2
	// Static inner class
	static class Inner {

		public static void display()
		{

			// Print statement
			System.out.println("inside inner class Method");

			// Calling method inside main() method
			outerMethod();
		}
	}
}

// Class 3
// Main class
class GFG {

	// Main driver method
	public static void main(String args[])
	{

		// Calling method static display method rather than an instance of that class.
		Outer.Inner.display();
	}
}

