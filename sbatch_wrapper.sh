                                                    submit_jupyter.sh                                                                
#!/bin/bash

# Submit the SBATCH job and capture the job ID
SBATCH_OUTPUT=$(sbatch jupyter.sbatch)
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to submit SBATCH job."
    exit 1
fi


# Extract job ID from sbatch output (e.g., "Submitted batch job 26711043")
JOB_ID=$(echo "$SBATCH_OUTPUT" | grep -o '[0-9]\+')
echo "Submitted job $JOB_ID"

# Define log file
LOG_FILE="jupyter_${JOB_ID}.log"

# Wait for log file to appear
echo "Waiting for log file $LOG_FILE to be created..."
TIMEOUT=60  # Wait up to 60 seconds
ELAPSED=0
while [[ ! -f "$LOG_FILE" && $ELAPSED -lt $TIMEOUT ]]; do
    sleep 1
    ((ELAPSED++))
done

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: Log file $LOG_FILE not found after $TIMEOUT seconds."
    echo "Check job status with: squeue -u $USER"
    exit 1
fi

# Monitor log file until token appears or error is detected
while true; do
    if grep -q "Yalla to work" "$LOG_FILE"; then
        echo "Jupyter server details found:"
        cat "$LOG_FILE"
        break
    elif grep -q "No token found" "$LOG_FILE"; then
        echo "Error: No token found in $LOG_FILE"
        cat "$LOG_FILE"
        echo "Check jupyter_notebook.log or jupyter_${JOB_ID}.err for details:"
        cat jupyter_notebook.log 2>/dev/null
        cat jupyter_${JOB_ID}.err 2>/dev/null
        exit 1
    fi
    sleep 2
done
