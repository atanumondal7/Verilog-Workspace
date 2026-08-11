from datetime import datetime
import os
import subprocess
import sys

def run_cmd(cmd, check=True):
    print(f"[INFO] Running command: {' '.join(cmd)}")
    result = subprocess.run(cmd)
    if check and result.returncode != 0:
        print(f"[ERROR] Command failed with return code {result.returncode}")
        sys.exit(result.returncode)
        
def run_simulation():
    project_dir = os.getcwd()
    history_log_path = os.path.join(project_dir, "simulation_history.log")
    temp_transcript_file = os.path.join(project_dir, "_current_run_transcript.tmp")
    
    start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    run_cmd(["vlib", "work"])
    run_cmd(["vmap", "work", "work"])
    
    compile_cmd = [
    "vlog",
    "-sv",
    "prioenc.sv",
    "prioenc_pkg.sv",
    "prioenc_if.sv",
    "prioenc_tb.sv"
    ]
    run_cmd(compile_cmd)
    
    tcl_cmd = (
    "vcd file waves.vcd; "
    "vcd add -r /prioend_tb/*; "
    "onBreak {resume}; "
    "onElabError {resume}; "
    "set NoFinishOnQuit 1; "
    "run -all; "
    "quit -f; "
    )
    
    sim_cmd = [
    "vsim",
    "-c",
    "work.prioenc_tb",
    "-l",
    temp_transcript_file,
    "-do",
    tcl_cmd
    ]
    run_cmd(sim_cmd, check=False)
    
    run_output = ""
    if os.path.exists(temp_transcript_file):
        with open(temp_transcript_file, "r") as fl:
            run_output = fl.read()
            
    with open(history_log_path, "a") as fl:
        fl.write("=============================================")
        fl.write("SIMULATION LOGGING STARTED AT {start_time}")
        fl.write("[INFO] LOGS APPENDED IN {history_log_path}")
        fl.write("=============================================")
        
    if os.path.exists(temp_transcript_file):
        os.remove(temp_transcript_file)
        
if(__name__ == "__main__"):
    run_simulation()