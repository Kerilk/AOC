use std::fs;
use std::collections::HashSet;
use itertools::Itertools;

fn main() {
    let data = fs::read_to_string("input").unwrap();

    let res: i32 = data
        .lines()
        .map( |l| **l.chars()
                     .collect::<Vec<char>>()
                     .chunks(l.len()/2)
                     .map( |b| HashSet::<&char>::from_iter(b) )
                     .reduce( |acc, x| &acc & &x )
                     .unwrap().iter().next().unwrap() as i32 )
        .map( |v| if v < 96 { v - 38 } else { v - 96 } )
        .sum();
    println!("{}", res);
}
