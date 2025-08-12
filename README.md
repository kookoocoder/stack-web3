## Treasure Hunt Game (Clarity)

A simple Clarity smart contract where the deployer hides a treasure at a secret location (a positive uint). Players try to guess the location. The first correct guess marks the treasure as found.

### Contract

File: `contracts/treasure-hunt-game.clar`

- **Data variables**
  - `treasure-location: (optional uint)` — `none` until the owner sets it
  - `treasure-found: bool` — `false` until someone finds it

- **Public functions**
  - `set-treasure(location uint) -> (response bool (uint))`
    - Only contract owner (the deployer) can call
    - Requires `location > u0`
    - Sets `treasure-location` and resets `treasure-found` to `false`
    - Returns `(ok true)`
  - `guess-location(guess uint) -> (response (string-utf8 100) (uint))`
    - Fails if `treasure-found` is already `true`
    - If `treasure-location` is set and `guess` matches, sets `treasure-found` to `true` and returns success message
    - If `treasure-location` is set and `guess` does not match, returns error `u103`
    - If `treasure-location` has not been set, returns error `u104`

- **Error codes**
  - `u100` — owner only
  - `u101` — invalid location (must be `> u0`)
  - `u102` — treasure already found
  - `u103` — wrong guess
  - `u104` — treasure not set

### Prerequisites

- Node.js 18+
- NPM 9+
- Clarinet (optional for REPL): see Hiro docs

### Install

```bash
npm ci
```

### Run tests

```bash
npm test
```

Watch mode with coverage and costs:

```bash
npm run test:watch
```

### Interact in tests (TypeScript examples)

The project uses `vitest-environment-clarinet`, which provides a `simnet` instance for local testing. Below are minimal examples you can adapt in `tests/`:

```ts
import { describe, it, expect } from "vitest";
import { Cl } from "@stacks/transactions";

const accounts = simnet.getAccounts();
const deployer = accounts.get("deployer")!; // contract owner is the deployer
const player = accounts.get("wallet_1")!;

describe("treasure-hunt-game", () => {
  it("owner sets treasure and player guesses", () => {
    const setTx = simnet.callPublicFn(
      "treasure-hunt-game",
      "set-treasure",
      [Cl.uint(42)],
      deployer
    );
    expect(setTx.result).toBeOk(Cl.bool(true));

    const guessWrong = simnet.callPublicFn(
      "treasure-hunt-game",
      "guess-location",
      [Cl.uint(7)],
      player
    );
    expect(guessWrong.result).toBeErr(Cl.uint(103));

    const guessRight = simnet.callPublicFn(
      "treasure-hunt-game",
      "guess-location",
      [Cl.uint(42)],
      player
    );
    expect(guessRight.result.isOk).toBe(true);
  });
});
```

### Interact via Clarinet console (optional)

If you have Clarinet installed, you can open the console to simulate calls:

```bash
clarinet console
```

Then, inside the console, call the contract (example principals may vary by your console context):

```clj
(contract-call? .treasure-hunt-game set-treasure u42)
(contract-call? .treasure-hunt-game guess-location u7)
(contract-call? .treasure-hunt-game guess-location u42)
```

Note: The contract owner is set to `tx-sender` at deployment, i.e., the deployer account. Only the owner can call `set-treasure`.

### Project scripts

- `npm test` — run unit tests once
- `npm run test:report` — run with coverage and costs
- `npm run test:watch` — watch files and re-run tests

### File overview

- `contracts/treasure-hunt-game.clar` — smart contract
- `tests/treasure-hunt-game.test.ts` — Vitest test suite scaffold
- `Clarinet.toml` — Clarinet project configuration
- `settings/*.toml` — chain settings templates

### License

MIT

<img width="1470" height="920" alt="image" src="https://github.com/user-attachments/assets/cd6cb92b-778c-4db9-9fa7-b148773348a8" />



