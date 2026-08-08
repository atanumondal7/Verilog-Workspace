from datetime import datetime
import os
import subprocess
import sys

def run_cmd(cmd, check=True):
    print(f"[INFO] Running command: {' '.join(cmd)}")
    result = subprocess.run(cmd);
    if check and result.returncode != 0:
        print(f"[ERROR] Command failed with return code {result.returncode}")
        sys.exit(result.returncode)
        
def run_simulation():
    project_dir = os.getcwd()
    history_log_path = os.path.join(project_dir, "simulation_history.log")
    temp_transcript_path = os.path.join(project_dir, "_current_run_transcript.tmp")
    
    start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    run_cmd(["vlib", "work"])
    run_cmd(["vmap", "work", "work"])
    
    compile_cmd = [
        "vlog",
        "-sv",
        "alu.sv",
        "alu_pkg.sv",
        "alu_if.sv",
        "alu_tb.sv"
    ]
    run_cmd(compile_cmd)
    
    tcl_command = (
        "vcd file waves.vcd; "
        "vcd add -r /alu_tb/*; "
        "onBreak {resume}; "
        "onElabError {resume}; "
        "set NoQuitOnFinish 1; "
        "run -all;"
        "quit -f; "
        )
    
    sim_command = [
       "vsim",
       "-c",
       "work.alu_tb",
       "-l",
       temp_transcript_path,
       "-do",
       tcl_command,
    ]
   
    run_cmd(sim_command, check=False)
   
    run_output = ""
    if os.path.exists(temp_transcript_path):
        with open(temp_transcript_path, "r") as fl:
            run_output = fl.read()
           
    with open(history_log_path, "a") as fl:
        fl.write("/n")
        fl.write("==================================================\n")
        fl.write(f"SIMULATION RUN STARTED: {start_time}\n")
        fl.write(f"Working Directory: {project_dir}\n")
        fl.write("==================================================\n")
        fl.write(run_output)
        
    print(f"[INFO] Appended this run to: {history_log_path}")
    
    if os.path.exists(temp_transcript_path):
        os.remove(temp_transcript_path)
        
if(__name__ == "__main__"):
    run_simulation()