'''!\file
   -- DataManage addon: (Python3 code) module containing file input/output functions.
      \author Frederic Bonnet
      \date 13th of February 2020

      Leiden University February 2020

Name:
---
DataManage_fileIO: module containing file input/output functions. All functions
               have been chopped up and blended together from the excellent
               UCSF Chimera package.

               LINK: www.cgl.ucsf.edu/chimera

               Extended by Frederic Bonnet 01/08/17

Citation:
---
  UCSF Chimera--a visualization system for exploratory research and analysis.
  Pettersen EF, Goddard TD, Huang CC, Couch GS, Greenblatt DM, Meng EC,
  Ferrin TE. J Comput Chem. 2004 Oct;25(13):1605-12.

Description of classes:
---
  MRC_Data: Read, process, and write MRC volumes.

Requirements (system):
---
* sys
* os
* scipy

Requirements (application):
---
* DataManage_common
* messageHandler
'''
#-------------------------------------------------------------------------------
# Read MRC or CCP4 map file format electron microscope data.
# Byte swapping will be done if needed.
#
#-------------------------------------------------------------------------------
# file_type can be 'mrc' or 'ccp4' or 'imod'.
#
#System tools
import sys
import os
from scipy import *
#appending the utils path
sys.path.append(os.path.join(os.getcwd(), 'utils'))
#application imports
from DataManage_common import *
from messageHandler import *
#*******************************************************************************
##\brief Python3 class.
# MRC_Data class for the File IO access
class MRC_Data:
  #*****************************************************************************
  ##\brief Python3 method.
  # MRC_Data class constructor
  #*****************************************************************************
  #\param self       The Self Object
  #\param path       Path of the file
  #\param file_type  File type map mrc ccp4 
  def __init__(self, path, file_type):

    # first instantiating the common class
    c = DataManage_common()
    #instantiating messaging class
    logfile = c.getLogfileName()
    m = messageHandler(logfile = logfile)
    __func__= sys._getframe().f_code.co_name

    if c.getBench_cpu():
      #creating the timers and starting the stop watch...
      stopwatch = createTimer()
      StartTimer(stopwatch)

    self.path = path

    import os.path
    self.name = os.path.basename(path)

    self.dirName = os.path.dirname(path)

    sys.path.append(self.dirName)

    try:
      file = open(path, "rb")
    except IOError:
      m.printCMesgVal("[MRC_Data]: Could not open file:",c.getRed(),path)

    #---------------------------------------------------------------------------
    # Native code from original DataManage
    #---------------------------------------------------------------------------

    file.seek(0,2)                              # go to end of file
    file_size = os.path.getsize(path)
    file.seek(0,0)                              # go to beginning of file
    # Infer file byte order from column axis size nc.  Requires nc < 2**16
    # Was using mode value but 0 is allowed and does not determine byte order.
    self.swap_bytes = 0
    from numpy import int32
    nc = self.read_values(file, int32, 1)
    self.swap_bytes = not (nc > 0 and nc < 65536)
    file.seek(0,0)

    v = self.read_header_values(file, file_size, file_type)
    #setting the header for that file
    self.header = v
    
    if v.get('imodStamp') == 1146047817:
      unsigned_8_bit = (v['imodFlags'] & 0x1 == 0)
    else:
      unsigned_8_bit = (file_type == 'imod' or v['type'] == 'mrc')
    self.element_type = self.value_type(v['mode'], unsigned_8_bit)

    self.check_header_values(v, file_size, file)
    self.header = v             # For dumpmrc.py standalone program.

    self.data_offset = file.tell()
    file.close()

    # Axes permutation.
    # Names c,r,s refer to fast, medium, slow file matrix axes.
    # Names i,j,k refer to x,y,z spatial axes.
    mapc, mapr, maps = v['mapc'], v['mapr'], v['maps']
    if (1 in (mapc, mapr, maps) and
        2 in (mapc, mapr, maps) and
        3 in (mapc, mapr, maps)):
      crs_to_ijk = (mapc-1,mapr-1,maps-1)
      ijk_to_crs = [None,None,None]
      for a in range(3):
        ijk_to_crs[crs_to_ijk[a]] = a
    else:
      crs_to_ijk = ijk_to_crs = (0, 1, 2)
    self.crs_to_ijk = crs_to_ijk
    self.ijk_to_crs = ijk_to_crs

    crs_size = v['nc'], v['nr'], v['ns']
    self.matrix_size = [int(s) for s in crs_size]
    self.data_size = [int(crs_size[a]) for a in ijk_to_crs]

    self.unit_cell_size = mx, my, mz = v['mx'], v['my'], v['mz']
    xlen, ylen, zlen = v['xlen'], v['ylen'], v['zlen']
    if mx > 0 and my > 0 and mz > 0 and xlen > 0 and ylen > 0 and zlen > 0:
      self.data_step = (xlen/mx, ylen/my, zlen/mz)
    else:
      self.data_step = (1.0, 1.0, 1.0)

    alpha, beta, gamma = (v['alpha'], v['beta'], v['gamma'])
    if not valid_cell_angles(alpha, beta, gamma, path):
      alpha = beta = gamma = 90
    self.cell_angles = (alpha, beta, gamma)

    from math import isnan
    if (v['type'] == 'mrc2000' and
        (v['zorigin'] != 0 or v['xorigin'] != 0 or v['yorigin'] != 0) and
        not (isnan(v['xorigin']) or isnan(v['yorigin']) or isnan(v['zorigin']))):
      #
      # This is a new MRC 2000 format file.  The xyz origin header parameters
      # are used instead of using ncstart, nrstart nsstart for new style files,
      # provided the xyz origin specified is not zero.  It turns out the
      # xorigin, yorigin, zorigin values are zero in alot of new files while
      # the ncstart, nrstart, nsstart give the correct (non-zero) origin. So in
      # cases where the xyz origin parameters and older nrstart, ncstart,
      # nsstart parameters specify different origins the one that is non-zero
      # is preferred.  And if both are non-zero, the newer xorigin, yorigin,
      # zorigin are used.
      #
      self.data_origin = (v['xorigin'], v['yorigin'], v['zorigin'])
    else:
      crs_start = v['ncstart'], v['nrstart'], v['nsstart']
      ijk_start = [crs_start[a] for a in ijk_to_crs]
      # Check if ijk_start values appear to be uninitialized.
      limit = 10*max(max(mx,my,mz), max(self.data_size))
      # if [s for s in ijk_start if abs(s) > limit]:             # ALP
      self.data_origin = (0., 0., 0.)
      # else:
      #   from VolumeData.griddata import scale_and_skew
      #   self.data_origin = scale_and_skew(ijk_start, self.data_step,
      #                                     self.cell_angles)

    r = ((1,0,0),(0,1,0),(0,0,1))
    for lbl in str(v["labels"]):
      if lbl.startswith("Chimera rotation: "):
        ax,ay,az,angle = map(float, lbl.rstrip("\0").split()[2:])
        # import Matrix
        # r = Matrix.rotation_from_axis_angle((ax,ay,az), angle) # ALP
    self.rotation = r

    self.min_intensity = v['amin']
    self.max_intensity = v['amax']

    self.matrix = self.read_matrix(self.data_origin,
                                   self.matrix_size, (1,1,1),
                                   None)
    self.vx, self.vy, self.vz = v['nc'], v['nr'], v['ns']
    if c.getBench_cpu():
      StopTimer_secs(stopwatch)
      info = c.GetFrameInfo()
      m.printBenchMap("Map",c.getRed(),path,info,__func__)
      m.printBenchVolume("Volume",c.getBlue(),
                         v['nc'], v['nr'], v['ns'],info,__func__)
      m.printBenchTime_cpu("read header + matrix",
			   c.getBlue(), stopwatch,info,__func__)

    # end of construtor __init__(self, path, file_type)
    
  #-----------------------------------------------------------------------------
  # Format derived from C header file mrc.h.
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Method that reads the header values from the map file
  #*****************************************************************************
  #\param self       The Self Object
  #\param file       File in question
  #\param file_size  File size
  #\param file_type  File type map mrc ccp4
  #\return v          The header stores in a vector
  def read_header_values(self, file, file_size, file_type):
    __func__= sys._getframe().f_code.co_name

    MRC_USER = 29
    CCP4_USER = 15
    MRC_NUM_LABELS = 10
    MRC_LABEL_SIZE = 80
    MRC_HEADER_LENGTH = 1024

    from numpy import int32, float32
    i32 = int32
    f32 = float32

    v = {}
    v['nc'], v['nr'], v['ns'] = self.read_values(file, i32, 3)
    v['mode'] = self.read_values(file, i32, 1)
    v['ncstart'], v['nrstart'], v['nsstart'] = self.read_values(file, i32, 3)
    v['mx'], v['my'], v['mz'] = self.read_values(file, i32, 3)
    v['xlen'], v['ylen'], v['zlen'] = self.read_values(file, f32, 3)
    v['alpha'], v['beta'], v['gamma'] = self.read_values(file, f32, 3)
    v['mapc'], v['mapr'], v['maps'] = self.read_values(file, i32, 3)
    v['amin'], v['amax'], v['amean'] = self.read_values(file, f32, 3)
    v['ispg'], v['nsymbt'] = self.read_values(file, i32, 2)
    if file_type == 'ccp4':
      v['lskflg'] = self.read_values(file, i32, 1)
      v['skwmat'] = self.read_values(file, f32, 9)
      v['skwtrn'] = self.read_values(file, f32, 3)
      v['user'] = self.read_values(file, i32, CCP4_USER)
      v['map'] = file.read(4)   # Should be 'MAP '.
      v['machst'] = self.read_values(file, i32, 1)
      v['rms'] = self.read_values(file, f32, 1)
      v['type'] = 'ccp4'
    else:
      # MRC file
      user = file.read(4*MRC_USER)
      if user[-4:] == 'MAP ':
        # New style MRC 2000 format file with xyz origin
        v['user'] = self.read_values_from_string(user, i32, MRC_USER)[:-4]
        xyz_origin = self.read_values_from_string(user[-16:-4], f32, 3)
        v['xorigin'], v['yorigin'], v['zorigin'] = xyz_origin
        v['imodStamp'] = self.read_values_from_string(user[56:60], i32, 1)
        v['imodFlags'] = self.read_values_from_string(user[60:64], i32, 1)
        v['machst'] = self.read_values(file, i32, 1)
        v['rms'] = self.read_values(file, f32, 1)
        v['type'] = 'mrc2000'
      else:
        # Old style MRC has xy origin instead of machst and rms.
        v['user'] = self.read_values_from_string(user, i32, MRC_USER)
        v['xorigin'], v['yorigin'] = self.read_values(file, f32, 2)
        v['type'] = 'mrc'

    v['nlabl'] = self.read_values(file, i32, 1)
    labels = []
    for i in range(MRC_NUM_LABELS):
      labels.append(file.read(MRC_LABEL_SIZE))
    v['labels'] = labels


    # Catch incorrect nsymbt value.
    if v['nsymbt'] < 0 or v['nsymbt'] + MRC_HEADER_LENGTH > file_size:
      raise SyntaxError("MRC header value nsymbt "+v['nsymbt']+ "is invalid")

    v['symop'] = file.read(v['nsymbt'])

    return v

  #-----------------------------------------------------------------------------
  #Method that gets the value type from the mode
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Method that gets the value type from the mode. In other words the mode of the
  #reads the header values from the map file
  #*****************************************************************************
  #\param self       The Self Object
  #\param mode       Mode of the file obtained from header of the file
  #\param unsigned_8_bit  Unsigned size in bit neccessary in order to read file
  #\return t the data type, that will be used to read the data part of the file
  def value_type(self, mode, unsigned_8_bit):
    __func__= sys._getframe().f_code.co_name

    MODE_char   = 0
    MODE_short  = 1
    MODE_float  = 2
    MODE_ushort  = 6            # Non-standard

    from numpy import uint8, int8, int16, uint16, float32, dtype
    if mode == MODE_char:
      if unsigned_8_bit:
        t = dtype(uint8)
      else:
        t = dtype(int8)        # CCP4 or MRC2000
    elif mode == MODE_short:
      t = dtype(int16)
    elif mode == MODE_ushort:
      t = dtype(uint16)
    elif mode == MODE_float:
      t = dtype(float32)
    else:
      raise SyntaxError("MRC data value type: " + mode +
                          "is not 8 or 16 bit integers or 32 bit floats")

    return t

  #-----------------------------------------------------------------------------
  # Method to check the header values
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Method to check the header values
  #*****************************************************************************
  #\param self       The Self Object
  #\param v          The header stores in a vector
  #\param file       File in question
  #\param file_size  File size
  #\return If does not pass the test print a message and raise an error
  def check_header_values(self, v, file_size, file):
    __func__= sys._getframe().f_code.co_name

    if v['nc'] <= 0 or v['nr'] <= 0 or v['ns'] <= 0:
      #raise SyntaxError, ('Bad MRC grid size (%d,%d,%d)'
      #% (v['nc'],v['nr'],v['ns']))
      raise SyntaxError("Bad MRC grid size: "
                          +(v['nc']+","+v['nr']+","+v['ns']  ))

    esize = self.element_type.itemsize
    data_size = int(v['nc']) * int(v['nr']) * int(v['ns']) * esize
    header_end = file.tell()
    if header_end + data_size > file_size:
      if v['nsymbt'] and (header_end - v['nsymbt']) + data_size == file_size:
        # Sometimes header indicates symmetry operators are present but
        # they are not.  This error occurs in macromolecular structure database
        # entries emd_1042.map, emd_1048.map, emd_1089.map, ....
        # This work around code allows the incorrect files to be read.
        file.seek(-v['nsymbt'], 1)
        v['symop'] = ''
      else:
        msg = ('File size %d too small for grid size (%d,%d,%d)'
               % (file_size, v['nc'],v['nr'],v['ns']))
        if v['nsymbt']:
          msg += ' and %d bytes of symmetry operators' % (v['nsymbt'],)
        raise SyntaxError(msg)
  #-----------------------------------------------------------------------------
  #
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Method to read values
  #*****************************************************************************
  #\param self       The Self Object
  #\param file       File in question
  #\param etype      The type
  #\param count  Count 
  #\return Values that have been read from {@link read_values_from_string}
  def read_values(self, file, etype, count):
    __func__= sys._getframe().f_code.co_name
    from numpy import array
    esize = array((), etype).itemsize
    string = file.read(esize * count)
    if len(string) < esize * count:
      #raise SyntaxError, ('MRC file is truncated.  Failed reading %d values, type %s' % (count, etype.__name__))
      raise SyntaxError("MRC file is truncated.  Failed reading: "+count
                        +"values, type: "+ etype.__name__)
    values = self.read_values_from_string(string, etype, count)
    return values

  #-----------------------------------------------------------------------------
  #
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Method to read values
  #*****************************************************************************
  #\param self       The Self Object
  #\param string     File in question
  #\param etype      The type
  #\param count      Count 
  #\return Values from a byteswap call on values
  def read_values_from_string(self, string, etype, count):
    __func__= sys._getframe().f_code.co_name
    from numpy import fromstring
    values = fromstring(string, etype)
    if self.swap_bytes:
      values = values.byteswap()
    if count == 1:
      return values[0]
    return values
  # ---------------------------------------------------------------------------
  # Reads a submatrix from a the file.
  # Returns 3d numpy matrix with zyx index order.
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Class Method to Reads a submatrix from a the file. That is the data itself
  #*****************************************************************************
  #\param self       The Self Object
  #\param ijk_origin The origin
  #\param ijk_size   Size
  #\param ijk_step   Step
  #\param progress   Progress
  #\return Data stored in a matrix in 3D, 3D numpy matrix with zyx index order.
  def read_matrix(self, ijk_origin, ijk_size, ijk_step, progress):
    __func__= sys._getframe().f_code.co_name
    # ijk correspond to xyz.  crs refers to fast,medium,slow matrix file axes.
    crs_origin = [ijk_origin[a] for a in self.crs_to_ijk]
    crs_size = [ijk_size[a] for a in self.crs_to_ijk]
    crs_step = [ijk_step[a] for a in self.crs_to_ijk]

    # from readarray import read_array
    matrix = read_array(self.path, self.data_offset,
                        crs_origin, crs_size, crs_step,
                        self.matrix_size, self.element_type, self.swap_bytes,
                        progress)
    if not matrix is None:
      matrix = self.permute_matrix_to_xyz_axis_order(matrix)

    return matrix

  #-----------------------------------------------------------------------------
  # Method to permute the data matrix to xyz axis order
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Class Method to permute the data matrix to xyz axis order.
  #*****************************************************************************
  #\param self       The Self Object
  #\param matrix     Data matrix
  #\return Data in a transposed permuted way
  def permute_matrix_to_xyz_axis_order(self, matrix):
    __func__= sys._getframe().f_code.co_name

    if self.ijk_to_crs == (0,1,2):
      return matrix

    kji_to_src = [2-self.ijk_to_crs[2-a] for a in (0,1,2)]
    m = matrix.transpose(kji_to_src)

    return m

  #-----------------------------------------------------------------------------
  # getters for the class
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Class Method to return the header
  #*****************************************************************************
  #\param self       The Self Object
  #\return The file header
  def getHeader(self):
    return self.header
  #-----------------------------------------------------------------------------
  #*****************************************************************************
  ##\brief Python3 method.
  #Class Method to return the volume as a size in terms of vx, vy and vz.
  #*****************************************************************************
  #\param self       The Self Object
  #\return The Volume as vx,vy and vz
  def getVolume(self):
    return self.vx, self.vy, self.vz
  #-----------------------------------------------------------------------------

#-------------------------------------------------------------------------------
#  end of class MRC_Data:  def __init__(self, path, file_type):
# ------------------------------------------------------------------------------
#*******************************************************************************
# ------------------------------------------------------------------------------
#  Helper methods for the IO external
# ------------------------------------------------------------------------------
def write_DataM_file(Matrixdata, path):
  import scipy
  from scipy import io
  __func__= sys._getframe().f_code.co_name

  #instantiating the common class
  c = DataManage_common()
  #instantiating messaging class
  logfile = c.getLogfileName()
  m = messageHandler(logfile = logfile)
  
  if c.getBench_cpu():
    #creating the timers and starting the stop watch...
    stopwatch = createTimer()
    StartTimer(stopwatch)

  file_X = open(path,'wb')
  size_mat = Matrixdata.shape[0]
  '''
  try:
    for i in range(size_vec):
      #print(i)
      file_X.write(str(Vectordata[i])+'\n')
      
  finally:
    file_X.close()
    m.printMesgStr("File    : ",c.getMagenta(), path+" written to disk")
  '''
  if c.getBench_cpu():
    StopTimer_secs(stopwatch)
    info = c.GetFrameInfo()
    m.printBenchTime_cpu("Matlab output",
			 c.getBlue(), stopwatch,info,__func__)

    
def write_DataV_file(Vectordata, path):
  import scipy
  from scipy import io
  __func__= sys._getframe().f_code.co_name

  #instantiating the common class
  c = DataManage_common()
  #instantiating messaging class
  logfile = c.getLogfileName()
  m = messageHandler(logfile = logfile)
  
  if c.getBench_cpu():
    #creating the timers and starting the stop watch...
    stopwatch = createTimer()
    StartTimer(stopwatch)

  file_X = open(path,'w')
  size_vec = Vectordata.shape[0]
  try:
    for i in range(size_vec):
      #print(i)
      file_X.write(str(Vectordata[i])+'\n')
      
  finally:
    file_X.close()
    m.printMesgStr("File    : ",c.getMagenta(), path+" written to disk")
    
  if c.getBench_cpu():
    StopTimer_secs(stopwatch)
    info = c.GetFrameInfo()
    m.printBenchTime_cpu("Matlab output",
			 c.getBlue(), stopwatch,info,__func__)
#-------------------------------------------------------------------------------
# Method to write out a matrix to MATLAB
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Method to write out a matrix to MATLAB
#*******************************************************************************
#\param Matrixdata      The matrix data to be writen to disk as a MATLAB format
#\param path            The path of hte Self Object
#\return The Volume as vx,vy and vz written to disk for Matlab input read
def write_Data2MATLAB_file(Matrixdata, path):
  import scipy
  from scipy import io
  __func__= sys._getframe().f_code.co_name

  #instantiating the common class
  c = DataManage_common()
  #instantiating messaging class
  logfile = c.getLogfileName()
  m = messageHandler(logfile = logfile)
  
  if c.getBench_cpu():
    #creating the timers and starting the stop watch...
    stopwatch = createTimer()
    StartTimer(stopwatch)

  #writing the array matrix as Matlab file
  try:
    scipy.io.savemat(path, {'Matrixdata':Matrixdata})
  finally:
    m.printMesgStr("File    : ",c.getMagenta(), path+" written to disk")
    
  if c.getBench_cpu():
    StopTimer_secs(stopwatch)
    info = c.GetFrameInfo()
    m.printBenchTime_cpu("Matlab output",
			 c.getBlue(), stopwatch,info,__func__)
#-------------------------------------------------------------------------------
# Validate the cell angle
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Method to validate the cell angle
#*******************************************************************************
#\param alpha           Alpha value
#\param beta            Beta value
#\param gamma           Gamma value
#\param path            The path of hte Self Object
#\return A logical true false weather cell angle is valid or not.
def valid_cell_angles(alpha, beta, gamma, path):
  __func__= sys._getframe().f_code.co_name

  err = None

  for a in (alpha, beta, gamma):
    if a <= 0 or a >= 180:
      err = 'must be between 0 and 180'

  if alpha + beta + gamma >= 360 and err is None:
    err = 'sum must be less than 360'

  if max((alpha, beta, gamma)) >= 0.5 * (alpha + beta + gamma) and err is None:
    err = 'largest angle must be less than sum of other two'

  if err:
    from sys import stderr
    stderr.write('%s: invalid cell angles %.5g,%.5g,%.5g %s.\n'
                 % (path, alpha, beta, gamma, err))
    return False

  return True
#-------------------------------------------------------------------------------
# Read part of a matrix from a binary file making at most one copy of array
# in memory.
#
# The code array.fromstring(file.read()) creates two copies in memory.
# The numpy.fromfile() routine can't read into an existing array.
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Read part of a matrix from a binary file making at most one copy of array
#in memory. The code array.fromstring(file.read()) creates two copies in memory.
#The numpy.fromfile() routine can't read into an existing array.
#*******************************************************************************
#\param path          The path of hte Self Object
#\param byte_offset   Byte offset
#\param ijk_origin    Origin
#\param ijk_size      Size
#\param ijk_step      Step
#\param full_size     Full size
#\param type          Type
#\param byte_swap     Byte swap
#\param progress      Progress Initialized to None
#\return A matrix that has been bytewswapped
def read_array(path, byte_offset, ijk_origin, ijk_size, ijk_step,
               full_size, type, byte_swap, progress = None):
  __func__= sys._getframe().f_code.co_name
  if (tuple(ijk_origin) == (0,0,0) and
      tuple(ijk_size) == tuple(full_size) and
      tuple(ijk_step) == (1,1,1)):
    m = read_full_array(path, byte_offset, full_size,
                        type, byte_swap, progress)
    return m

  matrix = allocate_array(ijk_size, type, ijk_step, progress)

  file = open(path, 'rb')

  if progress:
    progress.close_on_cancel(file)

    # Seek in file to read needed 1d slices.
    io, jo, ko = ijk_origin
    isize, jsize, ksize = ijk_size
    istep, jstep, kstep = ijk_step
    element_size = matrix.itemsize
    jbytes = full_size[0] * element_size
    kbytes = full_size[1] * jbytes
    ibytes = isize * element_size
    ioffset = io * element_size
    from numpy import fromstring
    for k in range(ko, ko+ksize, kstep):
      if progress:
        progress.plane((k-ko)/kstep)
      kbase = byte_offset + k * kbytes
      for j in range(jo, jo+jsize, jstep):
        offset = kbase + j * jbytes + ioffset
        file.seek(offset)
        data = file.read(ibytes)
        slice = fromstring(data, type)
        matrix[(k-ko)/kstep,(j-jo)/jstep,:] = slice[::istep]

  file.close()

  if byte_swap:
    matrix.byteswap(True)

  return matrix
#-------------------------------------------------------------------------------
# Read an array from a binary file making at most one copy of array in memory.
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Read an array from a binary file making at most one copy of array in memory
#\param path          Path
#\param byte_offset   Byte offset
#\param size          Size file
#\param type          File type
#\param byte_swap     Byte swap
#\param progress      Progress Initialized to None
#\param block_size    Block size Initialized to 2**20
#\return a a byteswap array
def read_full_array(path, byte_offset, size, type, byte_swap,
                    progress = None, block_size = 2**20):
  

  __func__= sys._getframe().f_code.co_name
  a = allocate_array(size, type)

  file = open(path, 'rb')
  file.seek(byte_offset)

  if progress:
    progress.close_on_cancel(file)
    a_1d = a.ravel()
    n = len(a_1d)
    nf = float(n)
    for s in range(0,n,block_size):
      b = a_1d[s:s+block_size]
      file.readinto(b)
      progress.fraction(s/nf)
      progress.done()
  else:
    file.readinto(a)

  file.close()

  if byte_swap:
    a.byteswap(True)

  return a
#-------------------------------------------------------------------------------
# Read text floats from the MRC file
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Read text floats from the MRC file
#*******************************************************************************
#\param path          Path
#\param byte_offset   Byte offset
#\param size          Size file
#\param array         Array Initialized to None
#\param transpose     Transpose or not Initialized to False
#\param line_format   line format Initialized to None
#\param progress      Progress Initialized to None
#\return array an array
def read_text_floats(path, byte_offset, size, array = None,
                     transpose = False, line_format = None, progress = None):

  __func__= sys._getframe().f_code.co_name
  if array is None:
    shape = list(size)
    if not transpose:
      shape.reverse()
      from numpy import zeros, float32
      array = zeros(shape, float32)

  f = open(path, 'rb')

  if progress:
    f.seek(0,2)     # End of file
    file_size = f.tell()
    progress.text_file_size(file_size)
    progress.close_on_cancel(f)

  f.seek(byte_offset)

  try:
    read_float_lines(f, array, line_format, progress)
    #except SyntaxError, msg:
  except SyntaxError(msg):
    f.close()
    raise

  f.close()

  if transpose:
    array = array.transpose()

  if progress:
    progress.done()

  return array

#-------------------------------------------------------------------------------
# Read float lines from file
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Read text floats from the MRC file
#*******************************************************************************
#\param f             File to be read from
#\param array         Array Initialized to None
#\param line_format   Line format Initialized to None
#\param progress      Progress Initialized to None
def read_float_lines(f, array, line_format, progress = None):

  __func__= sys._getframe().f_code.co_name
  a_1d = array.ravel()
  count = len(a_1d)

  c = 0
  while c < count:
    line = f.readline()
    if line == '':
      msg = ('Too few data values in %s, found %d, expecting %d'
             % (f.name, c, count))
      raise SyntaxError(msg)
    if line[0] == '#':
      continue                  # Comment line
    if line_format is None:
      fields = line.split()
    else:
      fields = split_fields(line, *line_format)
      if c + len(fields) > count:
        fields = fields[:count-c]
      try:
        values = map(float, fields)
      except:
        msg = 'Bad number format in %s, line\n%s' % (f.name, line)
        #raise SyntaxError, msg
        raise SyntaxError(msg)
      for v in values:
        a_1d[c] = v
        c += 1
      if progress:
        progress.fraction(float(c)/(count-1))

#-------------------------------------------------------------------------------
# Method to split the fileds
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Method to split the fields
#*******************************************************************************
#\param line          Lines
#\param field_size    Size of the fields
#\param max_fields    Maximum number of fields
#\return fileds from 0 to max_fields.
def split_fields(line, field_size, max_fields):

  __func__= sys._getframe().f_code.co_name
  fields = []
  for k in range(0, len(line), field_size):
    f = line[k:k+field_size].strip()
    if f:
      fields.append(f)
    else:
      break
  return fields[:max_fields]

#-------------------------------------------------------------------------------
# Method to allocate array
#-------------------------------------------------------------------------------
from numpy import float32
#*******************************************************************************
##\brief Python3 method.
#Method to allocate an array
#*******************************************************************************
#\param size               Size
#\param value_type         Value type Initialized to float32
#\param step               Step Initialized to None
#\param progress           Progresss Initialized to None
#\param reverse_indices    Reverse indices Initialized to True
#\param zero_fill          Zero fill Initialized to False
#\return m aloccated array
def allocate_array(size, value_type = float32, step = None, progress = None,
                   reverse_indices = True, zero_fill = False):

  __func__= sys._getframe().f_code.co_name
  if step is None:
    msize = size
  else:
    msize = [1+(sz-1)/st for sz,st in zip(size, step)]

  shape = list(msize)
  if reverse_indices:
    shape.reverse()

  if zero_fill:
    from numpy import zeros as alloc
  else:
    from numpy import empty as alloc

  try:
    m = alloc(shape, value_type)
  except ValueError:
    # numpy 1.0.3 sometimes gives ValueError, sometimes MemoryError
    report_memory_error(msize, value_type)
  except MemoryError:
    report_memory_error(msize, value_type)

  if progress:
    progress.array_size(msize, m.itemsize)

  return m

#-------------------------------------------------------------------------------
#Reports a memory error on file
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Reports a memory error on file
#*******************************************************************************
#\param size         Size
#\param value_type   Value type
def report_memory_error(size, value_type):

  __func__= sys._getframe().f_code.co_name
  from numpy import dtype, product, float
  vtype = dtype(value_type)
  tsize = vtype.itemsize
  bytes = product(size, dtype=float)*float(tsize)
  mbytes = bytes / 2**20
  sz = ','.join(['%d' % s for s in size])
  e = ('Could not allocate %.0f Mbyte array of size %s and type %s.\n'
       % (mbytes, sz, vtype.name))
  # from chimera import replyobj, CancelOperation                                                             #ALP
  # replyobj.error(e)
  # raise CancelOperation, e
#-------------------------------------------------------------------------------
# Write an MRC 2000 format file.
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
# Header contains four byte integer or float values:
#
#- 1 NX  number of columns (fastest changing in map)
#- 2 NY  number of rows
#- 3 NZ  number of sections (slowest changing in map)
#- 4 MODE  data type :
#-     0 image : signed 8-bit bytes range -128 to 127
#-     1 image : 16-bit halfwords
#-     2 image : 32-bit reals
#-     3 transform : complex 16-bit integers
#-     4 transform : complex 32-bit reals
#- 5 NXSTART number of first column in map
#- 6 NYSTART number of first row in map
#- 7 NZSTART number of first section in map
#- 8 MX  number of intervals along X
#- 9 MY  number of intervals along Y
#- 10  MZ  number of intervals along Z
#- 11-13 CELLA cell dimensions in angstroms
#- 14-16 CELLB cell angles in degrees
#- 17  MAP#- axis corresp to cols (1,2,3 for X,Y,Z)
#- 18  MAPR  axis corresp to rows (1,2,3 for X,Y,Z)
#- 19  MAPS  axis corresp to sections (1,2,3 for X,Y,Z)
#- 20  DMIN  minimum density value
#- 21  DMAX  maximum density value
#- 22  DMEAN mean density value
#- 23  ISPG  space group number 0 or 1 (default=0)
#- 24  NSYMBT  number of bytes used for symmetry data (0 or 80)
#- 25-49   EXTRA extra space used for anything
#- 50-52 ORIGIN  origin in X,Y,Z used for transforms
#- 53  MAP character string 'MAP ' to identify file type
#- 54  MACHST  machine stamp
#- 55  RMS rms deviation of map from mean density
#- 56  NLABL number of labels being used
#- 57-256 LABEL(20,10) 10 80-character text labels
#*******************************************************************************
#\param mrcdata       MRC data
#\param path          Path
#\return MRC data in a matrix format to file
#-------------------------------------------------------------------------------
# independent mrc file writter
#-------------------------------------------------------------------------------
def write_mrc_file(mrcdata, path):
  f = open(path, 'wb')

  mtype = mrcdata.element_type
  type = closest_mrc2000_type(mtype)

  import numpy as np
  stats = {}
  stats['min']  = np.min(mrcdata.matrix)
  stats['max']  = np.max(mrcdata.matrix)
  stats['mean'] = np.mean(mrcdata.matrix)
  stats['rms']  = np.std(mrcdata.matrix)

  header = mrc2000_header(mrcdata, type, stats)

  f.seek(0)
  f.write(header)

  mrcdata.matrix.tofile(f)

  f.close()

#-------------------------------------------------------------------------------
# Independent mrc file writter
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Writes to disk for a matrix a MRC file.
#*******************************************************************************
#\param mrcdata       mrcdata to extract the header from
#\param Matrixdata    Matrix data to written to MRC file
#\param path          Path
#\return Writes to disk in an MRC format the Matrixdata with mrcdata header
def write_Data2mrc_file(mrcdata, Matrixdata, path):
  f = open(path, 'wb')

  mtype = mrcdata.element_type
  type = closest_mrc2000_type(mtype)

  import numpy as np
  stats = {}
  stats['min']  = np.min(mrcdata.matrix)
  stats['max']  = np.max(mrcdata.matrix)
  stats['mean'] = np.mean(mrcdata.matrix)
  stats['rms']  = np.std(mrcdata.matrix)

  header = mrcMatrix_header(mrcdata, Matrixdata, type, stats)

  f.seek(0)
  f.write(header)

  Matrixdata.tofile(f)

  f.close()

#-------------------------------------------------------------------------------
# Writes mrc2000 MRC files to grid data
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Writes mrc2000 MRC files to grid data.
#*******************************************************************************
#\param mrcdata       mrcdata to extract the header from
#\param path          Path
#\param options       Options Initialized to empty list {}
#\param progress      Progress Initialized to None
#\return Writes to disk in an MRC2000 format for mrcdata header
def write_mrc2000_grid_data(mrcdata, path, options = {}, progress = None):

  __func__= sys._getframe().f_code.co_name
  mtype = mrcdata.element_type
  type = closest_mrc2000_type(mtype)

  f = open(path, 'wb')
  if progress:
    progress.close_on_cancel(f)

  # header = mrc2000_header(mrcdata, type)
  # f.write(header)

  # stats = Matrix_Statistics()
  # isz, jsz, ksz = mrcdata.data_size
  # for k in range(ksz):
  #     # matrixA = mrcdata.matrix((0,0,k), (isz,jsz,1))
  #     matrixA = mrcdata.matrix[:,:,k]
  #     if type != mtype:
  #         matrixA = matrixA.astype(type)
  #     f.write(matrixA.tostring())
  #     stats.plane(matrixA)
  #     if progress:
  #         progress.plane(k)

  import numpy as np
  stats = {}
  stats['min']  = np.min(mrcdata.matrix)
  stats['max']  = np.max(mrcdata.matrix)
  stats['mean'] = np.mean(mrcdata.matrix)
  stats['rms']  = np.std(mrcdata.matrix)

  # Put matrix statistics in header
  header = mrc2000_header(mrcdata, type, stats)
  f.seek(0)
  f.write(header)

  mrcdata.matrix.tofile(f)

  f.close()

#-------------------------------------------------------------------------------
# Returns header
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Writes a header for a matrix
#*******************************************************************************
#\param mrcdata               mrcdata to extract the header from
#\param mode_type             MRC mode type
#\param stats                 Statistic from the header Initialized to None
#\return header Header from the mrcdata for MRC file output
def mrc_header(mrcdata, mode_type, stats = None):

  __func__= sys._getframe().f_code.co_name
  size = mrcdata.data_size
  from numpy import float32, int16, int8, int32
  if mode_type == float32:         mode = 2
  elif mode_type == int16:         mode = 1
  elif mode_type == int8:          mode = 0

  #modified from map to list map in python3
  cell_size = list ( map(lambda a,b: a*b, mrcdata.data_step, size) )

  if stats:
    dmin, dmax = stats['min'], stats['max']
    dmean, rms = stats['mean'], stats['rms']
  else:
    dmin = dmax = dmean = rms = 0

  from numpy import little_endian
  if little_endian:
    machst = 0x00004144
  else:
    machst = 0x11110000

  # from chimera.version import release
  from time import asctime
  ver_stamp = 'DataManage %s' % asctime()
  labels = [ver_stamp[:80]]

  # if grid_data.rotation != ((1,0,0),(0,1,0),(0,0,1)):
  #     import Matrix
  #     axis, angle = Matrix.rotation_axis_angle(grid_data.rotation)
  #     r = 'Chimera rotation: %12.8f %12.8f %12.8f %12.8f' % (axis + (angle,))
  #     labels.append(r)

  nlabl = len(labels)
  # Make ten 80 character labels.
  labels.extend(['']*(10-len(labels)))
  labels = [l + (80-len(l))*'\0' for l in labels]
  labelstr = ''.join(labels)

  strings = [
    binary_string(size, int32),  # nx, ny, nz
    binary_string(mode, int32),  # mode
    binary_string((mrcdata.header['ncstart'],mrcdata.header['nrstart'],mrcdata.header['nsstart']), int32),# binary_string((0,0,0), int32), # nxstart, nystart, nzstart
    binary_string(size, int32),  # mx, my, mz
    binary_string(cell_size, float32), # cella
    binary_string(mrcdata.cell_angles, float32), # cellb
    binary_string((1,2,3), int32), # mapc, mapr, maps
    binary_string((dmin, dmax, dmean), float32), # dmin, dmax, dmean
    binary_string(0, int32), # ispg
    binary_string(0, int32), # nsymbt
    binary_string([0]*25, int32), # extra
    binary_string(mrcdata.data_origin, float32), # origin
    binary_string("MAP ",str), # map
    binary_string(machst, int32), # machst
    binary_string(rms, float32), # rms
    binary_string(nlabl, int32), # nlabl
    binary_string(labelstr, str)
  ]

  header = b"".join(strings)
  return header

#-------------------------------------------------------------------------------
# Returns a header for a matrix, called from write_Data2mrc_file
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Writes a header for a matrix, called from {@\link write_Data2mrc_file}.
#*******************************************************************************
#\param mrcdata               mrcdata to extract the header from
#\param Matrixdata            Matrix to be written to disk in an MRC file
#\param value_type            Value type
#\param stats                 Statistic from the header Initialized to None
#\return Header from the mrcdata for MRC file output
def mrcMatrix_header(mrcdata, Matrixdata, value_type, stats = None):

  __func__= sys._getframe().f_code.co_name
  import numpy as np
  data_size = [Matrixdata.shape[0],Matrixdata.shape[1],Matrixdata.shape[2]]
  size = data_size
  
  from numpy import float32, int16, int8, int32
  if value_type == float32:         mode = 2
  elif value_type == int16:         mode = 1
  elif value_type == int8:          mode = 0

  #modified from map to list map in python3
  cell_size = list ( map(lambda a,b: a*b, mrcdata.data_step, size) )

  if stats:
    dmin, dmax = stats['min'], stats['max']
    dmean, rms = stats['mean'], stats['rms']
  else:
    dmin = dmax = dmean = rms = 0

  from numpy import little_endian
  if little_endian:
    machst = 0x00004144
  else:
    machst = 0x11110000

  # from chimera.version import release
  from time import asctime
  ver_stamp = 'DataManage %s' % asctime()
  labels = [ver_stamp[:80]]

  # if grid_data.rotation != ((1,0,0),(0,1,0),(0,0,1)):
  #     import Matrix
  #     axis, angle = Matrix.rotation_axis_angle(grid_data.rotation)
  #     r = 'Chimera rotation: %12.8f %12.8f %12.8f %12.8f' % (axis + (angle,))
  #     labels.append(r)

  nlabl = len(labels)
  # Make ten 80 character labels.
  labels.extend(['']*(10-len(labels)))
  labels = [l + (80-len(l))*'\0' for l in labels]
  labelstr = ''.join(labels)

  strings = [
    binary_string(size, int32),  # nx, ny, nz
    binary_string(mode, int32),  # mode
    binary_string((mrcdata.header['ncstart'],
                   mrcdata.header['nrstart'],
                   mrcdata.header['nsstart']), int32),# binary_string((0,0,0), int32), # nxstart, nystart, nzstart
    binary_string(size, int32),  # mx, my, mz
    binary_string(cell_size, float32), # cella
    binary_string(mrcdata.cell_angles, float32), # cellb
    binary_string((1,2,3), int32), # mapc, mapr, maps
    binary_string((dmin, dmax, dmean), float32), # dmin, dmax, dmean
    binary_string(0, int32), # ispg
    binary_string(0, int32), # nsymbt
    binary_string([0]*25, int32), # extra
    binary_string(mrcdata.data_origin, float32), # origin
    binary_string("MAP ",str), # map
    binary_string(machst, int32), # machst
    binary_string(rms, float32), # rms
    binary_string(nlabl, int32), # nlabl
    binary_string(labelstr, str)
  ]

  header = b"".join(strings)
  return header

#-------------------------------------------------------------------------------
# Returns a header for a mrc2000MRC file.
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Returns a header for a mrc2000MRC file.
#*******************************************************************************
#\param mrcdata               mrcdata to extract the header from
#\param value_type            Value type
#\param stats                 Statistic from the header Initialized to None
#\return Header from the mrcdata for MRC file output
def mrc2000_header(mrcdata, value_type, stats = None):

  __func__= sys._getframe().f_code.co_name
  size = mrcdata.data_size

  from numpy import float32, int16, int8, int32
  if value_type == float32:         mode = 2
  elif value_type == int16:         mode = 1
  elif value_type == int8:          mode = 0

  #modified from map to list map in python3
  cell_size = list ( map(lambda a,b: a*b, mrcdata.data_step, size) )

  if stats:
    dmin, dmax = stats['min'], stats['max']
    dmean, rms = stats['mean'], stats['rms']
  else:
    dmin = dmax = dmean = rms = 0

  from numpy import little_endian
  if little_endian:
    machst = 0x00004144
  else:
    machst = 0x11110000

  # from chimera.version import release
  from time import asctime
  ver_stamp = 'DataManage %s' % asctime()
  labels = [ver_stamp[:80]]

  # if grid_data.rotation != ((1,0,0),(0,1,0),(0,0,1)):
  #     import Matrix
  #     axis, angle = Matrix.rotation_axis_angle(grid_data.rotation)
  #     r = 'Chimera rotation: %12.8f %12.8f %12.8f %12.8f' % (axis + (angle,))
  #     labels.append(r)

  nlabl = len(labels)
  # Make ten 80 character labels.
  labels.extend(['']*(10-len(labels)))
  labels = [l + (80-len(l))*'\0' for l in labels]
  labelstr = ''.join(labels)

  strings = [
    binary_string(size, int32),  # nx, ny, nz
    binary_string(mode, int32),  # mode
    binary_string((mrcdata.header['ncstart'],mrcdata.header['nrstart'],mrcdata.header['nsstart']), int32),# binary_string((0,0,0), int32), # nxstart, nystart, nzstart
    binary_string(size, int32),  # mx, my, mz
    binary_string(cell_size, float32), # cella
    binary_string(mrcdata.cell_angles, float32), # cellb
    binary_string((1,2,3), int32), # mapc, mapr, maps
    binary_string((dmin, dmax, dmean), float32), # dmin, dmax, dmean
    binary_string(0, int32), # ispg
    binary_string(0, int32), # nsymbt
    binary_string([0]*25, int32), # extra
    binary_string(mrcdata.data_origin, float32), # origin
    binary_string("MAP ",str), # map
    binary_string(machst, int32), # machst
    binary_string(rms, float32), # rms
    binary_string(nlabl, int32), # nlabl
    binary_string(labelstr, str)
  ]

  header = b"".join(strings)
  return header

#-------------------------------------------------------------------------------
# Returns an array of values to string.
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Returns an array of values to string.
#*******************************************************************************
#\param values                Values to be returned
#\param type                  Type
#\return ctype a C type
def binary_string(values, type):
  from numpy import array
  __func__= sys._getframe().f_code.co_name
  return array(values, type).tostring()

#-------------------------------------------------------------------------------
# Returns a ctype closest to MRC2000 file type
#-------------------------------------------------------------------------------
#*******************************************************************************
##\brief Python3 method.
#Returns a ctype closest to MRC2000 file type.
#*******************************************************************************
#\param type                  Type
#\return ctype a C type
def closest_mrc2000_type(type):

  from numpy import float, float32, float64
  from numpy import int, int8, int16, int32, int64, character
  from numpy import uint, uint8, uint16, uint32, uint64
  __func__= sys._getframe().f_code.co_name
  if type in (float32, float64, float, int32, int64, int, uint, uint16, uint32, uint64):
    ctype = float32
  elif type in (int16, uint8):
    ctype = int16
  elif type in (int8, character):
    ctype = int8
  else:
    #raise TypeError, ('Volume data has unrecognized type %s' % type)
    raise TypeError("Volume data has unrecognized type: "+type)

  return ctype

#---------------------------------------------------------------------------
# end of DataManage_fileIO module
#---------------------------------------------------------------------------
