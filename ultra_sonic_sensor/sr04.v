/*
https://cdn.sparkfun.com/assets/b/3/0/b/a/DGCH-RED_datasheet.pdf
*/
module sr04(
    input clk,
    input reset,
    input en,// enable
    output reg sensor_trigger_out,
    input sensor_echo_in,    
    output reg [31:0] value,
    output reg value_ok
);

    parameter frequency = 16000000; // 16 Mhz
    parameter trigger_delay = frequency * 15 /1000000; /* 15us */
    parameter max_delay = frequency; /* 1 second */
    
    reg [31:0] trigger_counter;
    reg [31:0] delay_counter;

    localparam [2:0]
        STATE_IDLE = 0,
        STATE_RIZE_TRIGGER = 1,
        STATE_LOWER_TRIGGER = 2,
        STATUS_WAIT_FOR_ECHO_UP = 3,
        STATUS_WAIT_FOR_ECHO_DOWN = 4;
    
    reg [2:0] state_reg;


    initial state_reg <= STATE_IDLE;

    always @(posedge clk) begin
        if (reset) begin
            state_reg <= STATE_IDLE;
            trigger_counter <=0;
            delay_counter <= 0;
            value <=0;
            value_ok<=0;
            sensor_trigger_out<=0;
        end
        else begin            
            case(state_reg)
                STATE_IDLE:
                begin
                    value_ok <= 0;
                    value <=  0;
                    if (en == 1'b1 && sensor_echo_in== 1'b0)
                    begin
                        state_reg <= STATE_RIZE_TRIGGER;
                    end
                end
                STATE_RIZE_TRIGGER:
                begin
                    state_reg <= STATE_LOWER_TRIGGER;
                    trigger_counter <= 0;
                    sensor_trigger_out <= 1;
                end
                STATE_LOWER_TRIGGER:
                begin
                    trigger_counter <= trigger_counter +1;
                    if (trigger_counter > trigger_delay +1)
                    begin
                        state_reg <= STATUS_WAIT_FOR_ECHO_UP;
                        sensor_trigger_out <= 0;
                        delay_counter <= 0;
                    end
                end            
                STATUS_WAIT_FOR_ECHO_UP:
                begin
                    delay_counter <= delay_counter +1;
                    if (sensor_echo_in == 1)
                    begin
                        state_reg <= STATUS_WAIT_FOR_ECHO_DOWN;
                        delay_counter <= 0;
                    end

                    if (delay_counter > max_delay +1)
                    begin
                        state_reg <= STATE_IDLE;
                    end
                end
                STATUS_WAIT_FOR_ECHO_DOWN:
                begin
                    delay_counter <= delay_counter +1;
                    if (sensor_echo_in == 0)
                    begin
                        value <= delay_counter;
                        value_ok <= 1;
                        state_reg <= STATE_IDLE;
                    end

                    if (delay_counter > max_delay +1)
                    begin
                        state_reg <= STATE_IDLE;
                    end
                end
                default:
                begin
                end
            endcase
        end
    end
endmodule
