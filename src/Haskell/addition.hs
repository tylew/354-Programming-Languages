-- numbers
data NN = O | S NN
    deriving (Eq,Show)

-- addition
add :: NN -> NN -> NN
add O n = n
add (S n) m = S (add n m)
-- add (S O) (S (S O))

-- multiplication
-- mult (S (S O)) (S (S ( S O)))
