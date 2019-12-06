class Node:
    def __init__(self, name, children=None):
        self.name = name
        self.children = children if children else []
        self.parent = None

    def add_child(self, c):
        self.children.append(c)
        c._set_parent(self)

    def _set_parent(self, p):
        self.parent = p

    def __str__(self):
        s = "Node(name='"
        s += self.name
        s += "', children=["
        for child in self.children:
            s += "'"
            s += child.name
            s += "',"
        s += "])"
        return s

    def __repr__(self):
        return str(self)

    def count_children(self):
        children_count = len(self.children)
        for child in self.children:
            children_count += child.count_children()
        return children_count

    def find(self, node_name, previous=None):
        candidates = self.children.copy()
        candidates.append(self.parent)
        if previous in candidates:
            candidates.remove(previous)
        for candidate in candidates:
            if candidate.name == node_name:
                return [self]
            found = candidate.find(node_name, self)
            if found:
                found.append(self)
                return found
        return []


with open('in', 'r') as infile:
    lines = infile.readlines()
    nodes = {}
    for line in lines:
        parent_name, child_name = map(str.strip, line.split(')'))
        parent = nodes.get(parent_name, Node(parent_name))
        child = nodes.get(child_name, Node(child_name))

        parent.add_child(child)
        nodes[parent_name] = parent
        nodes[child_name] = child

    my_orbit = nodes['YOU'].parent
    path = my_orbit.find('SAN')
    print(len(path) - 1)

