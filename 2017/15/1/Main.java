package me.bo0tzz.aoc;

import java.math.BigInteger;
import java.util.Iterator;

public class Main {

    public static void main(String[] args) {

        AoCGenerator g1 = new AoCGenerator(BigInteger.valueOf(16807), BigInteger.valueOf(2147483647), BigInteger.valueOf(703));
        AoCGenerator g2 = new AoCGenerator(BigInteger.valueOf(48271), BigInteger.valueOf(2147483647), BigInteger.valueOf(516));

        int matches = 0;

        for (int i = 0; i < 40000000; i++) {
            String g1s = g1.next().toString(2);
            String g2s = g2.next().toString(2);

            String g1bin;
            String g2bin;
            if (g1s.length() > 16) {
                g1bin = g1s.substring(g1s.length() - 16);
            } else {
                g1bin = g1s;
            }

            if (g2s.length() > 16) {
                g2bin = g2s.substring(g2s.length() - 16);
            } else {
                g2bin = g2s;
            }

            if (g1bin.equals(g2bin)) {
                matches++;
            }
        }

        System.out.println(matches);

    }

    public static class AoCGenerator implements Iterator<BigInteger> {

        private final BigInteger factor;
        private final BigInteger divBy;
        private BigInteger previous;

        public AoCGenerator(BigInteger factor, BigInteger divBy, BigInteger seed) {
            this.factor = factor;
            this.divBy = divBy;
            this.previous = seed;
        }

        @Override
        public boolean hasNext() {
            return true;
        }

        @Override
        public BigInteger next() {
            BigInteger value = previous.multiply(factor);
            previous =  value.remainder(divBy);
            return previous;
        }
    }
}
