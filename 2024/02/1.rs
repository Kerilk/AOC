use std::collections::HashSet;
use std::fs;

fn valid(levels: &Vec<i32>) -> bool {
    let diffs: Vec<i32> = levels.windows(2).map(|w| w[1] - w[0]).collect();
    diffs
        .iter()
        .map(|v| v.signum())
        .collect::<HashSet<_>>()
        .len()
        == 1
        && diffs.iter().all(|v| (1..4).contains(&v.abs()))
}

fn main() {
    let reports: Vec<Vec<_>> = fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|y| y.parse::<i32>().unwrap())
                .collect()
        })
        .collect();
    let count = reports.iter().filter(|levels| valid(levels)).count();
    println!("{:?}", count);
}
