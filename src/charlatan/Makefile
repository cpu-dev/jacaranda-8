verilog = alu_controller.v  alu.v  computer.v  cpu.v  data_mem.v  decoder.v  instr_mem.v  main_controller.v  regfile.v  test_bench.v UART/UART.v UART/tx.v UART/rx.v LED/LED4.v
output = computer
top = test_bench
wave = wave.vcd

all: $(verilog)
	iverilog -o $(output) -s $(top) $(verilog)
	vvp $(output)

$(wave): 
	make all

wave: $(wave)
	gtkwave $(wave) &

clean:
	rm $(output) $(wave)

