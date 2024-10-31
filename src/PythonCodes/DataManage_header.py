#!/usr/bin/env python
'''!\file
   -- LDMaP-App addon: (Python3 code) Header for the LDMaP application
      \author Frederic Bonnet (2020)
      \date 13th of February 2020

      Leiden University February 2020

Name:
---
DataManage_header: Header for the application

Description of functions:
---
Header file for the application in a banner format.
'''
#----------------------------------------------------------------------------
# Function to print header for the DataManage library
# Author: Frederic Bonnet
# Date: 10/08/2017
#----------------------------------------------------------------------------
#system tools
#import os
import sys
#*******************************************************************************
##\brief Python3 method.
#The header subroutine for the script
#*******************************************************************************
################################################################################
def print_small_MolRefAnt_DB_app_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    #m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *         MolRefAnt_DB_application backend header main stamp                       *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header subroutine for the script
#*******************************************************************************
################################################################################
def print_small_start_PerlScript_call_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *        LDMaP-App_live-Preprocessing header Start PERL script call stamp          *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header subroutine for the script
#*******************************************************************************
################################################################################
def print_small_Finished_PerlScript_call_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    #m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *        LDMaP-App_live-Preprocessing header Finished PERL script call stamp       *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header subroutine for the script
#*******************************************************************************
################################################################################
def print_small_Gatan_PC_K3_fileMover_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    #m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *         LDMaP-App_fileMover_header while loop stamp                              *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header subroutine for the script
#*******************************************************************************
################################################################################
def print_small_Gatan_PC_K3_gainRefMover_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    #m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *         LDMaP-App_gainRefMover_header while loop stamp                           *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header subroutine for the script
#*******************************************************************************
################################################################################
def print_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *  #       ######  #     #         ######             #    ######  ######          *", c.get_B_Yellow() )
    m.printCMesg(" *  #       #     # ##   ##    ##   #     #           # #   #     # #     #         *", c.get_B_Yellow() )
    m.printCMesg(" *  #       #     # # # # #   #  #  #     #          #   #  #     # #     #         *", c.get_B_Yellow() )
    m.printCMesg(" *  #       #     # #  #  #  #    # ######   #####  #     # ######  ######          *", c.get_B_Yellow() )
    m.printCMesg(" *  #       #     # #     #  ###### #               ####### #       #               *", c.get_B_Yellow() )
    m.printCMesg(" *  #       #     # #     #  #    # #               #     # #       #               *", c.get_B_Yellow() )
    m.printCMesg(" *  ####### ######  #     #  #    # #               #     # #       #               *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_Delayed_copy_shutil_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *  ######                                                                          *", c.get_B_Yellow() )
    m.printCMesg(" *  #     #  ######  #         ##     #   #  ######  #####            ####    ####  *", c.get_B_Yellow() )
    m.printCMesg(" *  #     #  #       #        #  #     # #   #       #    #          #    #  #    # *", c.get_B_Yellow() )
    m.printCMesg(" *  #     #  #####   #       #    #     #    #####   #    #          #       #    # *", c.get_B_Yellow() )
    m.printCMesg(" *  #     #  #       #       ######     #    #       #    #          #       #    # *", c.get_B_Yellow() )
    m.printCMesg(" *  #     #  #       #       #    #     #    #       #    #          #    #  #    # *", c.get_B_Yellow() )
    m.printCMesg(" *  ######   ######  ######  #    #     #    ######  #####  #######   ####    ####  *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_testcode_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * #       ######  #     #         ######          #######                          *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # ##   ##    ##   #     #            #     ######   ####    #####  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # # # # #   #  #  #     #            #     #       #          #    *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #  #  #  #    # ######   #####     #     #####    ####      #    *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #     #  ###### #                  #     #            #     #    *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #     #  #    # #                  #     #       #    #     #    *", c.get_B_Yellow() )
    m.printCMesg(" * ####### ######  #     #  #    # #                  #     ######   ####      #    *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_MolRefAnt_DB_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * XX   XX           XX    XXXXXX             XX     XX                             *", c.get_B_Yellow() )
    m.printCMesg(" *  X   X             X     X    X           X        X              X              *", c.get_B_Yellow() )
    m.printCMesg(" *  XX XX             X     X    X           X        X              X              *", c.get_B_Yellow() )
    m.printCMesg(" *  XX XX   XXXXX     X     X    X  XXXXX   XXXX     X X   XX XX    XXXX            *", c.get_B_Yellow() )
    m.printCMesg(" *  X X X  X     X    X     XXXXX  X     X   X       X X    XX  X    X              *", c.get_B_Yellow() )
    m.printCMesg(" *  X X X  X     X    X     X  X   XXXXXXX   X      X   X   X   X    X     XXXXXXX  *", c.get_B_Yellow() )
    m.printCMesg(" *  X   X  X     X    X     X  X   X         X      XXXXX   X   X    X              *", c.get_B_Yellow() )
    m.printCMesg(" *  X   X  X     X    X     X   X  X     X   X      X   X   X   X    X  X           *", c.get_B_Yellow() )
    m.printCMesg(" *  XXX XXX  XXXXX   XXXXX  XXX  XX  XXXXX   XXXX   XXX XXX XXX XXX    XX           *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_Bench_Grid_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python code to run the Benchmarking suite.                    *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * XXXXXX                          XX                XXXX             X        XX   *", c.get_B_Yellow() )
    m.printCMesg(" * X    X                          X               X    X                      X    *", c.get_B_Yellow() )
    m.printCMesg(" * X    X                          X              X                            X    *", c.get_B_Yellow() )
    m.printCMesg(" * X    X  XXXXX  XX XX    XXXXX   X XX           X       XXX XX   XXX     XXXXX    *", c.get_B_Yellow() )
    m.printCMesg(" * XXXXX  X     X  XX  X  X     X  XX  X          X         XX  X    X    X    X    *", c.get_B_Yellow() )
    m.printCMesg(" * X    X XXXXXXX  X   X  X        X   X  XXXXXXX X   XXX   X        X    X    X    *", c.get_B_Yellow() )
    m.printCMesg(" * X    X X        X   X  X        X   X          X     X   X        X    X    X    *", c.get_B_Yellow() )
    m.printCMesg(" * X    X X     X  X   X  X     X  X   X           X    X   X        X    X    X    *", c.get_B_Yellow() )
    m.printCMesg(" * XXXXXX   XXXXX  XXX XXX  XXXXX  XXX XXX           XXXX  XXXXX    XXXXX   XXXXXX  *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_MolRefAnt_DB_Scan_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *XX   XX   XX      XX            XXXXX   XXXXXX           XXXXX                    *", c.get_B_Yellow() )
    m.printCMesg(" *X   X     X       X             X   X   X    X         X     X                    *", c.get_B_Yellow() )
    m.printCMesg(" *XX XX     X       X             X    X  X    X         X                          *", c.get_B_Yellow() )
    m.printCMesg(" *XX XX     X      X X            X    X  X    X         X        XXXXX   XXXX      *", c.get_B_Yellow() )
    m.printCMesg(" *X X X     X      X X            X    X  XXXXX           XXXXX  X     X      X     *", c.get_B_Yellow() )
    m.printCMesg(" *X X X     X     X   X  XXXXXXX  X    X  X    X XXXXXXX       X X        XXXXX     *", c.get_B_Yellow() )
    m.printCMesg(" *X   X     X     XXXXX           X    X  X    X               X X       X    X     *", c.get_B_Yellow() )
    m.printCMesg(" *X   X     X     X   X           X   X   X    X         X     X X     X X    X     *", c.get_B_Yellow() )
    m.printCMesg(" *XXX XXX  XXXXX  XXX XXX         XXXXX   XXXXXX           XXXXX   XXXXX   XXXX X   *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_scanner_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * #       ######  #     #         ######           #####                           *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # ##   ##    ##   #     #         #     #   ####     ##    #    #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # # # # #   #  #  #     #         #        #    #   #  #   ##   #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #  #  #  #    # ######   #####   #####   #       #    #  # #  #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #     #  ###### #                     #  #       ######  #  # #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #     #  #    # #               #     #  #    #  #    #  #   ##  *", c.get_B_Yellow() )
    m.printCMesg(" * ####### ######  #     #  #    # #                #####    ####   #    #  #    #  *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_live_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *  #          #    #    #  ######          #####   #####   ######  #####   #####   *", c.get_B_Yellow() )
    m.printCMesg(" *  #          #    #    #  #               #    #  #    #  #       #    #  #    #  *", c.get_B_Yellow() )
    m.printCMesg(" *  #          #    #    #  #####   #####   #    #  #    #  #####   #    #  #    #  *", c.get_B_Yellow() )
    m.printCMesg(" *  #          #    #    #  #               #####   #####   #       #####   #####   *", c.get_B_Yellow() )
    m.printCMesg(" *  #          #     #  #   #               #       #   #   #       #       #   #   *", c.get_B_Yellow() )
    m.printCMesg(" *  ######     #      ##    ######          #       #    #  ######  #       #    #  *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the live subroutine for the script
#*******************************************************************************
def print_live_pst_pr_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * #          #    #    #  ######          #####    ####    #####  #####   #####    *", c.get_B_Yellow() )
    m.printCMesg(" * #          #    #    #  #               #    #  #          #    #    #  #    #   *", c.get_B_Yellow() )
    m.printCMesg(" * #          #    #    #  #####   #####   #    #   ####      #    #    #  #    #   *", c.get_B_Yellow() )
    m.printCMesg(" * #          #    #    #  #               #####        #     #    #####   #####    *", c.get_B_Yellow() )
    m.printCMesg(" * #          #     #  #   #               #       #    #     #    #       #   #    *", c.get_B_Yellow() )
    m.printCMesg(" * ######     #      ##    ######          #        ####      #    #       #    #   *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the gain-mover subroutine for the script
#*******************************************************************************
def print_gainMover_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" *    ####     ##       #    #    #          #    #   ####   #    #  ######  #####  *", c.get_B_Yellow() )
    m.printCMesg(" *   #    #   #  #      #    ##   #          ##  ##  #    #  #    #  #       #    # *", c.get_B_Yellow() )
    m.printCMesg(" *   #       #    #     #    # #  #  #####   # ## #  #    #  #    #  #####   #    # *", c.get_B_Yellow() )
    m.printCMesg(" *   #  ###  ######     #    #  # #          #    #  #    #  #    #  #       #####  *", c.get_B_Yellow() )
    m.printCMesg(" *   #    #  #    #     #    #   ##          #    #  #    #   #  #   #       #   #  *", c.get_B_Yellow() )
    m.printCMesg(" *    ####   #    #     #    #    #          #    #   ####     ##    ######  #    # *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for the fractions mover subroutine for the script
#*******************************************************************************
def print_fracMover_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * ######  #####     ##     ####           #    #   ####   #    #  ######  #####    *", c.get_B_Yellow() )
    m.printCMesg(" * #       #    #   #  #   #    #          ##  ##  #    #  #    #  #       #    #   *", c.get_B_Yellow() )
    m.printCMesg(" * #####   #    #  #    #  #       #####   # ## #  #    #  #    #  #####   #    #   *", c.get_B_Yellow() )
    m.printCMesg(" * #       #####   ######  #               #    #  #    #  #    #  #       #####    *", c.get_B_Yellow() )
    m.printCMesg(" * #       #   #   #    #  #    #          #    #  #    #   #  #   #       #   #    *", c.get_B_Yellow() )
    m.printCMesg(" * #       #    #  #    #   ####           #    #   ####     ##    ######  #    #   *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for Relion launcher class
#*******************************************************************************
def print_Gatan_PC_K3_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * #       ######  #     #         ######          ######                           *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # ##   ##    ##   #     #         #     #  #####    ####        #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # # # # #   #  #  #     #         #     #  #    #  #    #       #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #  #  #  #    # ######   #####  ######   #    #  #    #       #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #     #  ###### #               #        #####   #    #       #  *", c.get_B_Yellow() )
    m.printCMesg(" * #       #     # #     #  #    # #               #        #   #   #    #  #    #  *", c.get_B_Yellow() )
    m.printCMesg(" * ####### ######  #     #  #    # #               #        #    #   ####    ####   *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for Relion launcher class
#*******************************************************************************
def print_MolRefAnt_DB_app_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the MolRefAnt_DB_App suite                *", c.get_B_Yellow() )
    m.printCMesg(" * XX   XX           XX    XXXXXX             XX             XX                     *", c.get_B_Yellow() )
    m.printCMesg(" *  X   X             X     X    X           X                X              X      *", c.get_B_Yellow() )
    m.printCMesg(" *  XX XX             X     X    X           X                X              X      *", c.get_B_Yellow() )
    m.printCMesg(" *  XX XX   XXXXX     X     X    X  XXXXX   XXXX             X X   XX XX    XXXX    *", c.get_B_Yellow() )
    m.printCMesg(" *  X X X  X     X    X     XXXXX  X     X   X               X X    XX  X    X      *", c.get_B_Yellow() )
    m.printCMesg(" *  X X X  X     X    X     X  X   XXXXXXX   X     XXXXXXX  X   X   X   X    X      *", c.get_B_Yellow() )
    m.printCMesg(" *  X   X  X     X    X     X  X   X         X              XXXXX   X   X    X      *", c.get_B_Yellow() )
    m.printCMesg(" *  X   X  X     X    X     X   X  X     X   X              X   X   X   X    X  X   *", c.get_B_Yellow() )
    m.printCMesg(" * XXX XXX  XXXXX   XXXXX  XXX  XX  XXXXX   XXXX           XXX XXX XXX XXX    XX    *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#*******************************************************************************
##\brief Python3 method.
#The header for Relion launcher class
#*******************************************************************************
def print_Relion_header(**kwargs):
    #first retrieving the objects from the argument list
    __func__= sys._getframe().f_code.co_name
    c   = kwargs.get('common', None)
    m   = kwargs.get('messageHandler', None)
    m.printLine()
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    m.printCMesg(" *                    python sript to run the LDMaP-App suite.                      *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" * ######  ####### #         ###   ####### #     #         #          #    #     #  *", c.get_B_Yellow() )
    m.printCMesg(" * #     # #       #          #    #     # ##    #         #         # #   #     #  *", c.get_B_Yellow() )
    m.printCMesg(" * #     # #       #          #    #     # # #   #         #        #   #  #     #  *", c.get_B_Yellow() )
    m.printCMesg(" * ######  #####   #          #    #     # #  #  #  #####  #       #     # #     #  *", c.get_B_Yellow() )
    m.printCMesg(" * #   #   #       #          #    #     # #   # #         #       ####### #     #  *", c.get_B_Yellow() )
    m.printCMesg(" * #    #  #       #          #    #     # #    ##         #       #     # #     #  *", c.get_B_Yellow() )
    m.printCMesg(" * #     # ####### #######   ###   ####### #     #         ####### #     #  #####   *", c.get_B_Yellow() )
    m.printCMesg(" *                                                                                  *", c.get_B_Yellow() )
    m.printCMesg(" ************************************************************************************", c.get_B_Yellow() )
    return
#---------------------------------------------------------------------------
# end of LDMaP-App_header module
#---------------------------------------------------------------------------
