
#SBATCH --job-name=jupyter_server
##SBATCH --partition=short
#SBATCH --gres=gpu:a40:1
#SBATCH --mem=16GB
#SBATCH --time=8:00:00
#SBATCH --output=jupyter_%j.log
#SBATCH --error=jupyter_%j.err

# Define cleanup function to delete log files and kill Jupyter process
cleanup() {
    # Kill any Jupyter process started by this script
    pkill -u $USER -f "jupyter-notebook"
    # Remove log files
    rm -f jupyter_${SLURM_JOB_ID}.log jupyter_${SLURM_JOB_ID}.err jupyter_notebook.log
    exit 0
}

# Trap multiple signals to ensure cleanup runs
trap cleanup SIGHUP SIGINT SIGTERM EXIT

# Activate the virtual environment
source ~/<your venv>/bin/activate

# Get the hostname of the compute node
HOSTNAME=$(hostname)

# Start Jupyter server without browser, binding to all interfaces
PORT=8888
jupyter notebook --no-browser --ip=0.0.0.0 --port=$PORT > jupyter_notebook.log 2>&1 &

# Store Jupyter process ID
JUPYTER_PID=$!

# Wait a moment for the server to start
sleep 10

# Extract the Jupyter token from the log
TOKEN=$(grep -o "token=[a-zA-Z0-9_-]*" jupyter_notebook.log | head -1 | cut -d= -f2)

# Print connection instructions
echo "Access it via SSH: tunnel $HOSTNAME"
echo "Run though browser: http://localhost:$PORT"
echo "For VS Code, connect using this URL: http://localhost:$PORT/?token=$TOKEN"
if [ -n "$TOKEN" ]; then
    echo "Yalla to work"
else
    echo "No token found; check jupyter_notebook.log for details."
fi

# Wait for the Jupyter process to keep the job running
wait $JUPYTER_PID
