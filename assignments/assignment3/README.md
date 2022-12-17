### Programming using LambdaFun parser

Tyler Lewis
CPSC 354: Programming Languages
Dr. Kurz

## Critical Appraisal

```
func insert(int n, int[] lst) {
    int i = 0
    int[] ret = int[lst.length() +1]

    for (x in lst) {
        if (n > x) {
            ret[i] = n
            i+=1
        }
        ret[i] = x
        i+=1
    }

    return ret;
}
```
```
func sort(int[] lst) {
    int[] ret

    for (x in lst) {
        ret = insert(x ret)
    }

    return ret
}
```


In this assignment, I had a successful experience understanding and completing the tasks given. The most interesting aspect of the assignment was the process of changing the memory model, analyzing lambda memory and linked lists, and implementing functions to manage memory addresses on the heap. I learned about the difference between the stack and the heap, and discovered that variables on the heap are mutable while those on the stack are immutable. I also learned about the concept of mutability and immutability and how they apply to memory. Through the assignment, I learned how to manipulate and modify the state of memory on the heap using functions such as insert, delete, update, and get. In addition, I gained experience using the lambdaFun language to modify lists using various operations, building off of assignment 2. Initially, I struggled with understanding the syntax of Haskell and the use of lambda and variables as functions, but after some time to sit on assignment 2 have gained a better understanding of these concepts. Overall, I found the assignment to be a great opportunity to test my knowledge of Haskell and functional programming, and had fun learning about memory pointers and the importance of the stack and heap.