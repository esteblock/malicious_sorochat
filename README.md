# SOROCHAT
SOROCHAT is a nice little messaging dapp built on top of Soroban Testnet for demonstration purpose.


## Malicious Version.
This is for educational purpose only. Just to create awareness in the Stellar Community on the usage of require_auth.

1.- Clone
```
git clone https://github.com/benjaminsalon/malicious_sorochat.git
cd sorochat
git checkout xlm-version
```

2.- Start Quickstart and Preview Containers
```
bash quickstart.sh standalone
```

3.- Open Preview Container in another terminal
```
bash run.sh
```

4.- Compile, deploy and execute the attack in Standalone
```
cd contracts
./deploy_attack_on_standalone_docker.sh chat_malicious
```















## About Sorochat:
![Preview](image.png)


[LIVE VERSION HERE 🕺](https://sorochat.vercel.app/)

Built using the [@create-soroban-dapp](https://github.com/paltalabs/create-soroban-dapp/) boilerplate and script.

You can find a written [tutorial](https://dev.to/benjaminsalon/sorochat-how-to-build-a-simple-chat-dapp-using-create-soroban-dapp-295l) explaining how to create the dapp on my dev.to 🚀
## Build and run

To build the dapp first clone the repo

```bash
git clone https://github.com/benjaminsalon/sorochat.git
```

Then install dependencies using pnpm (or the equivalent commands with your favorite package manager)
```bash
pnpm install
```

Then run

```bash 
pnpm run build
```

And finally run this to start the dapp on local server
```bash
pnpm run start
```