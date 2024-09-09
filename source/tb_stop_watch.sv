/*
    Module Name: tb_stop_watch
    Description: Test bench for stop_watch module
*/

`timescale 1ms / 100us

module tb_stop_watch ();

    // Enum for mode types
    typedef enum logic [2:0] {
        IDLE = 3'b100,
        CLEAR = 3'b010, 
        RUNNING = 3'b001
    } MODE_TYPES; 

    // Testbench parameters
    localparam CLK_PERIOD = 10; // 100 Hz clk
    logic tb_checking_outputs; 
    integer tb_test_num;
    string tb_test_case;

    // DUT ports
    logic tb_clk, tb_nRst_i;
    logic tb_button_i;
    logic [4:0] tb_time_o;
    logic [2:0] tb_state;

    // Reset DUT Task___________________________________________________________________________________________________________________________
    task reset_dut;
        @(negedge tb_clk);
        tb_nRst_i = 1'b0; 
        @(negedge tb_clk);
        @(negedge tb_clk);
        tb_nRst_i = 1'b1;
        @(posedge tb_clk);
    endtask
    
    // Task that presses the button once___________________________________________________________________________________________________________________________
    task single_button_press;
    begin
        @(negedge tb_clk);
        tb_button_i = 1'b1; 
        @(negedge tb_clk);
        tb_button_i = 1'b0; 
        @(posedge tb_clk);  // Task ends in rising edge of clock: remember this!
    end
    endtask

    // Task to check mode output___________________________________________________________________________________________________________________________
    task check_state;
    input logic [2:0] expected_mode; 
    input string string_mode; 
    begin
        @(negedge tb_clk); 
        tb_checking_outputs = 1'b1; 
        if(tb_state == expected_mode)
            $info("Correct Mode: %s.", string_mode);
        else
            $error("Incorrect mode. Expected: %s. Actual: %s.", string_mode, tb_state); 
        
        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask

    // Task to check time output___________________________________________________________________________________________________________________________
    task check_time_o;
    input logic[4:0] exp_time_o; 
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_time_o == exp_time_o)
            $info("Correct time_o: %0d.", exp_time_o);
        else
            $error("Incorrect mode. Expected: %0d. Actual: %0d.", exp_time_o, tb_time_o); 
        
        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask

    // Task to check the CLEAR output___________________________________________________________________________________________________________________________
    task check_clear;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_state == CLEAR)
            $info("Mode is CLEAR as expected.");
        else
            $error("Incorrect mode. Expected: CLEAR. Actual: %s.", tb_state);
        
        // Check if time output is 0
        if(tb_time_o == '0)
            $info("Time output is 0 as expected.");
        else
            $error("Incorrect time output. Expected: 0. Actual: %0d.", tb_time_o);

        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask

    // Task to check the RUNNING output___________________________________________________________________________________________________________________________
    task check_running;
    input logic [4:0]i;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_state == RUNNING)
            $info("Mode is RUNNING as expected.");
        else
            $error("Incorrect mode. Expected: RUNNING. Actual: %s.", tb_state);

        // Check if time output increments every second
        
        for (i = 0; i < 5; i++) begin
            @(negedge tb_clk);
            if (tb_time_o !== i)
                $error("Time output not incrementing correctly. Expected: %0d. Actual: %0d.", i, tb_time_o);
            #(CLK_PERIOD * 100); // Wait for 1 second
        end

        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask

    // Task to check the IDLE output___________________________________________________________________________________________________________________________
    task check_idle;
    begin
        @(negedge tb_clk);
        tb_checking_outputs = 1'b1;
        if(tb_state == IDLE)
            $info("Mode is IDLE as expected.");
        else
            $error("Incorrect mode. Expected: IDLE. Actual: %s.", tb_state);

        // Check if time output is 0
        if(tb_time_o == '0)
            $info("Time output is 0 as expected.");
        else
            $error("Incorrect time output. Expected: 0. Actual: %0d.", tb_time_o);

        #(1);
        tb_checking_outputs = 1'b0;  
    end
    endtask


    // Clock generation block___________________________________________________________________________________________________________________________
    always begin
        tb_clk = 1'b0; 
        #(CLK_PERIOD / 2.0);
        tb_clk = 1'b1; 
        #(CLK_PERIOD / 2.0); 
    end

    // DUT Portmap___________________________________________________________________________________________________________________________
    stop_watch DUT(.clk(tb_clk),
                .nRst_i(tb_nRst_i),
                .button_i(tb_button_i),
                .state(tb_state),
                .time_o(tb_time_o)); 

    // Main Test Bench Process___________________________________________________________________________________________________________________________
    initial begin
        // Signal dump
        $dumpfile("dump.vcd");
        $dumpvars; 

        // Initialize test bench signals
        tb_button_i = 1'b0; 
        tb_nRst_i = 1'b1;
        tb_checking_outputs = 1'b0;
        tb_test_num = -1;
        tb_test_case = "Initializing";

        // Wait some time before starting first test case
        #(0.1);

        // ************************************************************************************************************************************************
        // Test Case 0: Power-on-Reset of the DUT
        // ************************************************************************************************************************************************
        tb_test_num += 1;
        tb_test_case = "Test Case 0: Power-on-Reset of the DUT";
        $display("\n\n%s", tb_test_case);

        tb_button_i = 1'b1;  // press button
        tb_nRst_i = 1'b0;  // activate reset

        // Wait for a bit before checking for correct functionality
        #(2);
        check_state(IDLE, "IDLE");
        check_time_o('0);

        // Check that the reset value is maintained during a clock cycle
        @(negedge tb_clk);
        check_state(IDLE, "IDLE");
        check_time_o('0);

        // Release the reset away from a clock edge
        @(negedge tb_clk);
        tb_nRst_i  = 1'b1;   // Deactivate the chip reset
        // Check that internal state was correctly keep after reset release
        check_state(IDLE, "IDLE");
        check_time_o('0);

        tb_button_i = 1'b0;  // release button

        // ************************************************************************************************************************************************
        // Test Case 1: Iterating through the different modes
        // ************************************************************************************************************************************************
        tb_test_num += 1;
        reset_dut;
        tb_test_case = "Test Case 1: Iterating through the different modes";
        $display("\n\n%s", tb_test_case);

        // Initially, state is IDLE
        check_state(IDLE, "IDLE"); 

        // Press button (IDLE->CLEAR)
        single_button_press(); 
        #(CLK_PERIOD * 5); // allow for sync + edge det + FSM delay 
        check_state(CLEAR, "CLEAR"); 

        // Press button (CLEAR->RUNNING)
        single_button_press(); 
        #(CLK_PERIOD * 5);
        check_state(RUNNING, "RUNNING"); 

        // Press button (back to IDLE)
        single_button_press(); 
        #(CLK_PERIOD * 5);
        check_state(IDLE, "IDLE"); 

        // ************************************************************************************************************************************************
        // Test Case 2: Only Changes Modes during Rising edges
        // ************************************************************************************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 2: Stop watch changes mode once for each button press";
        $display("\n\n%s", tb_test_case);

        @(negedge tb_clk); 
        tb_button_i = 1'b1;  // press button

        #(CLK_PERIOD * 20);  // keep button pressed a long time
        check_state(CLEAR, "CLEAR"); 
        @(negedge tb_clk); 
        tb_button_i = 1'b0;  // release button

        // Keep adding to this test case!!
        // ************************************************************************************************************************************************
        // Test Case 3: Check that when mode is RUNNING time_o increments every second
        // ************************************************************************************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 3: Check running case";
        $display("\n\n%s", tb_test_case);
        // IDLE >> CLEAR
        single_button_press(); 
        #(CLK_PERIOD * 5);

        // CLEAR >> RUNNING
        single_button_press(); 
        #(CLK_PERIOD * 5);
        check_running(tb_time_o);
        #(CLK_PERIOD * 3100);

        // ************************************************************************************************************************************************
        // Test Case 4: verify time_o stops after stop watch return to IDLE
        // ************************************************************************************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 4:  Check IDLE case";
        $display("\n\n%s", tb_test_case);

        // IDLE
        #(CLK_PERIOD * 5);
        check_idle(); 

        // ************************************************************************************************************************************************
        // Test Case 5: verify count clears when mode transitions to CLEAR
        // ************************************************************************************************************************************************
        tb_test_num += 1; 
        reset_dut;
        tb_test_case = "Test Case 5: Check CLEAR case";
        $display("\n\n%s", tb_test_case);
        // IDLE >> CLEAR
        single_button_press(); 
        #(CLK_PERIOD * 5);
 
        check_clear(); 




        $finish; 
    end

endmodule 