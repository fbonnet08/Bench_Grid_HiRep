//
// Created by frede on 1/1/2025.
//

#include <iostream>
#include "testing_Grid.hpp"

#include "Grid/Grid.h"


int main(int argc, char **argv) {

    std::cout << "Hello This is a testcode for the testing the libGrid.a library." << std::endl;

    //using namespace Grid;


    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    // Representationm choice SpFundamentalRepresentation
    typedef Grid::Representations<Grid::SpFundamentalRepresentation> TheRepresentations;
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    // Initiaslizing Grid
    //Grid::Grid_init(&argc, &argv);
    /*
    int threads = GridThread::GetThreads();
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    // here make a routine to print all the relevant information on the run
    std::cout << GridLogMessage << "Grid is setup to use " << threads << " threads" << std::endl;
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    // Finalise Grid
    Grid_finalize();
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
    //::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
     */


}

