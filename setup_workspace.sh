# This file is used for Bazel CI.

# TODO(#305): Disabled until we fix our dependency on the Go and Rust Starlark
# interpreters.
#
# # install rust
# curl https://sh.rustup.rs -sSf | sh -s -- -y
#
# # replace cargo in workspace with the absolute path $HOME/.cargo/bin/cargo
# sed -i -e 's/cargo/\~\/.cargo\/bin\/cargo/g' WORKSPACE
