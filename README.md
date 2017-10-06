# hands-on-solvers

For running [Minisat](http://minisat.se/), [Z3](https://github.com/z3prover/z3)
and [CVC4](http://cvc4.cs.stanford.edu/web/), you can use
[Docker](https://www.docker.com/) containers the installation of which is
explained in the following.

## minisat 

```bash
docker pull julianthome/tinned:tinned-minisat
docker run -it julianthome/tinned:tinned-minisat bash
cd /opt && git clone https://github.com/julianthome/hands-on-solvers
cd /opt/hands-on-solvers
minisat sudoku9x9.cnf model.txt
```

## cvc4

```bash
docker pull julianthome/tinned:tinned-cvc4
docker run -it julianthome/tinned:tinned-cvc4 bash
cd /opt && git clone https://github.com/julianthome/hands-on-solvers
cd /opt/hands-on-solvers
cvc4 --lang smt2 sudoku9x9.smt2
```

## Z3

```bash
docker pull julianthome/tinned:tinned-z3
docker run -it julianthome/tinned:tinned-z3 bash
cd /opt && git clone https://github.com/julianthome/hands-on-solvers
cd /opt/hands-on-solvers
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
./solveSudoku.py sudoku9x9.txt
```

