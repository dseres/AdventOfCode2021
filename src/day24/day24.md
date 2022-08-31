# Explanation of Day24

A repeating pattern can be recognize in input data. I wrote a simple `break_lines` function to split input at every `inp w` instruction into 14 columns. The following tables shows the input: 

|Program1|Program2|Program3|Program4|Program5|Program6|Program7|Program8|Program9|Program10|Program11|Program12|Program13|Program14|
|----------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|
| inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |inp w    |
| mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |mul x 0  |
| add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |add x z  |
| mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |mod x 26 |
| div z 1  |div z 1  |div z 1  |div z 1  |div z 26 |div z 26 |div z 1  |div z 26 |div z 1  |div z 26 |div z 1  |div z 26 |div z 26 |div z 26 |
| add x 11 |add x 11 |add x 14 |add x 11 |add x -8 |add x -5 |add x 11 |add x -13|add x 12 |add x -1 |add x 14 |add x -5 |add x -4 |add x -8 |
| eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |eql x w  |
| eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |eql x 0  |
| mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |
| add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |add y 25 |
| mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |
| add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |add y 1  |
| mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |mul z y  |
| mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |mul y 0  |
| add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |add y w  |
| add y 1  |add y 11 |add y 1  |add y 11 |add y 2  |add y 9  |add y 7  |add y 11 |add y 6  |add y 15 |add y 7  |add y 1  |add y 8  |add y 6  |
| mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |mul y x  |
| add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |add z y  |

Most of the instructions in programs are the same exept in lines started with `div z 1`, `add x 11` and `add y 1`. The variable parameters will be called as param1, param2, param3. Value of these parameters are:
```
[[1, 11, 1], [1, 11, 11], [1, 14, 1], [1, 11, 11], [26, -8, 2], [26, -5, 9], [1, 11, 7], [26, -13, 11], [1, 12, 6], [26, -1, 15], [1, 14, 7], [26, -5, 1], [26, -4, 8], [26, -8, 6]]
```

After some reverse enginering, each program can be summerized as: 
```
x = ( ( z % 26 + param2) == input ? 0 : 1 )
z = z // param1 * (25 * x + 1)
y = ( input + param3 ) * x
z = z + y
```
 
For the program one, x,y,z = 0. inputs is between 1 and 9. Lets evaluate first program:
```
z = input1 + 1
```
The second:
```
z = z * ( 26 ) + ( input2 + 11 ) 
```
The third: 
```
z = z * 26 + ( input3 + 1)
```

z can be computed easily for any input, but there are too much input values. We can shrink the set of inputs. If there is two different input having the same z, we have to store the larger, because we need to find the larges 'good' input.

A **brute force** search can finish whitin **11** secs.