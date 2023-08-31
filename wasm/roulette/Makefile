watch:
	cargo watch -s 'cargo contract check' -c

release:
	cargo contract build --release

deps:
	cargo install contracts-node --git https://github.com/paritytech/substrate-contracts-node.git --rev fd310221f772e8571fd8fc6df973e355e1d6903c --force --locked

test:
	cargo test --features e2e-tests
