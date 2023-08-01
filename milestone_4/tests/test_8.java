public class BubbleSort {
    public static void main(String[] args) {
        int[] arr = new int[5];
        arr[0] = 5;
        arr[1] = 4;
        arr[2] = 9;
        arr[3] = 1;
        arr[4] = 14;

        // Sort the array using bubble sort
        for (int i = 0; i < 5 - 1; i++) {
            for (int j = 0; j < 5 - i - 1; j++) {
                if (arr[j] > arr[j+1]) {
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
            }
        }

        // Print the sorted array
        for (int i = 0; i < 5; i++) {
            System.out.println(arr[i]);
        }
    }
}
