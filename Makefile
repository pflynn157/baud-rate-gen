# The files
FILES		= src/transmitter.vhdl \
				src/receiver.vhdl \
                src/baud_rate.vhdl \
                src/fifo.vhdl \
                src/uart.vhdl \
                src/ram.vhdl \
                src/classification.vhdl
SIMDIR		= sim
SIMFILES	= test/transmitter_tb.vhdl \
                test/receiver_tb.vhdl \
                test/baud_rate_tb.vhdl \
                test/fifo_tb.vhdl \
                test/uart_tb.vhdl \
                test/ram_tb.vhdl \
                test/classification_tb.vhdl

# GHDL
GHDL_CMD	= ghdl
GHDL_FLAGS	= --ieee=synopsys --warn-no-vital-generic
GHDL_WORKDIR = --workdir=sim --work=work
GHDL_STOP	= --stop-time=5000ns

# For visualization
VIEW_CMD        = /usr/bin/gtkwave

# The commands
all:
	make compile
	make run

compile:
	mkdir -p sim
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(FILES)
	ghdl -a $(GHDL_FLAGS) $(GHDL_WORKDIR) $(SIMFILES)
	ghdl -e -o sim/transmitter_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) transmitter_tb
	ghdl -e -o sim/receiver_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) receiver_tb
	ghdl -e -o sim/baud_rate_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) baud_rate_tb
	ghdl -e -o sim/fifo_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) fifo_tb
	ghdl -e -o sim/uart_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) uart_tb
	ghdl -e -o sim/ram_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) ram_tb
	ghdl -e -o sim/classification_tb $(GHDL_FLAGS) $(GHDL_WORKDIR) classification_tb

run:
	cd sim; \
	ghdl -r $(GHDL_FLAGS) transmitter_tb $(GHDL_STOP) --wave=wave.ghw; \
	ghdl -r $(GHDL_FLAGS) baud_rate_tb $(GHDL_STOP) --wave=wave2.ghw; \
	ghdl -r $(GHDL_FLAGS) fifo_tb --stop-time=500ns --wave=wave3.ghw; \
	ghdl -r $(GHDL_FLAGS) uart_tb --stop-time=500ns --wave=wave4.ghw; \
	ghdl -r $(GHDL_FLAGS) receiver_tb --stop-time=500ns --wave=wave5.ghw; \
	ghdl -r $(GHDL_FLAGS) ram_tb --stop-time=500ns --wave=wave6.ghw; \
	ghdl -r $(GHDL_FLAGS) classification_tb --stop-time=500ns --wave=wave7.ghw; \
	cd ..

view:
	gtkwave sim/wave3.ghw

clean:
	$(GHDL_CMD) --clean --workdir=sim
