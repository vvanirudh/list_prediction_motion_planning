#include "stdafx.h"
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <fstream>
#include <sstream>
#include <string>
#include <algorithm>
#include <iostream>
#include <iterator>
#include <vector>
#include "optimization.h"

using namespace alglib;

bool ReadArrayFromFile(std::string filename, std::vector< std::vector<double> > &array) {
    std::ifstream infile(filename);
    if(!infile)
        return false;
    std::string line;
    while (std::getline(infile, line)) {
        std::istringstream iss(line);

        array.push_back(
            std::vector<double>(std::istream_iterator<double>(iss),
                                std::istream_iterator<double>()));
    }
    return true;
}

bool ReadArrayFromFile(std::string filename, real_1d_array &v) {
    std::vector< std::vector<double> > array;
    if (!ReadArrayFromFile(filename, array))
        return false;

    v.setlength(array.size());
    for (std::size_t i = 0; i < array.size(); i++) {
        v[i] = array[i][0];
    }
    return true;
}

bool ReadArrayFromFile(std::string filename, real_2d_array &v) {
    std::vector< std::vector<double> > array;
    if (!ReadArrayFromFile(filename, array))
        return false;

    v.setlength(array.size(), array[0].size());
    for (std::size_t i = 0; i < array.size(); i++) {
        for (std::size_t j = 0; j < array[i].size(); j++) {
            v[i][j] = array[i][j];
        }
    }
    return true;
}

void WriteArrayToFile(std::string filename, const real_1d_array &v) {
    std::ofstream ofs (filename, std::ofstream::out);
    for (int i = 0; i < v.length(); i++)
        ofs << v[i] <<"\n";
    ofs.close();
}

int main(int argc, char **argv) {
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
    real_2d_array a;
    if (!ReadArrayFromFile("A.txt", a))
        return EXIT_FAILURE;
    real_1d_array b;
    if (!ReadArrayFromFile("b.txt", b))
        return EXIT_FAILURE;
    real_1d_array bndl;
    if (!ReadArrayFromFile("bndl.txt", bndl))
        return EXIT_FAILURE;
    real_1d_array bndu;
    if (!ReadArrayFromFile("bndu.txt", bndu))
        return EXIT_FAILURE;

    int n = b.length();

    real_1d_array x0;
    x0.setlength(n);
    for (int i = 0; i < x0.length(); i++)
        x0[i] = 0;
    real_1d_array s;
    s.setlength(n);
    for (int i = 0; i < x0.length(); i++)
        s[i] = 1;
    real_1d_array x;
    minqpstate state;
    minqpreport rep;

    // create solver, set quadratic/linear terms
    minqpcreate(n, state);
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
    minqpsetalgoquickqp(state, 1e-6, 1e-6, 1e-6, 100, true);
    minqpoptimize(state);
    minqpresults(state, x, rep);
    printf("%d\n", int(rep.terminationtype)); // EXPECTED: 4
    printf("%s\n", x.tostring(2).c_str()); // EXPECTED: [2.5,2]

    WriteArrayToFile("weights.txt", x);
    return 0;
}

