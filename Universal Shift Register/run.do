vlib work
vmap work work

vlog -sv usr.sv usr_pkg.sv usr_if.sv usr_tb.sv

vsim -c work.usr_tb
vcd file waves.vcd
vcd add -r /usr_tb/*

# Prevent $finish inside the testbench from immediately killing the
# process. Without this, `run -all` never returns to this script when
# the testbench calls $finish -- it just exits, skipping everything
# below (including our log flush).
onbreak {resume}
onElabError {resume}
set NoQuitOnFinish 1

run -all

# Now that $finish doesn't auto-quit, control returns here.
auto_flush_sim_log

quit -f
