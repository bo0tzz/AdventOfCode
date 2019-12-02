import re

step_re = re.compile('.* ([A-Z]) .* ([A-Z]) .*')


def parse_step(step: str):
    match = step_re.match(step)
    return match.group(1, 2)


def find_all_child_nodes(graph: dict) -> set:
    child_nodes = set()
    for value in graph.values():
        child_nodes.update(value)
    return child_nodes


def parse_graph(edges: list):
    graph = {}
    for edge in edges:
        graph.setdefault(edge[0], [])
        graph[edge[0]] += edge[1]
    for value in find_all_child_nodes(graph):
        if value not in graph.keys():
            graph[value] = []
    return graph


def find_nodes_with_no_incoming_edges(graph: dict) -> list:
    nodes_with_incoming_edges = set()
    for value in graph.values():
        nodes_with_incoming_edges.update(value)
    return [node for node in graph.keys() if node not in nodes_with_incoming_edges]


def has_no_incoming_edges(graph: dict, node: str) -> bool:
    no_incoming_edges = find_nodes_with_no_incoming_edges(graph)
    return node in no_incoming_edges


def topo_sort(graph: dict) -> str:
    o = ''
    nwnie_sorted = sorted(find_nodes_with_no_incoming_edges(graph))
    while nwnie_sorted:
        node = nwnie_sorted[0]
        nwnie_sorted.remove(node)
        o += node
        children, graph[node] = graph[node], []
        for child in children:
            no_incoming_edges = has_no_incoming_edges(graph, child)
            if no_incoming_edges:
                nwnie_sorted += child
        nwnie_sorted = sorted(list(set(nwnie_sorted)))  # Gross
    return o


def run(puzzle_input):
    steps = [parse_step(step) for step in puzzle_input]
    graph = parse_graph(steps)
    result = topo_sort(graph)
    print(result)


with open('in.txt') as infile:
    run(infile.readlines())
