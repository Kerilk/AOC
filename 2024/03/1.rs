use regex::Regex;
use std::fs;

fn process(data: &str) -> u32 {
    let re = Regex::new(r"mul\((\d+),(\d+)\)").unwrap();
    re.captures_iter(&data)
        .map(|c| c.extract::<2>())
        .map(|(_, res)| res.iter().map(|v| v.parse::<u32>().unwrap()).collect())
        .map(|res: Vec<u32>| res[0] * res[1])
        .sum()
}

fn main() {
    let data = fs::read_to_string("input").unwrap();
    let sum = process(&data);
    println!("{:?}", sum);
}
