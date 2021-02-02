# TBD

## Development

Install dependencies

```
yarn
```

### Running a local eth node

The following command will run a Ganache instance (with the port and network id used by default by Truffle)

```
yarn ganache -p 7545 -i 5777
```

### Deploying contracts

Runs the migrations that can be found in the `migrations` directory.

```
yarn truffle migrate
```

### Run linting

Runs solhint

```
yarn lint
```

### Run formatter

Runs prettier

```
yarn format
```