# This file is used for Bazel CI.

# install rust
apt-get update && apt-get install curl -y && curl https://sh.rustup.rs -sSf | sh -s -- -y

# replace cargo in workspace with the absolute path $HOME/.cargo/bin/cargo
sed -i -e 's/cargo/\$HOME\/.cargo\/bin\/cargo/g' WORKSPACE
