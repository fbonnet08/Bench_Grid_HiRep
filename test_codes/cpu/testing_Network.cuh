//
// Created by Frederic on 12/19/2023.
//
#ifndef TESTING_NETWORK_CUH
#define TESTING_NETWORK_CUH

namespace namespace_Testing {
    template<typename value_type>
    class testing_Network_t {
    private:
    public:
        explicit testing_Network_t() {;}
    protected:
    }; /* end of deepL_ClassTemplate_t mirrored class */

    class testing_Network {
    private:
    public:
        /* constructors */
        testing_Network();
        /* destructors */
        ~testing_Network();
        /* checkers */
        int hello();
    protected:
        int _initialize();
        int _finalize();
    }; /* end of deepL_ClassTemplate class */
} /* End of namespace namespace_Network */

#endif //TESTING_NETWORK_CUH
