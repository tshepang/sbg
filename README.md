# sbg - CLI Boilerplate Generator

[![build status](https://github.com/tshepang/sbg/workflows/CI/badge.svg)](https://github.com/tshepang/sbg/actions)

> The `s` in `sbg` was for `StructOpt`,
> but that is now deprecated,
> but I would like to keep the name for now.

You give this a yaml spec and it generates boilerplate code for you,
which compiles if you give it Cargo.toml with these contents:

```toml
[dependencies]
anyhow = "1"
url = "2"

[dependencies.clap]
version = "3"
features = ["derive"]
```

This is not flexible,
and only supports a tiny subset of what clap supports.

The first time [steved] mentioned the idea to me, I felt
"meh!", but once you get to nested subcommands, it becomes unwieldy
the code you gotta write to handle that. He even went as far as
writing the code (not public), but unsatisfied by the notation,
I wrote this implementation.
My actual inspiration though is I wanted something that'd also
generate [warp] boilerplate, together with the [reqwest] code which
generates it (which also exists, but is also not public).

## Would be nice to fix

- check "type" actually has valid Rust types
- check "name" does not have spaces
- disallow having both "args" and "nested" (results in build failure),
  or support it (which would be useful for subcommands that share some
  options)
- when "type" is not specified, assume bool
- ensure no args have same name (results in build failure)
- support > 1 positional args

## Installation

Assuming you have the [Rust toolchain installed][install]:

    cargo install sbg

NOTE: minimum required rustc is v1.58, due to serde-yaml requiring it.

## License

Licensed under either of

 * Apache License, Version 2.0
   ([LICENSE-APACHE](LICENSE-APACHE) or http://www.apache.org/licenses/LICENSE-2.0)
 * MIT license
   ([LICENSE-MIT](LICENSE-MIT) or http://opensource.org/licenses/MIT)

at your option.

## Contribution

Unless you explicitly state otherwise, any contribution intentionally submitted
for inclusion in the work by you, as defined in the Apache-2.0 license, shall be
dual licensed as above, without any additional terms or conditions.


[steved]: https://github.com/stevedonovan
[reqwest]: https://crates.io/crates/reqwest
[warp]: https://crates.io/crates/warp
[install]: https://rust-lang.org/install
