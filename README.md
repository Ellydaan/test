# T-POO-700-PAR_7

## Time Manager

_Introduce the context_

## How to deploy ?

1. Install `just ` on your system. You can install it via package managers or manually:

- For macOS: `brew install just`
- For Linux: `sudo apt install just` 
- For Windows: `choco install just` 

Or check your [package manager](https://github.com/casey/just?tab=readme-ov-file#installation)

2. Create the `.env` file associed with the environment you are deploying to.

- The `.env.example` is here to show you the variables you have to define
- The file will be named either `.env.dev` or `.env.prd`

You can now use the recipes defined inside the `Justfile` to deploy the application.

**Recipes**:
- `just compose-up-dev` 
- `just compose-down-dev`
- `just compose-up-prd` 
- `just compose-down-prd`
