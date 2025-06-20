# A-hitch-hikers-guide-to-jupyter
Running Jupyter Notebooks On The Cluster

<img src="https://github.com/user-attachments/assets/f7160169-8d5f-416a-830f-79a386b54488" width="600" height="400">


## Table of Contents

- [Jump to Phoenix](#jump-to-pheonix)
  - [Navigating to Your Space](#navigation-to-your-space)
- [Setting Up Your Environment](#side-quest-in-a-virtual-enviroment)
- [Job submission with slurm](#getting-off-before-jupyter)
- [Running Jupyter](#to-jupyter)
  - [Interactive Session (srun)](#short-and-long)
  - [Batch Session (sbatch)](#long-and-short)

## resources
[sbatch script](jupyter.sbatch) and [shell script](sbatch_wrapper.sh)
# Jump to pheonix 
### The jump
  
The first step on our journey to jupyter will be to connect to the cluster, we do so by entering the following command in the terminal: 

```zsh
  ssh -J <your username>@bava.cs.huji.ac.il <your username>@phoenix
```
As a matter of personal preferance any command that I use alot I create a zsh function to enter the command. To enter your zsh config file:

```zsh
nano ~/.zshrc
```
Let us now write a function that can be called to enter the above command.

```zsh
# Jump to pheonix
jump() {
  ssh -J <your username>@bava.cs.huji.ac.il <your username>@phoenix
}
# To use in the commnad line simply type: jump  
```
To write the file 'ctr+o' then 'enter' and then to exit the file 'ctr+x' 

You will now be prompted to enter your OTP (explained here https://wiki.rcs.huji.ac.il/hurcs/user_management/otp) and CS password

<img src="https://github.com/user-attachments/assets/3936ad53-a956-4f8b-bb7d-9f29d4b7ee86" width="400" height="50">

### Navigation to your space
You have now entered the cluster but you are only at the login node which should only be used for file managenment and job submission, you now need to go to your space within the labs storage.

```zsh
cd  /cs/labs/mornitzan/<your username>
```
Since you will be going here often we can write a simplfied command to use to take you here in your zsh config (note this file is on the cluster not local)

```zsh
alias myplace='cd  /cs/labs/mornitzan/<your username>'
```
# Side Quest in a virtual enviroment

You are going to be using a lot of different packages over the course of your time here you will want to create a vitrual enviroment for each project to avoid confilicts and installation issues (if only we could this in the real world!).

```zsh
python3 -m venv <environment_name>
```
To activate 

```zsh
source <environment_name>/bin/activate
```
At this point pip install ipykernel that will be required soon enough 

# Getting off Before jupyter
If you dont want to tag along to jupyter and simply want to run a python script then just follow along the either of the following to two methods to submit a job and then you are good to go. lets take a look at the srun slurm command, change the time and mem parameters according to your needs and you can pick a gpu from list for pheonix here: https://wiki.cs.huji.ac.il/wiki/Phoenix_cluster_policy

```zsh
srun --time=8:00:00 --mem=16G --gres=gpu:rtx2080:1 --pty $SHELL
```
You are now in a working node and can run your script. The problem with srun is that it is tied to your terminal meaning if you close your terminal or disconnect from the server, the job will automatically be killed and all of the hard work you and the GPU have done will be erased. To mitigate the chances of being disconnected and your job being killed you can adjust your ssh config file 

```bash
nano  ~/.ssh/config
```
and add this in 

```bash
Host *
    ServerAliveInterval 180
    ServerAliveCountMax 2
```

The next method allows you to run a job that will continue running on the cluster regardless of whether you are connected or not 

```
sbatch --mem=500m -c2 --gres=gpu:2 "myscript"
``` 

# To jupyter
### Short and long
To run a server we first need to submit a job, here we will use the srun slurm command to do so 
Notice that you are now in a working node of the cluster since you will be running a notebook saved locally on your machine on a server that is running on the cluster. To facilitate a secure transfer of information between the cluster and your machine you need to create a tunnel in a **new terminal**  to the allocated working node. 

<img src="https://github.com/user-attachments/assets/2bd6cf1d-06f4-480b-aa0a-1ee7459f8544" width="500" height="75">

In this example I have been allocated the node "dumfries-010" which I would then insert in this command to tunnel:

```zsh
sh -J <your username>@bava.cs.huji.ac.il -L 8888:node:8888 <your username>@node
```
Back in the original temrinal where the job is running you can now create a jupyter server

```zsh
jupyter-notebook --no browser --ip=0.0.0.0
```
The output should look like this 

<img src="https://github.com/user-attachments/assets/cc33c4d5-a258-4825-8e78-895c0a428120" width="600" height="100">

Copy paste the address to the server in chrome or in vscode's exisiting server option for kernel choice. Congratulations you have made it to jupyter. 

### Long and short 

As previously mentioned a job submitted with sbatch will keep on running even if you disconnect , here is an example [script](jupyter.sbatch). If you do disconnect you can simply tunnel back to the work node the job is running on and access the server through the same address (which you can find in jupyter_<job_number>.log)  

```zsh
sbatch jupyter.sbatch
```
The output will be "Submitted batch job <job_number>" to retrieve the address to the server you must enter the log file 

```zsh
cat jupyter_<job_number>.log
```
You now need to tunnel to the worker node you were allocated and then you can copy paste the server address to chrome or vscode ect. 
Note that the only way this job will terminate is if it either runs out of time or you cancel it with one of the following two commands. Inlcuded in the [script](jupyter.sbatch) is a function that will automatically clear the log and error files

```zsh
# To kill all jobs
scancel -u $USER

# To kill a specific job
scancel <job_number>
```
Lastly I have included a [shell script](sbatch_wrapper.sh) wrapper for the sbatch script that retrieves the server address and work node/hostname for the log file which can be run with 

```
./sbatch_wrapper.sh
```






