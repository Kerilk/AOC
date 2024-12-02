use std::fs;
use std::iter::zip;

fn main() {
    let (mut a, mut b): (Vec<_>, Vec<_>) = fs::read_to_string("input")
        .unwrap()
        .lines()
        .map(|line| {
            line.split_whitespace()
                .map(|y| y.parse::<i32>().unwrap())
                .collect()
        })
        .map(|v: Vec<_>| (v[0], v[1]))
        .unzip();

    a.sort();
    b.sort();
    let sum: i32 = zip(a, b).map(|(x, y)| (y - x).abs()).sum();
    println!("{}", sum);
}
