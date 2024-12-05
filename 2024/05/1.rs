use std::collections::HashMap;
use std::collections::HashSet;
use std::fs;

fn main() {
    let input = fs::read_to_string("input").unwrap();
    let (rules, updates) = input.split_once("\n\n").unwrap();
    let ancestors: HashMap<i32, HashSet<i32>> = rules
        .lines()
        .map(|line| line.split("|").map(|y| y.parse().unwrap()).collect())
        .fold(HashMap::new(), |mut map, t: Vec<_>| {
            map.entry(t[1]).or_insert(HashSet::new()).insert(t[0]);
            map
        });
    let updates: Vec<Vec<i32>> = updates
        .lines()
        .map(|line| line.split(",").map(|y| y.parse().unwrap()).collect())
        .collect();
    let sum: i32 = updates
        .into_iter()
        .filter(|u| {
            u.iter().enumerate().all(|(i, p)| {
                u[i..]
                    .to_vec()
                    .into_iter()
                    .collect::<HashSet<i32>>()
                    .is_disjoint(&ancestors[p])
            })
        })
        .map(|u| u[u.len() / 2])
        .sum();

    println!("{:?}", sum);
}
