public class HighDimensionalArray {
    public static void main(String[] args) {
        int[][][] array3D = new int[3][4][5];
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 5; k++) {
                    array3D[i][j][k] = (i+1)*(j+1)*(k+1);
                }
            }
        }
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 4; j++) {
                for (int k = 0; k < 5; k++) {
                    System.out.println(array3D[i][j][k]);
                }
                
            }
        }
    }
}
