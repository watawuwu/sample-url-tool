use url::percent_encoding::percent_decode;
use failure::Error;
use structopt::StructOpt;
use std::io::{self, Read};
use log::*;
use pretty_env_logger;

pub type Result<T> = std::result::Result<T, Error>;

#[derive(StructOpt, Debug)]
struct Opt {
    #[structopt(name = "INPUT")]
    input: Option<String>,
}

fn read_from_stdin() -> Result<String> {
    let stdio = io::stdin();
    let mut handle = stdio.lock();
    let mut buf = String::new();
    handle.read_to_string(&mut buf)?;
    Ok(buf)
}

fn main() -> Result<()> {
    pretty_env_logger::init();
    let opt = Opt::from_args();
    debug!("opt: {:?}", opt);

    let input = match opt.input  {
        Some(i) => i,
        None => read_from_stdin()?
    };
    if input.is_empty() {
        Opt::clap().get_matches().usage();
    }

    Ok(println!("{}", decode(&input)?))
}

fn decode(input: &str) -> Result<String> {
    let decoded = percent_decode(input.as_bytes()).decode_utf8()?;
    Ok(decoded.to_string())
}

#[cfg(test)]
mod tests {

    use crate::decode;

    #[test]
    fn decode_space_ok() {
        let expected = "foo bar";
        let input = "foo%20bar";
        let actual = decode(input).unwrap();
        assert_eq!(expected, actual);
    }

    #[test]
    fn decode_ascii_ok() {
        let expected = r##" !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"##;
        let input = r##"%20%21%22%23%24%25%26%27%28%29%2A%2B%2C%2D%2E%2F0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~"##;
        let actual = decode(input).unwrap();
        assert_eq!(expected, actual);
    }

    #[test]
    fn decode_invalid_utf8_ng() {
        let input = "%93%FA%96%7B%8C%EA%0D%0A";
        let actual = decode(input);
        assert!(actual.is_err())
    }
}
