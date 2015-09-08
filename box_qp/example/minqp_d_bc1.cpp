#include "stdafx.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "optimization.h"

using namespace alglib;


int main(int argc, char **argv)
{
    //
    // This example demonstrates minimization of F(x0,x1) = x0^2 + x1^2 -6*x0 - 4*x1
    // subject to bound constraints 0<=x0<=2.5, 0<=x1<=2.5
    //
    // Exact solution is [x0,x1] = [2.5,2]
    //
    // We provide algorithm with starting point. With such small problem good starting
    // point is not really necessary, but with high-dimensional problem it can save us
    // a lot of time.
    //
    // IMPORTANT: this solver minimizes  following  function:
    //     f(x) = 0.5*x'*A*x + b'*x.
    // Note that quadratic term has 0.5 before it. So if you want to minimize
    // quadratic function, you should rewrite it in such way that quadratic term
    // is multiplied by 0.5 too.
    // For example, our function is f(x)=x0^2+x1^2+..., but we rewrite it as 
    //     f(x) = 0.5*(2*x0^2+2*x1^2) + ....
    // and pass diag(2,2) as quadratic term - NOT diag(1,1)!
    //
    real_2d_array a = "[[2,0],[0,2]]";
    real_1d_array b = "[-6,-4]";
    real_1d_array x0 = "[0,1]";
    real_1d_array s = "[1,1]";
    real_1d_array bndl = "[0.0,0.0]";
    real_1d_array bndu = "[2.5,2.5]";
    real_1d_array x;
    minqpstate state;
    minqpreport rep;

    // create solver, set quadratic/linear terms
    minqpcreate(2, state);
    minqpsetquadraticterm(state, a);
    minqpsetlinearterm(state, b);
    minqpsetstartingpoint(state, x0);
    minqpsetbc(state, bndl, bndu);

    // Set scale of the parameters.
    // It is strongly recommended that you set scale of your variables.
    // Knowing their scales is essential for evaluation of stopping criteria
    // and for preconditioning of the algorithm steps.
    // You can find more information on scaling at http://www.alglib.net/optimization/scaling.php
    minqpsetscale(state, s);

    // solve problem with QuickQP solver, default stopping criteria are used
    minqpsetalgoquickqp(state, 0.0, 0.0, 0.0, 0, true);
    minqpoptimize(state);
    minqpresults(state, x, rep);
    printf("%d\n", int(rep.terminationtype)); // EXPECTED: 4
    printf("%s\n", x.tostring(2).c_str()); // EXPECTED: [2.5,2]

    // solve problem with BLEIC-based QP solver
    // default stopping criteria are used.
    minqpsetalgobleic(state, 0.0, 0.0, 0.0, 0);
    minqpoptimize(state);
    minqpresults(state, x, rep);
    printf("%s\n", x.tostring(2).c_str()); // EXPECTED: [2.5,2]
    return 0;
}

