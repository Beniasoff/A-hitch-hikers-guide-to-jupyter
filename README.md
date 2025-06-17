# A-hitch-hikers-guide-to-jupyter
Running Jupyter Notebooks On The Cluster

<img src="https://github.com/user-attachments/assets/f7160169-8d5f-416a-830f-79a386b54488" width="600" height="400">



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

### Navidation to your space
You have now entered the cluster but you are only at the login node which should only be used for file managenment and job submission, you now need to go to your space within the labs storage.

```zsh
cd  /cs/labs/mornitzan/<your username>
```
Since you will be going here often we can write a simplfied command to use to take you here in your zsh config (note this file is on the cluster not local)

```zsh
alias myplace='cd  /cs/labs/mornitzan/<your username>'
```
# Side Quest in a virtual envoriment

Since you are going to be using a lot of different packages over the course of your time here you will want to create a vitrual enviroment for each project to avoid confilicts and installation issues (if only we could this in the real world!).

```zsh
python3 -m venv <environment_name>
```
To activate 

```zsh
source <environment_name>/bin/activate
```
At this point pip install ipykernel that will be required soon enough 

# To jupyter
### Short and long 

To run a server we first need to create a job here will use the srun slum command to do so 

```zsh
srun --time=8:00:00 --mem=16G --gres=gpu:rtx2080:1 --pty $SHELL
```
Change the time and mem parameters according to your needs and you can pick a gpu from list for pheonix here: https://wiki.cs.huji.ac.il/wiki/Phoenix_cluster_policy

You will notice that you are now in a working node of the cluster since you will be running a notebook locally on a server in the cluster you need to create a tunnel to the allocated working node. 

<img src="https://github.com/user-attachments/assets/2bd6cf1d-06f4-480b-aa0a-1ee7459f8544" width="500" height="75">

In this example I have been allocated the node "dumfries-010" which I would then insert in this command to tunnel to, this needs to be done in a **new terminal**  

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

The problem with srun is that if you disconnect form the server the job will automatically be killed and all of the hard work you and the GPU have done will be erased. The solution I found is to instead use sbatch to submit the job and it will keep on running no matter what here is an exmaple [script](jupyter.sbatch) you can create your script using nano and then run it like so 

```zsh
sbatch jupyter.sbatch
```
The output will be "Submitted batch job <job_number>" to retrieve the address to the server you must enter the log file 

```zsh
cat jupyter_<job_number>.log
```
Note that the only way this job will terminate is if it either runs out of time or you cancel it with one of the following two commands

```
# To kill all jobs
scancel -u $USER

# To kill a specific job
scancel <job_number>
```







