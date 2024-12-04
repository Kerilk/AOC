use std::fs;

fn main() {
    let input: Vec<Vec<_>> = fs::read_to_string("input")
         .unwrap()
         .lines()
         .map(|line| [line.chars().collect(), vec![' '; 3]].concat())
         .collect();
    let n_rows = input.len();
    let n_cols = input[0].len()-3;
    let input = [input, vec![vec![' '; n_cols + 3]; 3]].concat();
    let search = [vec!['X', 'M', 'A', 'S'], vec!['S', 'A', 'M', 'X']];
    let count = (0..n_rows).into_iter().map(|i|
        (0..n_cols).into_iter().map(|j|
            (0..4).into_iter().fold([vec![], vec![], vec![], vec![]], |[mut a, mut b, mut c, mut d], k| {
                a.push(input[i+k][j  ]);
                b.push(input[i  ][j+k]);
                c.push(input[i+k][j+k]);
                d.push(input[i+k][n_cols+3-1-k-j]);
                [a, b, c, d]
            }).into_iter().filter(|x| search.contains(&x)).count()
        ).sum::<usize>()
    ).sum::<usize>();
    println!("{:?}", count);
}
