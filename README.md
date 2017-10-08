# hands-on-solvers

For running [Minisat](http://minisat.se/), [Z3](https://github.com/z3prover/z3)
and [CVC4](http://cvc4.cs.stanford.edu/web/), you can use
[Docker](https://www.docker.com/) containers. You find the installation
instruction below.

## Minisat 

```bash
docker pull julianthome/tinned:tinned-minisat
docker run -it julianthome/tinned:tinned-minisat bash
apt-get install ruby
cd /opt && git clone https://github.com/julianthome/hands-on-solvers
cd /opt/hands-on-solvers/sudoku2sat
./gensat.rb input.csv # translate problem to DIMACS
minisat input.cnf model.txt # solve problem
# you can map the variable id to the sudoku grid by using input.vmap file which
# is generated automatically
```

## CVC4

```bash
docker pull julianthome/tinned:tinned-cvc4
docker run -it julianthome/tinned:tinned-cvc4 bash
apt-get install ruby
cd /opt && git clone https://github.com/julianthome/hands-on-solvers
cd /opt/hands-on-solvers/sudoku2smt
./gensmt.rb input.csv # translate problem to SMT
cvc4 --lang smt2 input.smt2
```

## Z3

```bash
docker pull julianthome/tinned:tinned-z3
docker run -it julianthome/tinned:tinned-z3 bash
apt-get install ruby
cd /opt && git clone https://github.com/julianthome/hands-on-solvers
cd /opt/hands-on-solvers/sudoku2smt
./gensat.rb input.csv # translate problem to SMT
z3 sudoku9x9.smt2
```

## Z3 Python bindings

```bash
docker pull julianthome/tinned:tinned-z3
docker run -it julianthome/tinned:tinned-z3 bash
cd /opt/hands-on-solvers
apt-get update && apt-get install python-pip
pip install z3-solver
./pythonz3.py
./solveSudoku.py xample.txt
```

