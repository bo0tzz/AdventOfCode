package me.bo0tzz.aoc;

import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.*;
import java.util.stream.Collectors;

public class Main {

    public static void main(String[] args) {

        Path input = FileSystems.getDefault().getPath("./", "input.txt");
        List<Vertex> vertices;
        try {
            vertices = Files.lines(input).map(Vertex::fromString).collect(Collectors.toList());
        } catch (IOException e) {
            System.out.println("Shit fucked up");
            e.printStackTrace();
            return;
        }
        Graph g = new Graph(vertices);
        int connected = g.connectedTo(g.getById(0), null).size();
        System.out.println(connected);
    }

    static class Vertex{
        private final int id;
        private final List<Integer> neighbours;

        public Vertex(int id, List<Integer> neighbours) {
            this.id = id;
            this.neighbours = neighbours;
        }

        public static Vertex fromString(String in) {
            StringTokenizer st = new StringTokenizer(in, " <->,", false);
            int id = Integer.parseInt(st.nextToken());
            Integer[] tokens = new Integer[st.countTokens()];
            int i = 0;
            while (st.hasMoreTokens()) {
                tokens[i++] = Integer.parseInt(st.nextToken());
            }
            return new Vertex(id, Arrays.asList(tokens));
        }

        public List<Integer> getNeighbours() {
            return neighbours;
        }

        public int getId() {
            return id;
        }

        public boolean adjacent(Vertex v) {
            return neighbours.contains(v.id);
        }

        @Override
        public boolean equals(Object obj) {
            if (!(obj instanceof Vertex)) return false;
            Vertex v = (Vertex)obj;
            if (v == this) return true;
            if (v.id == this.id && v.neighbours.equals(this.neighbours)) return true;
            return false;
        }

        @Override
        public int hashCode() {
            return Objects.hash(this.id, this.neighbours);
        }

        @Override
        public String toString() {
            return "Vertex{id: " + this.id + ", neighbours: " + this.neighbours.toString() + "}";
        }
    }

    static class Graph {
        private final List<Vertex> vertices;

        public Graph(List<Vertex> vertices) {
            this.vertices = vertices;
        }

        public void addVertex(Vertex v) {
            vertices.add(v);
        }

        public List<Vertex> getVertices() {
            return vertices;
        }

        public Vertex getById(int id) {
            return vertices.stream().filter(v -> v.id == id).findFirst().orElse(null);
        }

        @Override
        public String toString() {
            return vertices.toString();
        }

        // Wooooooo recursion in java :D
        public Set<Vertex> connectedTo(Vertex v, Set<Vertex> visited) {
            if (visited == null) visited = new HashSet<>();
            if (visited.contains(v)) return visited;
            Set<Vertex> out = visited;
            out.add(v);
            v.neighbours.forEach(integer -> {
                Vertex w = this.getById(integer);
                if (w != null) {
                    out.addAll(connectedTo(w, out));
                    out.add(w);
                }
            });
            return out;
        }
    }
}
