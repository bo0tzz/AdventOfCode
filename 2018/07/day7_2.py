import re
import string

step_re = re.compile('.* ([A-Z]) .* ([A-Z]) .*')


class Worker:

    def __init__(self):
        self.step = '.'
        self.duration = -2

    def assign(self, step, duration):
        self.step = step
        self.duration = duration

    def advance_time(self):
        self.duration -= 1

    def is_done(self):
        return self.duration == 0

    def is_working(self):
        return self.duration != -1

    def is_free(self):
        return self.duration <= -1

    def reset(self):
        self.assign('.', -1)

    def __repr__(self):
        return f"Worker(step = {self.step}, duration = {self.duration})"


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
    t = 0
    done = []
    workers = [Worker() for _ in range(5)]
    nwnie_sorted = sorted(find_nodes_with_no_incoming_edges(graph))
    assigned_nodes = []
    any_worker_working = any([worker.is_working() for worker in workers])

    # print('Second \t Worker 1 \t Worker 2 \t Done')
    while nwnie_sorted and any_worker_working:
        nwnie_sorted = clean_workers(done, graph, nwnie_sorted, workers)
        processable = [step for step in nwnie_sorted if step not in assigned_nodes]
        assigned_nodes = populate_workers(assigned_nodes, processable, workers)

        # print(f'{t} \t\t {workers[0].step} \t\t\t {workers[1].step} \t\t\t {done}')
        for worker in workers:
            if not worker.is_free():
                worker.advance_time()

        any_worker_working = any([worker.is_working() for worker in workers])
        if any_worker_working:
            t += 1
    return t


def populate_workers(assigned_nodes, processable, workers):
    for worker in workers:
        if processable and worker.is_free():
            node = processable.pop(0)
            worker.assign(node, string.ascii_uppercase.index(node) + 61)
            assigned_nodes += node
    return assigned_nodes


def clean_workers(done, graph, nwnie_sorted, workers):
    for worker in workers:
        if worker.is_done() and worker.step is not None:
            nwnie_sorted.remove(worker.step)
            done += worker.step
            worker.reset()
            for completed in done:
                children, graph[completed] = graph[completed], []
                for child in children:
                    no_incoming_edges = has_no_incoming_edges(graph, child)
                    if no_incoming_edges:
                        nwnie_sorted += child
                nwnie_sorted = sorted(list(set(nwnie_sorted)))  # Gross
    return nwnie_sorted


def run(puzzle_input):
    steps = [parse_step(step) for step in puzzle_input]
    graph = parse_graph(steps)
    result = topo_sort(graph)
    print(result)


with open('in.txt') as infile:
    run(infile.readlines())
    # I think this is my grossest code yet
