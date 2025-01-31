module exception_handler(
    input[31:0] a,b,
    input[4:0] flag_a,flag_b,
    output reg[31:0] out
);

    always@(*)
        begin
            casex(a)
                flag_a[0]:  begin
                                casex(b)
                                    flag_b[0]: out=32'h00000000;
                                    flag_b[1]: out=32'h80000000;
                                    flag_b[2]: out=32'h7F800000;
                                    flag_b[3]: out=32'hFF800000;
                                    flag_b[4]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    default: out=b;
                                endcase
                            end

                flag_a[1]:  begin
                                casex(b)
                                    flag_b[0]: out=32'h00000000;
                                    flag_b[1]: out=32'h80000000;
                                    flag_b[2]: out=32'h7F800000;
                                    flag_b[3]: out=32'hFF800000;
                                    flag_b[4]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    default: out=b;
                                endcase
                            end

                flag_a[2]:  begin
                                casex(b)
                                    flag_b[0]: out=32'h7F800000;
                                    flag_b[1]: out=32'h7F800000;
                                    flag_b[2]: out=32'h7F800000;
                                    flag_b[3]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    flag_b[4]: out=32'h7F800000;
                                    default: out=32'h7F800000;
                                endcase
                            end

                flag_a[3]:  begin
                                casex(b)
                                    flag_b[0]: out=32'hFF800000;
                                    flag_b[1]: out=32'hFF800000;
                                    flag_b[2]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    flag_b[3]: out=32'hFF800000;
                                    flag_b[4]: out=32'hFF800000;
                                    default: out=32'hFF800000;
                                endcase
                            end

                flag_a[4]:  begin
                                casex(b)
                                    flag_b[0]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    flag_b[1]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    flag_b[2]: out=32'h7F800000;
                                    flag_b[3]: out=32'hFF800000;
                                    flag_b[4]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    default: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                endcase
                            end

                default:    begin
                                casex(b)
                                    flag_b[0]: out=a;
                                    flag_b[1]: out=a;
                                    flag_b[2]: out=32'h7F800000;
                                    flag_b[3]: out=32'hFF800000;
                                    flag_b[4]: out=32'bx11111111xxxxxxxxxxxxxxxxxxxxxxx;
                                    default: out=32'hxxxxxxxx;
                                endcase
                            end
            endcase
        end
endmodule