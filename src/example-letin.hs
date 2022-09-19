f :: Int -> Int
f x = 
    let a = 2
        b = 3
    in
    a*b*x

main = do
    print $ f 4

