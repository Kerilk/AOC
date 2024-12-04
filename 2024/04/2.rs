use std::fs;

fn main() {
    let input: Vec<Vec<_>> = fs::read_to_string("input")
         .unwrap()
         .lines()
         .map(|line| line.chars().collect())
         .collect();
    let search = [vec!['M', 'A', 'S'], vec!['S', 'A', 'M']];
    let count = (1..(input.len()-1)).into_iter().map(|i|
        (1..(input[0].len()-1)).into_iter().map(|j|
            (0..3).into_iter().fold([Vec::new(), Vec::new()], |[mut a, mut b], k| {
                a.push(input[i+k-1][j+k-1]);
                b.push(input[i+k-1][j+1-k]);
                [a, b]
            }).into_iter().filter(|x| search.contains(&x)).count()/2
        ).sum::<usize>()
    ).sum::<usize>();
    println!("{:?}", count);
}
