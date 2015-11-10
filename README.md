# Traffic light controller 

This program describes two ways of controlling traffic lights. It is implemented in the hardware description language called Hydra, which is based on Haskell.

### Dependencies
To run this program you will need the ghc compiler for Haskell version 7.8 or 7.10.2. The latest version can be obtained from the [Haskell website](www.haskell.org).

You will also need to install the Hydra language which you can get [here](http://www.dcs.gla.ac.uk/~jtod/Hydra/). Unpack that file and run these commands in the directory to install the package:

```bash
$ cabal update
$ cabal install
```

### Running the program
In the root directory for the project run these commands:

```bash
$ ghci
$ :load Testbench
$ main
```

And you will be given the output for the test inputs specified in Testbench.hs

### Author
Piotr Hosa
