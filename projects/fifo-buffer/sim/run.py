from datetime import datetime
import os
import sys
import subprocess

def run_cmd(cmd, check=True):
    print(f"[INFO] Running Command: {' '.join(cmd)}")
    result = subprocess.run(cmd, text=True)
    if check and result.returncode != 0:
        print(f"[ERROR] Command failed with return code {result.returncode}");
        sys.exit(result.returncode)
    
def run_sim():    
    project_dir = os.getcwd()
    history_log_path = os.path.join(project_dir, "simulation_history.log")
    temp_transcript_path = os.path.join(
        project_dir, "_current_run_transcript.tmp"
    )
    
    start_time = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    run_cmd(["vlib", "work"])
    run_cmd(["vmap", "work", "work"])
    
    compile_cmd = [
        "vlog",
        "-sv",
        "-f",
        "files.f"
    ]
    
    run_cmd(compile_cmd)
    
    tcl_cmd = (
        "vcd file waves.vcd; "
        "vcd add -r /fifo_tb/*; "
        "onbreak {resume}; "
        "onElabError {resume}; "
        "set NoQuitOnFinish 1; "
        "run -all; "
        "quit -f; "
    )
    
    sim_cmd = [
        "vsim",
        "-c",
        "work.fifo_tb",
        "-l",
        temp_transcript_path,
        "-sv_seed",
        "random",
        "-do",
        tcl_cmd
    ]
    
    run_cmd(sim_cmd, check=False)
    
    run_output = "";
    if(os.path.exists(temp_transcript_path)):
        with open (temp_transcript_path, "r") as fl:
            run_output = fl.read();
            
    
    with open (history_log_path, "a") as fl:
        fl.write("=====================================\n")
        fl.write(f"[INFO] SIMULATION LOGGING STARTED AT {start_time}")
        fl.write(f"[INFO] WORKING DIRECTORY: {project_dir}")
        fl.write("=====================================\n")
        fl.write(run_output)
            
    print(f"[INFO] SIMULATION LOG APPENDED TO {history_log_path}")
    
    if(os.path.exists(temp_transcript_path)):
        os.remove(temp_transcript_path)
        
if(__name__ == "__main__"):
    run_sim()