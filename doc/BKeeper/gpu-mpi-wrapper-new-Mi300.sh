#!/usr/bin/env bash
# Get the GPU ID assigned by SLURM
GPU_ID=$SLURM_PROCID
# Detect NUMA node for the assigned GPU using rocm-smi
lrank=$OMPI_COMM_WORLD_LOCAL_RANK
numa1=$((lrank))

NUM_GPUS=$(rocm-smi --showuniqueid | grep 'GPU' | wc -l);
n_gpus=$(( NUM_GPUS / 2 ))
echo "n gpus on sys--->: ${n_gpus}"

NUMA_NODE=$(rocm-smi --showtopo | grep "GPU\[$GPU_ID\]" | grep -oP 'Numa Node: \K\d+')

if [ -z "$NUMA_NODE" ]; then
    echo "Failed to detect NUMA node for GPU $GPU_ID"
    exit 1
fi

echo "Binding GPU $GPU_ID to NUMA node $NUMA_NODE"

# Set UCX environment variables for optimal communication
export UCX_MEMTYPE_CACHE=n
export UCX_TLS=rc,cuda_copy,cuda_ipc,sm
export UCX_NET_DEVICES=mlx5_0:1
export UCX_RNDV_THRESH=8192
export UCX_IB_REG_METHODS=rc_mlx5
export UCX_IB_GPU_DIRECT_RDMA=y
export AMD_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK

BINDING="--interleave=$numa1 --cpunodebind=$NUMA_NODE --membind=$NUMA_NODE --gpu-id=$GPU_ID"

echo "BINDING      --->: $BINDING"
echo "numa command --->: numactl ${BINDING} $@"
echo "numa mode    --->: ${NUMA_NODE}"
echo "$(hostname) - $lrank device=$AMD_VISIBLE_DEVICES binding=$BINDING"

# Bind to the correct NUMA node using numactl
numactl ${BINDING} "$@"

: '
#-------------------------------------------------------------------------------
# Usage commande for rocm-smi
#-------------------------------------------------------------------------------
usage: rocm-smi [-h] [-V] [-d DEVICE [DEVICE ...]] [--alldevices] [--showhw] [-a] [-i] [-v] [-e [EVENT ...]]
                [--showdriverversion] [--showtempgraph] [--showfwinfo [BLOCK ...]] [--showmclkrange] [--showmemvendor]
                [--showsclkrange] [--showproductname] [--showserial] [--showuniqueid] [--showvoltagerange] [--showbus]
                [--showpagesinfo] [--showpendingpages] [--showretiredpages] [--showunreservablepages] [-f] [-P] [-t]
                [-u] [--showmemuse] [--showvoltage] [-b] [-c] [-g] [-l] [-M] [-m] [-o] [-p] [-S] [-s]
                [--showmeminfo TYPE [TYPE ...]] [--showpids [VERBOSE]] [--showpidgpus [SHOWPIDGPUS ...]]
                [--showreplaycount] [--showrasinfo [SHOWRASINFO ...]] [--showvc] [--showxgmierr] [--showtopo]
                [--showtopoaccess] [--showtopoweight] [--showtopohops] [--showtopotype] [--showtoponuma]
                [--showenergycounter] [--shownodesbw] [--showcomputepartition] [--showmemorypartition] [--showmetrics]
                [-r] [--resetfans] [--resetprofile] [--resetpoweroverdrive] [--resetxgmierr] [--resetperfdeterminism]
                [--setclock TYPE LEVEL] [--setsclk LEVEL [LEVEL ...]] [--setmclk LEVEL [LEVEL ...]]
                [--setpcie LEVEL [LEVEL ...]] [--setslevel SCLKLEVEL SCLK SVOLT] [--setmlevel MCLKLEVEL MCLK MVOLT]
                [--setvc POINT SCLK SVOLT] [--setsrange SCLKMIN SCLKMAX] [--setextremum min|max sclk|mclk CLK]
                [--setmrange MCLKMIN MCLKMAX] [--setfan LEVEL] [--setperflevel LEVEL] [--setoverdrive %]
                [--setmemoverdrive %] [--setpoweroverdrive WATTS] [--setprofile SETPROFILE] [--setperfdeterminism SCLK]
                [--setcomputepartition {SPX,DPX,TPX,QPX,CPX,spx,dpx,tpx,qpx,cpx}]
                [--setmemorypartition {NPS1,NPS2,NPS4,NPS8,nps1,nps2,nps4,nps8}] [--rasenable BLOCK ERRTYPE]
                [--rasdisable BLOCK ERRTYPE] [--rasinject BLOCK] [--gpureset] [--load FILE | --save FILE]
                [--autorespond RESPONSE] [--loglevel LEVEL] [--json] [--csv]
#-------------------------------------------------------------------------------
# Usage commande for numactl
#-------------------------------------------------------------------------------
usage: numactl [--all | -a] [--interleave= | -i <nodes>] [--preferred= | -p <node>]
               [--physcpubind= | -C <cpus>] [--cpunodebind= | -N <nodes>]
               [--membind= | -m <nodes>] [--localalloc | -l] command args ...
       numactl [--show | -s]
       numactl [--hardware | -H]
       numactl [--length | -l <length>] [--offset | -o <offset>] [--shmmode | -M <shmmode>]
               [--strict | -t]
               [--shmid | -I <id>] --shm | -S <shmkeyfile>
               [--shmid | -I <id>] --file | -f <tmpfsfile>
               [--huge | -u] [--touch | -T]
               memory policy | --dump | -d | --dump-nodes | -D

memory policy is --interleave | -i, --preferred | -p, --membind | -m, --localalloc | -l
<nodes> is a comma delimited list of node numbers or A-B ranges or all.
Instead of a number a node can also be:
  netdev:DEV the node connected to network device DEV
  file:PATH  the node the block device of path is connected to
  ip:HOST    the node of the network device host routes through
  block:PATH the node of block device path
  pci:[seg:]bus:dev[:func] The node of a PCI device
<cpus> is a comma delimited list of cpu numbers or A-B ranges or all
all ranges can be inverted with !
all numbers and ranges can be made cpuset-relative with +
the old --cpubind argument is deprecated.
use --cpunodebind or --physcpubind instead
<length> can have g (GB), m (MB) or k (KB) suffixes
#-------------------------------------------------------------------------------
'
