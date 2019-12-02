class Node:

    def __init__(self, children: list, metadata: list):
        self.children = children
        self.metadata = metadata

    def sum_metadata(self) -> int:
        queue = [self]
        result = 0
        while queue:
            node = queue.pop()
            queue.extend(node.children)
            result += sum(node.metadata)
        return result

    def value(self) -> int:
        result = 0
        if len(self.children) == 0:
            return sum(self.metadata)
        else:
            for i in self.metadata:
                child = self.children[i-1] if i-1 < len(self.children) else null_node
                result += child.value()
        return result

    def __repr__(self):
        return f"Node(children={self.children}, metadata={self.metadata})"


null_node = Node([], [])


def parse_tree(node: list) -> (Node, str):
    child_header, metadata_header = int(node[0]), int(node[1])
    children = []
    if child_header == 0:  # End condition
        return Node(children, [int(m) for m in node[2:2+metadata_header]]), node[2+metadata_header:]
    else:
        remaining = node[2:]
        for n in range(child_header):
            child, remaining = parse_tree(remaining)
            children.append(child)
        metadata, remaining = [int(m) for m in remaining[:metadata_header]], remaining[metadata_header:]
        return Node(children, metadata), remaining


def run(puzzle_input: str):
    root_node, remaining = parse_tree(puzzle_input.split(' '))
    print(root_node.value())


with open('in.txt') as infile:
    run(infile.readline())

