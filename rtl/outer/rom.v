`timescale 1ns / 1ps

`include "../cpu/cpu_define.v"

/* ROM */
module  rom
(
    input   wire                        sys_clk  ,
    input   wire                        sys_rst_n,
    
    input   wire                        wr_en_i  , // write enable
    input   wire    [`INST_ADDR_BUS]    wr_addr_i, // write address
    input   wire    [`INST_DATA_BUS]    wr_data_i, // write data
    
    input   wire    [`INST_ADDR_BUS]    rd_addr_i, // read address
    output   wire   [`INST_DATA_BUS]    rd_data_o, // read data
    
    input   wire    [`INST_ADDR_BUS]    pc_addr_i, // instruction read address
    output  wire    [`INST_DATA_BUS]    instr_o    // instruction
);

// 打一拍
reg     [`INST_ADDR_BUS]    rd_addr_reg;
reg     [`INST_ADDR_BUS]    pc_addr_reg;

/* 燒錄用 */
// 读取需要固化在rom里面的程序，方便仿真
//initial begin
//    $readmemh("../../serial_utils/binary/led_flow.inst", _rom);
//end

//initial begin
//    $readmemh("../../rt-thread/rtthread.inst", _rom);
//end

/* 
    ROM(32x4096):
        數據位寬: 32bits
        索引大小: 4096
*/
reg     [`INST_DATA_BUS] _rom[0: `ROM_NUM - 1];


always@(posedge sys_clk)
    begin
        if(wr_en_i == 1'b1)
        begin
            _rom[wr_addr_i[31:2]] <= wr_data_i;
        end
        rd_addr_reg <= rd_addr_i;
        pc_addr_reg <= pc_addr_i'
    end
    
assign rd_data_o = _rom[rd_addr_reg[31:2]];
assign instr_o    = _rom[pc_addr_reg[31:2]];



endmodule