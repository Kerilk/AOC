use std::collections::HashMap;
use std::fs;

fn main() {
    let (a, b): (Vec<_>, Vec<_>) = fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|y| y.parse::<i32>().unwrap())
                .collect()
        })
        .map(|v: Vec<_>| (v[0], v[1]))
        .unzip();

    let mut b_map = HashMap::new();
    for v in b {
        *b_map.entry(v).or_insert(0) += 1;
    }
    let sum: i32 = a
        .into_iter()
        .map(|v| v * *b_map.entry(v).or_insert(0))
        .sum();
    println!("{}", sum);
}
