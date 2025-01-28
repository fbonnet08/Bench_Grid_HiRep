#include <iostream>

int main(int argc, char **argv) {
    int rc = 0;
    printf("\n");
    std::cout << "Hello This is a testcode for the testing the libGrid.a library." << std::endl;
    std::cout << "argc              --->: " << argc  <<std::endl;
    std::cout << "argv              --->: " << *argv <<std::endl;
    std::cout << "Final return code --->: " << rc    <<std::endl;
    return rc;
}
