// ------------------------------------------------------------
// Transaction Class
// ------------------------------------------------------------
// A transaction represents ONE bus operation
// (either a read or a write)
//
// This is NOT hardware
// This is a verification-side abstraction
// ------------------------------------------------------------
class transaction;

    // --------------------------------------------------------
    // Address for the transaction
    // --------------------------------------------------------
    // rand keyword allows randomization (optional usage)
    rand bit [7:0] addr;

    // --------------------------------------------------------
    // Data associated with the transaction
    // --------------------------------------------------------
    // For write → this is wdata
    // For read  → this is ignored / can store read result
    rand bit [31:0] data;

    // --------------------------------------------------------
    // Transaction type
    // --------------------------------------------------------
    // write = 1 → write transaction
    // write = 0 → read transaction
    rand bit write;

    // --------------------------------------------------------
    // Constructor
    // --------------------------------------------------------
    // Automatically called when object is created using new()
    // --------------------------------------------------------
    function new();
        // No initialization required here for now
        // Keeping it simple and clean
    endfunction

endclass
