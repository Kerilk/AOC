use std::fs;

fn main() {
    let number_str = fs::read_to_string("input").unwrap();

    let max = number_str
        .split("\n\n")
        .map(|g| return g.lines().map(|x| x.parse::<u64>().unwrap()).sum::<u64>())
        .max()
        .unwrap();
    println!("{}", max);
}
