## Building

Run `nix-shell`, then `code .` to launch vscode with the nix environment.

```bash
mkdir -p build && cd build

# Configure the build
cmake ../xournalpp -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Debug

# Install to ./build/install
cmake --build . --target install
```

clean build
```bash
cmake --build . --target clean 
```

## Running with debugger
1. ctrl+shift+d
2. F5
(or navigate manually)
