#!/bin/sh 
### General options 
### -- specify queue -- 
#BSUB -q hpc
### -- Set number of parameters to sweep + set the job name 
#BSUB -J fenitop[1] #96 # IMPORTANT!!!!
### -- ask for number of cores (default: 1) -- 
#BSUB -n 96 # 16, 36, 64
### -- specify that the cores must be on the same host -- 
##BSUB -R "span[hosts=1]"
#BSUB -R "span[block=8]"
### -- specify that we need x GB of memory per core/slot -- 
#BSUB -R "rusage[mem=5GB]"
### -- specify that we want the job to get killed if it exceeds x GB per core/slot -- 
#BSUB -M 5GB
### -- set walltime limit: hh:mm -- 
#BSUB -W 24:00 
### -- set the email address -- 
# please uncomment the following line and put in your e-mail address,
# if you want to receive e-mail notifications on a non-default address
##BSUB -u YOURMAIL@SOMEWHERE.COM
### -- send notification at start -- 
##BSUB -B 
### -- send notification at completion -- 
##BSUB -N 
### -- Specify the output and error file. %J is the job-id -- 
### -- -o and -e mean append, -oo and -eo mean overwrite -- 
#BSUB -o ./run_log/Output_%J_%I.out 
#BSUB -e ./run_log/Error_%J_%I.err 

######### program to run
echo $PATH
pwd
echo "Start time:"
date
sleep "$((LSB_JOBINDEX))"

ulimit -s unlimited

# Export number of threads
numCores=$LSB_DJOB_NUMPROC
OMP_NUM_THREADS=1
numProcs=$(($LSB_DJOB_NUMPROC / $OMP_NUM_THREADS))
export numCores; echo "No. of cores =" $numCores
export numProcs; echo "No. of processes =" $numProcs
export OMP_NUM_THREADS; echo "No. of OMP threads =" $OMP_NUM_THREADS

# Set file paths
projectDir="/work3/mtaho/PhD/fenitop"
filePath_run=$projectDir/scripts/beam_3d.py

# Perform analysis
module purge
module load FEniCSx/0.9-python-3.13.2-test8

source $projectDir/venv/bin/activate
mpirun -n $numProcs python3 $filePath_run 
# python3 $filePath_run 