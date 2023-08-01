package com.thealgorithms.others;

import java.util.*;
import java.util.Scanner;

/**
 * For detailed info and implementation see: <a
 * href="http://devmag.org.za/2009/04/25/perlin-noise/">Perlin-Noise</a>
 */
public class PerlinNoise {
    static float[][] generatePerlinNoise(
        int width,
        int height,
        int octaveCount,
        float persistence,
        long seed
    ) {
        final float[][] base = new float[width][height];
        final float[][] perlinNoise = new float[width][height];
        final float[][][] noiseLayers = new float[octaveCount][][];

        Random random = new Random(seed);
        // fill base array with random values as base for noise
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                base[x][y] = random.nextFloat();
            }
        }
        class a2{
            int a2;
            int b2;
        }

}
}
