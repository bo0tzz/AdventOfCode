import std.stdio;

struct Node {
    string name;
    int weight;
    Node[] children;
    int childrenWeight;
    int cumWeight;
    bool balanced;
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
      parsed ~= Node(r.name, r.weight, [], 0, 0, false);
      rn = rn.remove(0);

    } else {
      Node[] children;
      foreach (string child; r.children) {
        auto childNode = (find!((a,b) => a.name == b.name)(parsed, Node(child, 0, [], 0, 0, false)));
        if (childNode.length > 0) {
          children ~= childNode[0];
        }
      }
      if (r.children.length == children.length) {
        foreach (Node child; children) {
          long j = countUntil!((a,b) => a.name == b.name)(parsed, child);
          if (j >= 0) parsed = parsed.remove(j);
        }
        parsed ~= Node(r.name, r.weight, children, 0, 0, false);
        rn = rn.remove(0);
      } else {
        rn = rn.remove(0) ~ (r);
      }
    }
  }
  return parsed[0];
}

bool balanced(int[] weights) {
  int val = weights[0];
  for (int i = 1; i < weights.length; i++) {
    if (val != weights[i]) return false;
  }
  return true;
}

// Return the count of most common occurrences
// int mostCommon(int[] intArray) {
//   int[int] occurrences;
//   foreach (int i; intArray) {
//     occurrences[i] += 1;
//   }
//
//   int mostCommonEntry;
//   foreach (int entry; occurrences.byValue()) {
//     if (entry > mostCommonEntry) mostCommonEntry = entry;
//   }
//   return mostCommonEntry;
// }

Node calcWeights(Node root) {
  if (root.children.length > 0) {
    Node[] newChildren;
    int[] weights;
    foreach (Node child; root.children) {
      Node newChild = calcWeights(child);
      newChildren ~= newChild;
      weights ~= newChild.cumWeight;
      root.childrenWeight += newChild.cumWeight;
    }
    root.balanced = balanced(weights);
    root.children = newChildren;
    root.cumWeight = root.childrenWeight + root.weight;
    return root;
  } else {
    root.balanced = true;
    root.cumWeight = root.weight;
    return root;
  }
}

// Node calcWeights(Node n) {
//   write("Calculating weights for node "); writeln(n.name);
//   int tot = 0;
//   writeln("Going over children: ");
//   foreach (Node m; n.children) writeln(m);
//   int[] weights;
//   Node[] children;
//   foreach (Node m; n.children) {
//     Node o = calcWeights(m);
//     tot += o.cumWeight;
//     children ~= o;
//     weights ~= o.cumWeight;
//   }
//   n.balanced = balanced(weights);
//   writeln(n.balanced);
//   write("Finished calculating weights for node "); writeln(n.name);
//   writeln(tot);
//   n.children = children;
//   n.childrenWeight = tot;
//   n.cumWeight = tot + n.weight;
//   return n;
// }

Node findCulprit(Node root) {
  if (!root.balanced) {
    if (root.children.length > 0) {
      foreach (Node child; root.children) {
        if (!child.balanced) {
          return findCulprit(child);
        }
      }
    }
    return root;
  }
  //This should never happen
  return Node("Something went wrong", 0, [], 0, 0, false);
}

// Node findCulprit(Node root) {
//   Node unbalancedChild;
//   if (root.weight == 0) {
//     write("Something is wrong with node "); writeln(root);
//     return Node("Something went wrong", 0, [], 0, 0, false);
//   }
//   write("Going through children of node "); writeln(root);
//   foreach (Node n; root.children) {
//     write("For child "); writeln(n);
//     if (!n.balanced) {
//       writeln("Child was unbalanced!");
//       unbalancedChild = n;
//       break;
//     }
//   }
//   if (is(typeof(unbalancedChild))) {
//     writeln("Found unbalanced child. Going deeper");
//     write("Unbalanced child is: "); writeln(unbalancedChild);
//     return findCulprit(unbalancedChild);
//   } else if (!root.balanced) {
//     writeln("This node was unbalanced. Back up we go");
//     return root;
//   }
//   writeln("I don't think this should happen");
// }

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

  write("Starting weights calculation on node "); writeln(parsed.name);
  Node newroot = calcWeights(parsed);
  write("Calculated new weights, output is "); writeln(newroot);
  writeln(newroot.cumWeight);
  write("Finding culprit from root "); writeln(newroot);
  Node culprit = findCulprit(newroot);
  write("Found culprit: "); writeln(culprit);


}
