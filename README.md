# Travelling Thief Problem

The Travelling Thief Problem (TTP) is a combinatorial optimization problem that couples two classical NP-hard problems — the Travelling Salesman Problem and the 0/1 Knapsack Problem — in a way that makes them impossible to solve independently.

A thief travels through a set of cities, visiting each exactly once. At every city, there are items available to steal. The thief carries a knapsack with a fixed weight capacity, and the more items packed, the heavier the bag — and the slower the thief moves. Since the thief rents the knapsack and pays per unit of travel time, carrying more weight increases cost. The goal is to find a route and a set of items that maximizes:

```
Total profit from items  −  (Travel time  ×  Rent rate)
```

What makes TTP genuinely hard is the coupling. A shorter route isn't always better — it might mean passing through low-value cities first. Grabbing more items isn't always better — the slowdown might cost more than the profit gained. Every decision about the route affects the value of item decisions, and vice versa.

---

## Implementation

This is a MATLAB implementation using a hybrid metaheuristic approach.

Each candidate solution pairs a **tour** (an ordered sequence of cities) with a **sack** (a binary vector indicating which items to steal). The objective is evaluated by simulating the thief walking the tour city by city, collecting selected items, slowing down as the bag grows heavier, and computing the final profit minus rent.

The search is driven by an **Artificial Bee Colony (ABC)** algorithm — a population-based method inspired by the foraging behaviour of bees. A colony of solutions is maintained and evolved over iterations through three phases:

- **Employed bees** each own a solution and attempt to improve it via local search.
- **Onlooker bees** observe the colony and preferentially explore the more promising solutions.
- **Scout bees** reinitialise solutions that have been stuck for too long, preventing the search from collapsing into local optima.

Local search within each phase applies two methods in random order:

- **2-opt** — improves the tour by detecting and uncrossing route edges.
- **Tabu Search** — improves the knapsack by flipping item selections and maintaining a short-term memory of visited states to avoid cycling.

When a knapsack becomes overweight after any modification, it is repaired by removing items greedily (prioritising those with the worst weight-to-profit ratio), with occasional random removal to keep exploration alive.

---

## Datasets

Tested on standard TTP benchmark instances:

| Dataset | Cities | Items |
|---|---|---|
| berlin52 | 52 | 153 |
| eil51 | 51 | 50 – 150 |
| a280 | 280 | 279 |

---

## Results

Results on the benchmark instances were modest. The core difficulty is that the local search methods improve the tour and the knapsack separately — there is no step that jointly optimises both. Because the two components are tightly coupled in the objective, independently improving each one does not reliably improve the overall solution. A more effective approach would co-evolve the route and item selection together.

---

## Running

Open MATLAB, navigate to the project directory, and run:

```matlab
main
```

Configure the dataset and parameters at the top of `main.m`:

```matlab
dataset_name = 'berlin52'   % berlin52 | eil51 | a280
colonysize   = 16
iterations   = 40
rent         = 5.64         % dataset-specific
capacity     = 87591        % dataset-specific
```

The script plots convergence live and offers to save the best solution and workspace at the end.
