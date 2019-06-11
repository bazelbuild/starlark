# This file is used for Bazel CI.

# install rust
curl https://sh.rustup.rs -sSf | sh -s -- -y

# replace cargo in workspace with the absolute path $HOME/.cargo/bin/cargo
sed -i -e 's/cargo/\~\/.cargo\/bin\/cargo/g' WORKSPACE
