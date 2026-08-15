import subprocess
import os
import sys
from datetime import datetime

def run_cmd(cmd, check=True):
    print(f"[INFO] Running command {' '.join(cmd)}")
    result = subprocess.run(cmd, text=True);
    if check and result.returncode != 0:
        print(f"[ERROR] Command failed with code {result.returncode}")
        sys.exit(result.returncode)
        
def run_simulation():
    project_dir = os.getcwd()
    log_path = os.path.join(project_dir, "simulation_history.log")
    temp_path = os.path.join(project_dir, "_current_run_log.tmp")
    
    start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    run_cmd(["vlib", "work"])
    run_cmd(["vmap", "work", "work"])
    
    compile_cmd = [
    "vlog",
    "-sv",
    "dec.sv",
    "dec_pkg.sv",
    "dec_if.sv",
    "dec_tb.sv"
    ]
    run_cmd(compile_cmd)
    
    tcl_cmd = (
    "onbreak {resume}; "
    "onElabError {resume}; "
    "set NoQuitOnFinish 1; "
    "vcd file waves.vcd; "
    "vcd add -r /dec_tb/*; "
    "run -all; "
    "quit -f; "
    )
    
    sim_cmd = [
    "vsim",
    "-c",
    "work.dec_tb",
    "-l",
    temp_path,
    "-sv_seed",
    "random",
    "-do",
    tcl_cmd
    ]
    run_cmd(sim_cmd, check=False)
    
    run_output = ""
    if os.path.exists(temp_path):
        with open(temp_path, "r") as fl:
            run_output = fl.read()
            
    with open(log_path, "a") as fl:
        fl.write("\n")
        fl.write("=========================================\n")
        fl.write(f"SIMULATION RUN STARTED {start_time}\n")
        fl.write(f"PROJECT DIRECTORY {project_dir}\n")
        fl.write("=========================================\n")
        fl.write(run_output)
        
    print(f"[INFO] Appended this run to: {log_path}")
    
    if os.path.exists(temp_path):
        os.remove(temp_path)
        
if __name__ == "__main__":
    run_simulation()