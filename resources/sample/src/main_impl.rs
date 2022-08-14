use std::path::PathBuf;

use anyhow::Result;
use url::Url;

pub(crate) fn simple() -> Result<()> {
    unimplemented!();
}
pub(crate) fn not_so_simple(_some_arg: String, _some_other_arg: PathBuf) -> Result<()> {
    unimplemented!();
}
pub(crate) fn complex_nested_subcommand(_some_arg: String, _some_other_arg: Url) -> Result<()> {
    unimplemented!();
}

pub(crate) fn complex_nested_subcommand_without_args() -> Result<()> {
    unimplemented!();
}
