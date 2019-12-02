import std.stdio;

struct Node {
    string name;
    int weight;
    Node[] children;
}

struct RawNode {
    string name;
    int weight;
    string[] children;
}

RawNode parseLine(char[] line) {
  import std.algorithm.searching: canFind;
  import std.regex: split, regex;
  import std.format: formattedRead;
  import std.string: strip, chompPrefix;

  string name;
  int weight;
  string[] children;

  formattedRead(line, "%s (%d)", &name, &weight);
  if (canFind(line, ['-','>'])) {
    string childString = strip(chompPrefix(strip(line.idup), "->"));
    children = split(childString, regex(", ", "g"));
  }
  return RawNode(name, weight, children);
}

Node parseRaw(RawNode[] rn) {
  import std.algorithm.searching: find;
  import std.algorithm.mutation: remove;
  import std.algorithm.searching: countUntil;
  Node[] parsed;
  while (rn.length > 0) {
    auto r = rn[0];
    if (r.children.length == 0) {
      parsed ~= Node(r.name, r.weight, []);
      rn = rn.remove(0);

    } else {
      Node[] children;
      foreach (string child; r.children) {
        auto childNode = (find!((a,b) => a.name == b.name)(parsed, Node(child, 0, [])));
        if (childNode.length > 0) {
          children ~= childNode[0];
        }
      }
      if (r.children.length == children.length) {
        foreach (Node child; children) {
          long j = countUntil!((a,b) => a.name == b.name)(parsed, child);
          if (j >= 0) parsed = parsed.remove(j);
        }
        parsed ~= Node(r.name, r.weight, children);
        rn = rn.remove(0);
      } else {
        rn = rn.remove(0) ~ (r);
      }
    }
  }
  return parsed[0];
}

void main()
{
  import std.array: array;
  auto file = File("in.txt");
  auto lines = file.byLine();
  RawNode[] rawNodes;
  foreach (char[] line; lines) {
      RawNode n = parseLine(line);
      rawNodes ~= (n);
  }
  Node parsed = parseRaw(rawNodes);
  writeln(parsed.name);
}
