#!/bin/bash

function run {
  echo =======
  echo mpirun -H ares01:2,ares02:2 -mca btl_openib_allow_ib 1 ./exec.cpu --num_vector $1 --num_field $2 --num_iterations $3
  time mpirun -H ares01:2,ares02:2 -mca btl_openib_allow_ib 1 ./exec.cpu --num_vector $1 --num_field $2 --num_iterations $3
}


run 6000 1250 64
run 2000 7500 64
run 3200 5500 64
run 2000 57600 64
run 1000 192000 64
run 1000 32000 64
run 800 50000 64
run 1000 12800 64
run 8000 21600 64