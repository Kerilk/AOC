require 'matrix'

inputs = File.read('input').split("\n\n").map { |block| Matrix[*block.tr('#.', '10').each_line.map(&:strip).map { |l| l.chars.map(&:to_i) }] }

def find_mirrors(vecs, smudges)
  (1...vecs.size).find_all { |i|
    [i, vecs.size - i].min.times.map { |j| (vecs[i - j - 1] - vecs[i + j]).map(&:abs).sum }.sum == smudges
  }
end

def score_mat(mat, smudges)
  find_mirrors(mat.column_vectors, smudges).sum + find_mirrors(mat.row_vectors, smudges).sum * 100
end

p inputs.map { |mat| score_mat(mat, 0) }.sum
p inputs.map { |mat| score_mat(mat, 1) }.sum
