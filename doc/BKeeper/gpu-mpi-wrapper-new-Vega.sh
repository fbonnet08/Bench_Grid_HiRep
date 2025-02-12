#!/usr/bin/env bash
lrank=$OMPI_COMM_WORLD_LOCAL_RANK
#numa1=$((lrank))
#netdev=mlx5_${lrank}:1
numa1=$(( 3 + 4 * (lrank / 2) - 2 * (lrank % 2) ))
numa2=$(( numa1-1 ))
netdev=$(( lrank / 2 ))

echo "lrank        --->: $lrank"
echo "numa1        --->: $numa1"
echo "numa2        --->: $numa2"
echo "netdev       --->: $netdev"

export CUDA_VISIBLE_DEVICES=$OMPI_COMM_WORLD_LOCAL_RANK
export UCX_NET_DEVICES=${netdev}
BINDING="--interleave=${numa1},${numa2}"

echo "BINDING      --->: $BINDING"
echo "numa command --->: numactl ${BINDING} $@"

echo "$(hostname) - $lrank device=$CUDA_VISIBLE_DEVICES binding=$BINDING"

numactl ${BINDING} "$@"
