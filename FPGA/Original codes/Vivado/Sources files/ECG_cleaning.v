`timescale 1ns / 1ps
//Copyright Prevedel Lab @ EMBL, September, 2020
//
//


module ECG_cleaning(
    input clk,
    input vp14, // ADC input
    input vn14, // ADC input
    output [0:3] jc, // DAC output (SPI connection)
    output clock_control
    );
    
    // Inputs for the IP
    reg [1:0] user_mode=2'b10;
    reg [7:0] threshold = 90;
    reg [7:0] delay_percent=20;
    reg [7:0] percent=80;
    reg [7:0] safe_percent = 95; // Do not touch
    // End of IP inputs
    
    //XADC wire declaration    
    reg [6:0] daddr = 7'h1E; // address of channel to be read
    wire eoc; // xadc end of conversion flag
    wire [15:0] dout; // xadc data out bus
    wire drdy; // means "data ready" !
    reg [1:0] _drdy = 0; // delayed data ready signal for edge detection
    reg [15:0] data0 = 0; // stored XADC data, only the uppermost byte          

    //Detecting negative edge of data_ready
    always@(posedge clk)
        _drdy <= {_drdy[0], drdy}; // Updating delayed data ready signal
    always@(posedge clk) begin
        if (_drdy == 2'b10) begin // on negative edge ==> data was ready at the last posedge clk and is no longer ready now
            data0 <= dout[15:0];
        end
    end

    xadc_wiz_0 myxadc (
        .dclk_in        (clk),
        .den_in         (eoc), // drp enable, start a new conversion whenever the last one has ended
        .dwe_in         (0),
        .daddr_in       (daddr), // channel address
        .di_in          (0),
        .do_out         (dout), // data out
        .drdy_out       (drdy), // data ready
        .eoc_out        (eoc), // end of conversion
        .vauxn14        (vn14),
        .vauxp14        (vp14)
    );
    
    // Declaring 8-bit variables :
    reg [7:0] Din;
    always @(posedge clk) begin
        Din = data0[15:8]; 
    end
    
    // Peak detection :
    lf_edge_detect peak_detect (
        .clk(clk),
        .adc_d(Din), //need to check which one are not the shifted bits
        .lf_ed_threshold(threshold),
        .edge_state(edge_state), // 1-bit, no need to declare
        .edge_toggle(edge_toggle) // 1-bit, no need to declare
        );
    
    //Generating the output clock
    reg [3:0] pulse_counter; // counts the number of pulses/peaks encountered needed to average (in this case up to ten)
    reg [31:0] clock_counter=0; // counts the number of clock cycles during the number of pulses considered (in this case ten)
    reg [31:0] pulse_clock_counter=0; // counts the number of clock cycles between two heart_beats
    reg [31:0] average_delta=0; // is the average time between two pulses/peaks (expressed in clock cycles)
    wire [31:0] safe_delta;
    reg [1:0] negative_edge_state; // is the equivalent of _drdy to find the negative edge of the reg edge_state
    
    always@(posedge clk) begin
        negative_edge_state <= {negative_edge_state[0], edge_state}; // Updating delayed data ready signal
        clock_counter = clock_counter +1;
        pulse_clock_counter = pulse_clock_counter +1;
        if (negative_edge_state == 2'b10) begin // on negative edge
            pulse_counter= pulse_counter +1;
            pulse_clock_counter = 0;
            if (pulse_counter ==4'd10) begin
                average_delta = clock_counter/pulse_counter;
                pulse_counter = 0;
                clock_counter = 0;
            end
        end
    end
    
    reg clock_control_reg;
    always@(posedge clk) begin
        if (average_delta>0 && pulse_clock_counter*100>average_delta*delay_percent && pulse_clock_counter*100<percent*average_delta) begin // on negative edge
            clock_control_reg = 1;
        end
        if(100*pulse_clock_counter >= percent*average_delta) begin // & pulse_clock_counter*100 <average_delta*safe_percent) begin  
            clock_control_reg =0; 
        end
    end
    
    assign clock_control= ((user_mode ==2'b00)? 0: ((user_mode==2'b01)? 1 :((user_mode==2'b10)? clock_control_reg:0)));
    
    pmod_da3 myDAC (
        .clk(clk),
        .CSn(jc[0]),
        .LDACn(jc[2]),
        .SCLK(jc[3]),
        .SDAT(jc[1]), // SPI data (one bit)
        .level(data0) // input date [15:0]
    );
endmodule