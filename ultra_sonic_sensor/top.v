module top(
    input  clk_16,
    output PIN_8, // sensor_trigger
    input  PIN_9, // sensor_echo
    output USBPU  // USB pullup
);
    assign USBPU = 0;

    wire sensor_trigger_out;
    wire sensor_echo_in;
    
    assign sensor_echo_in =PIN_9;
    assign PIN_8 =sensor_trigger_out;

    reg reset;
    reg en = 1;
    wire [31:0] value;
    wire value_ok;
    initial reset =1;


    always @(posedge clk_16) begin
        reset <= 0;
    end

    sr04 sens(
        .clk(clk_16),
        .reset(reset),
        .en(en),
        .sensor_trigger_out(sensor_trigger_out),
        .sensor_echo_in(sensor_echo_in),
        .value(value),
        .value_ok(value_ok)
    );


endmodule