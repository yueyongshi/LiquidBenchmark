#!/bin/sh
# walltime : maximum wall clock time (hh:mm:ss)
#PBS -l walltime=71:59:59
#
# join stdout and stderr
#PBS -j oe
#
# spool output immediately
#PBS -k oe
#
# specify GPU queue
#PBS -q gpu
#
# nodes: number of nodes
#   ppn: number of processes per node
#  gpus: number of gpus per node
#  GPUs are in 'exclusive' mode by default, but 'shared' keyword sets them to shared mode.
#PBS -l nodes=1:ppn=1:gpus=1:exclusive
#
# export all my environment variables to the job
#PBS -V
#
# job name (default = name of script file)
#PBS -N DENSITY
#
# specify email for notifications
#PBS -M julie.behr@choderalab.org
#
# mail settings (one or more characters)
# n: do not send mail
# a: send mail if job is aborted
# b: send mail when job begins execution
# e: send mail when job terminates
#PBS -m n
#
# filename for standard output (default = <job_name>.o<job_id>)
# at end of job, it is in directory from which qsub was executed
# remove extra ## from the line below if you want to name your own file
##PBS -o myoutput

# Change to working directory used for job submission
cd $PBS_O_WORKDIR

export CUDA_VISIBLE_DEVICES=`cat $PBS_GPUFILE | awk -F"-gpu" '{ printf A$2;A=","}'`

echo $CUDA_VISIBLE_DEVICES

echo $HOSTNAME
# start spark workers
python ${HOME}/src/kyleabeauchamp/LiquidBenchmark/src/simulation/simulate_thermoml.py $PBS_ARRAYID
