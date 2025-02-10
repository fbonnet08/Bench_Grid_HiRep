//
// Created by Frederic on 12/3/2023.
//

#ifndef CARTE_MESH_3D_H
#define CARTE_MESH_3D_H

#ifdef __cplusplus
extern "C" {
#endif

class carte_mesh_3D {
private:
public:
    /*global variables*/
    kernel_calc *s_kernel_in;
    int vx_in;
    int vy_in;
    int vz_in;
    /*constructor*/
    carte_mesh_3D(kernel_calc *s_kernel_in); /*overloading the constructor*/
    carte_mesh_3D(kernel_calc *s_kernel_in,
          int vx_in, int vy_in, int vz_in);
    /*setters*/
    void set_nthrdx(kernel_calc *s_kernel);
    void set_nthrdy(kernel_calc *s_kernel);
    void set_nthrdz(kernel_calc *s_kernel);
    /*getters*/
    int get_CarteMesh3D_vx(); //!< Get the volume size in x
    int get_CarteMesh3D_vy();
    int get_CarteMesh3D_vz();
    int get_CarteMesh3D_nthrdx();
    int get_CarteMesh3D_nthrdy();
    int get_CarteMesh3D_nthrdz();
    int get_CarteMesh3D_Nthrds();
    int get_CarteMesh3D_threadsPerBlock();
    int get_CarteMesh3D_gridx();
    int get_CarteMesh3D_gridy();
    int get_CarteMesh3D_gridz();
    int get_CarteMesh3D_blocksPerGrid();
    /*destructor*/
    ~carte_mesh_3D();
};

#ifdef __cplusplus
}
#endif




#endif //CARTE_MESH_3D_H
