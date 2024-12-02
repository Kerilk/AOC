use std::fs;
use std::collections::HashSet;

fn main() {
    let data = fs::read_to_string("input").unwrap();

    let res: i32 = data
        .lines()
        .map( |l| l.chars().collect::<Vec<char>>() )
        .collect::<Vec<Vec<char>>>()
        .chunks(3)
        .map( |bags|
            **bags.iter()
                  .map( |b| HashSet::<&char>::from_iter(b) )
                  .reduce( |acc, x| &acc & &x )
                  .unwrap().iter().next().unwrap() as i32 )
        .map( |v| if v < 96 { v - 38 } else { v - 96 } )
        .sum();
    println!("{}", res);
}
