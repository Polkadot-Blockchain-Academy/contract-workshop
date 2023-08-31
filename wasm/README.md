# Web Assembly Contracts

This folder is dedicated to smart contracts that run on Web Assembly.

All of the code in this subdirectory is written in ink! which is a DSL in Rust.
As such, we use standard Rust tools such as `cargo` and `cargo contract`

## One ink! Contract per Crate

There is one directory for each of the contracts.
When you pick the crate you want to work on, `cd` into it.
I you use an IDE, you probably want to open it from the project subdirectory as well.

## Testing

To test your project from inside of its crate, simply run `cargo test`.

## Learning Resources

If you are doing this workshop as part of the PBA, your instructors have already given you a short course in programming Wasm contracts.
Even so, you may find these additional learning resources useful:

- https://use.ink/
