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
    let re_disable = Regex::new(r"(?sm)don't\(\).*?do\(\)").unwrap();
    let disable_end = Regex::new(r"(?sm)don't\(\).*").unwrap();
    let data = fs::read_to_string("input").unwrap();
    let data = re_disable.replace_all(&data, ";");
    let data = disable_end.replace(&data, ";");
    let sum: u32 = process(&data);
    println!("{:?}", sum);
}
