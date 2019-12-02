package me.bo0tzz;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) {

        String in;
        try {
            in = new String(Files.readAllBytes(Paths.get("in.txt")));
        } catch (IOException e) {
            e.printStackTrace();
            return;
        }

        char[] chars = in.toCharArray();
        List<Character> out = new LinkedList<>();
        boolean currentlyGarbage = false;
        for (int i = 0; i < chars.length; i++) {
            char c = chars[i];
            switch(c) {
                case '!':
                    i++; //Skip the next character
                    break;
                case '<':
                    currentlyGarbage = true;
                    break;
                case '>':
                    currentlyGarbage = false;
                    break;
                default:
                    if (!currentlyGarbage) out.add(c);
            }
        }

        String clean = out.stream().map(String::valueOf).collect(Collectors.joining());

        int sum = 0;
        int depth = 0;
        for (Character c : clean.toCharArray()) {
            switch (c) {
                case '{':
                    depth++;
                    break;
                case '}':
                    sum += depth;
                    depth--;
                    break;
            }
        }

        System.out.println(sum);

    }
}
