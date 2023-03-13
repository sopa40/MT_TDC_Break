module LUT
#(
    parameter INIT_VALUE = 64'hAAAAAAAAAAAAAAAA
)(
    input logic i0,
    input logic i1,
    input logic i2,
    input logic i3,
    input logic i4,
    input logic i5,
    
    output logic o
);

    LUT6_2 lut (
        .I0(i0),
        .I1(i1),
        .I2(i2),
        .I3(i3),
        .I4(i4),
        .I5(i5),
        .O6(o)
    );
    defparam lut.INIT = INIT_VALUE;
    
endmodule