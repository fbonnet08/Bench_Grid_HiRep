//
// Created by Frederic on 12/3/2023.
//
#include <iostream>
#include "../global.cuh"
#include "../include/common_krnl.cuh"
#include "../include/carte_mesh_3D.cuh"

/*!\brief Contructor
  \param s_kernel_in structure carrying details of the kernel
*/
carte_mesh_3D::carte_mesh_3D(kernel_calc *s_kernel_in) {s_kernel = s_kernel_in;}
/*!\brief Overloaded contructor
  \param s_kernel_in structure carrying details of the kernel
  \param vx_in Volume size in x
  \param vy_in Volume size in y
  \param vz_in Volume size in z
*/
carte_mesh_3D::carte_mesh_3D(kernel_calc *s_kernel_in,
 int vx_in, int vy_in, int vz_in)
{
  s_kernel = s_kernel_in;
  Vx_o = vx_in;
  Vy_o = vy_in;
  Vz_o = vz_in;
  std::cout<<"Object carte_mesh_3D has been created"<<std::endl;

}
/* setters */
/*!\brief Sets the number of threads in the x direction
  \param *s_kernel Pointer to structure kernel_calc
*/
void carte_mesh_3D::set_nthrdx(kernel_calc *s_kernel) {
  s_kernel->nthrdx = s_kernel->nthrdx; }
/*!\brief Sets the number of threads in the y direction
  \param *s_kernel Pointer to structure kernel_calc
*/
void carte_mesh_3D::set_nthrdy(kernel_calc *s_kernel) {
  s_kernel->nthrdy = s_kernel->nthrdz; }
/*!\brief Sets the number of threads in the z direction
  \param *s_kernel Pointer to structure kernel_calc
*/
void carte_mesh_3D::set_nthrdz(kernel_calc *s_kernel) {
  s_kernel->nthrdz = s_kernel->nthrdz; }
/* getters */
/*!\brief Gets size of Vol in x direction */
int carte_mesh_3D::get_CarteMesh3D_vx(){return Vx_o;                   }
/*!\brief Gets size of Vol in y direction */
int carte_mesh_3D::get_CarteMesh3D_vy(){return Vy_o;                   }
/*!\brief Gets size of Vol in z direction */
int carte_mesh_3D::get_CarteMesh3D_vz(){return Vz_o;                   }
/*!\brief Gets number of threads in x */
int carte_mesh_3D::get_CarteMesh3D_nthrdx(){return s_kernel->nthrdx; }
/*!\brief Gets number of threads in y */
int carte_mesh_3D::get_CarteMesh3D_nthrdy(){return s_kernel->nthrdy; }
/*!\brief Gets number of threads in z */
int carte_mesh_3D::get_CarteMesh3D_nthrdz(){return s_kernel->nthrdz; }
/*!\brief Gets total number of threads, that is nthrdx*nthrdy*nthrdz */
int carte_mesh_3D::get_CarteMesh3D_Nthrds() {
  return s_kernel->nthrdx*s_kernel->nthrdy*s_kernel->nthrdz;}
/*!\brief Gets number of threads per block, set in Python. Default 256 */
int carte_mesh_3D::get_CarteMesh3D_threadsPerBlock(){
  return s_kernel->threadsPerBlock; }
/*!\brief Gets size of grid in x */
int carte_mesh_3D::get_CarteMesh3D_gridx() {
  return Vx_o/(float)get_CarteMesh3D_nthrdx() +
        (Vx_o%get_CarteMesh3D_nthrdx()!=0);}
/*!\brief Gets size of grid in y */
int carte_mesh_3D::get_CarteMesh3D_gridy() {
  return Vy_o/(float)get_CarteMesh3D_nthrdy() +
        (Vy_o%get_CarteMesh3D_nthrdy()!=0); }
/*!\brief Gets size of grid in z */
int carte_mesh_3D::get_CarteMesh3D_gridz() {
  return Vz_o/(float)get_CarteMesh3D_nthrdz() +
        (Vz_o%get_CarteMesh3D_nthrdz()!=0); }
/*!\brief Gets the total number of threads over all blocks in x,y and z */
int carte_mesh_3D::get_CarteMesh3D_blocksPerGrid()  {
  return get_CarteMesh3D_Nthrds()/(float)get_CarteMesh3D_threadsPerBlock()
    + ( get_CarteMesh3D_Nthrds()%get_CarteMesh3D_threadsPerBlock()!=0 );
}
/*!\brief Destructor */
/* the destructor */
carte_mesh_3D::~carte_mesh_3D() {
  /* TODO: insert the debug datastrure for object destruction */
  //std::cout << "Object carte_mesh_3D has been destroyed" << std::endl;
  std::cout<<"Object carte_mesh_3D has been destroyed"<<std::endl;

}
