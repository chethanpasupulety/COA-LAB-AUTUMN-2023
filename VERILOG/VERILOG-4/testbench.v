// #GROUP NO:14
// #ASSIGNMENT 4
// #Question No 1
// #NAMES: Pasupulety Chethan Krishna Venkat(21CS30036)
// #      :Vikhyath Gummadi (21CS10028)
// #Autumn 2023


module booth_tb;

  reg clk, rst, start;
  reg signed [7:0] X, Y;
  wire signed [15:0] Z; 
  wire valid;

  always #5 clk = ~clk;

  BoothMul inst (clk, rst, start, X, Y, valid, Z);

  initial begin
    clk = 1'b1;
    rst = 1'b0;
    start = 1'b0;

    // Test case 1: X = 62, Y = 37
    X = 62;
    Y = 37;
    #10 rst = 1'b1;
    #10 start = 1'b1;
    #10 start = 1'b0;

    @(posedge valid);

    // Print the result when valid is 1
    if (X[7]) begin
      $display("Test case: product of %d and %d :  %d", X, Y, Z);
    end else begin
      $display("Test case: product of %d and %d :  %d", X, Y, Z);
    end

    // Test case 2: X = 34, Y = -9
    X = 34;
    Y = -9;
    #10 start = 1'b1;
    #10 start = 1'b0;

    @(posedge valid);

    if (X[7]) begin
      $display("Test case: product of %d and %d : %d", X, Y, Z);
    end else begin
      $display("Test case: product of %d and %d :  %d", X, Y, Z);
    end

    // Test case 3: X = -18, Y = -10
    X = -18;
    Y = -10;
    #10 start = 1'b1;
    #10 start = 1'b0;

    @(posedge valid);

    if (X[7]) begin
      $display("Test case: product of %d and %d : %d", X, Y, Z);
    end else begin
      $display("Test case: product of %d and %d : %d", X, Y, Z);
    end

    // Test case 4: X = 0, Y = 12
    X = 0;
    Y = 12;
    #10 start = 1'b1;
    #10 start = 1'b0;

    @(posedge valid);

    if (X[7]) begin
      $display("Test case: product of %d and %d : %d", X, Y, Z);
    end else begin
      $display("Test case: product of %d and %d : %d", X, Y, Z);
    end

    $finish;
  end
endmodule
