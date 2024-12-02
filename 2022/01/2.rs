use std::fs;
use itertools::Itertools;

fn main() {
    let number_str = fs::read_to_string("input").unwrap();

    let sum = number_str
        .split("\n\n")
        .map(|g| g.lines().map(|x| x.parse::<u64>().unwrap()).sum::<u64>())
        .sorted()
        .rev()
        .take(3)
        .sum::<u64>();
    println!("{}", sum);
}
