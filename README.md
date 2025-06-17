## A-hitch-hikers-guide-to-jupyter
Running Jupyter Notebooks On The Cluster

<img src="https://github.com/user-attachments/assets/f7160169-8d5f-416a-830f-79a386b54488" width="600" height="400">



# Jump to pheonix
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

You have now entered the cluster but you are only at the login node which should only be used for file managenment and job submission, you now need to go to your space within the labs storage.

```zsh
cd  /cs/labs/mornitzan/<your username>
```
Since you will be going here often we can write a simplfied command to use to take you here in your zsh config (note this file is on the cluster not local)

```zsh
alias myplace='cd  /cs/labs/mornitzan/<your username>'
```
# Side Quest in a virtual envoriment



