`ifndef TRANSACTION_SV
`define TRANSACTION_SV
//
// // Transaction class definition
// // Represents a single bus transaction (read or write)
class transaction;
//
//     // Address field (8-bit)
//     // Used to select control, counter, GPIO, etc.
     rand bit [7:0]  addr;
//
//     // Data field (32-bit)
//     // Carries write data or expected read data
     rand bit [31:0] data;
//
//     // Write control flag
//     // write = 1 → write transaction
//     // write = 0 → read transaction
     bit             write;
//
 endclass
//
 `endif  // TRANSACTION_SV
