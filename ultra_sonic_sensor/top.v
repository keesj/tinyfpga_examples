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
    wire [31:0] sensor_value;
    wire sensor_value_ok;
    initial reset =1;


    reg [31:0] value;

    always @(posedge clk_16) begin
        if (reset == 1) begin
            reset <= 0;
        end
        else begin
            if (sensor_value_ok == 1)
            begin
                value <= sensor_value;
            end
        end 
    end

    sr04 sens(
        .clk(clk_16),
        .reset(reset),
        .en(en),
        .sensor_trigger_out(sensor_trigger_out),
        .sensor_echo_in(sensor_echo_in),
        .value(sensor_value),
        .value_ok(sensor_value_ok)
    );
endmodule
