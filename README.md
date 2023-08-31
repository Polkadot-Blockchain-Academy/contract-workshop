# Contract Writing Workshop

In this activity, each student will be assigned to write one contract in one particular contracting language by the instructor.

💡 **The class, as a whole, will write a few copies of each contract in each language.**

## The Contracts

The contracts we've chosen are intended to give a reasonable sampling of typical problems encountered in smart contract design.
They are also chosen to show off the strengths and weaknesses between the various programming languages in which they are implemented.

Sometimes an idea fits really nicely with a particular language.
Other times it is hard to express an idea in a particular language.
That may be because the language is too primitive or because the idea is bad and the language is helping you avoid a mistake.
Not all contracts will be available to implement in all languages.

- Socialism DAO - An on-chain organization in which the members agree to live as socialists and split their resources each according to their need
- Roulette - A casino-style game of chance
- TicTacToe - An on-chain version of the classic multi-player children's game
- Resource Market - A way for private individuals to trade among themselves in the three resources that give them life
- Simple Dex - Basically a Balancer v1 pool with all weights equal

## The Languages

We've chosen three languages that are most popular overall and in the Polkadot/Substrate ecosystem in particular.
There is a folder for each language, and you should look at its dedicated readme for further language-specific instructions.

- [ink!](https://use.ink/) _([starter contracts](wasm/))_
- [Solidity](https://soliditylang.org/) _([starter contracts](evm/src/solidity/))_
- [Vyper](https://docs.vyperlang.org/en/stable/) _([starter contracts](evm/src/vyper/))_

## Working Together

You are encouraged to work together with your classmates to complete this task and learn as much about smart contracting as you can along the way.
There are a few different sorts of people you may be naturally inclined to work with.

Some students will have the **same contract** as you, but a different language to implement it in.
You may find it useful to talk about the design of the contract storage or transactions with these folks.

Some students will have the **same language** as you, but a different contract to implement
You may find it useful to talk about syntax, semantics, and language-specific tips and tricks with these folks.

One or two students may have both the same language and contract as you.
**You may work with these people as well, but please do not blindly share code.** This is an **ungraded** assignment, so try to learn as much as possible.

## Completing the Exercise

At minimum, ensure that your contract has a robust test suite, that you can deploy your contract to a local test environment, and that it functions as expected within the test environment.

Once you are satisfied that your contract works, if there is time remaining, you may explore more freely.

- Some contracts contain `// Enhancement` comments, look for these for some ideas as to other features you could implement
- Write the contract in a different language
- Write another contract in your language
- Design and write your own contract, consider ones that may make money from your friends (as preparation for tomorrow's activity)

## License

Licensed under the terms of the [GPL-3](./LICENSE.md) or later.

