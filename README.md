# advent_of_code_2021

This repository contains the solutions of [Advent Of Code 2021](https://adventofcode.com/) written in [crystal](https://crystal-lang.org/) programming language.

## Installation and running

You can build and run this project if you have installed [crystal](https://crystal-lang.org/) 

``` bash
git clone https://github.com/dseres/advent_of_code_2021.git
cd advent_of_code_2021
shards install
shards build --release
bin/aoc2021
```

If you have docker, you could test it:
``` bash
git clone https://github.com/dseres/advent_of_code_2021.git
cd advent_of_code_2021
docker pull crystallang/crystal:1.5
docker run --rm -ti -v$PWD:/usr/src crystallang/crystal:1.5
cd /usr/src
shards install
shards build --release
bin/aoc2021
exit
```

You can run unit tests with 
``` bash
crystal spec
```

## My opinions
The subject Advent of code in the year of 2021 was finding a sleigh key for santa in the deep ocean. 

The puzzles become harder and harder from each day, but there were two which I felt really hard. First one was 'Day 19: Beacon Scanner' and the other is...

...big drumbeat... tadam...

 'Day 23: Amphipod'. (Is someone surprised? :D )

Exactly I hated this 23rd puzzle. On 23rd December I have to delay solving puzzle because I could not prepare Christmas, and I finished this half year later. 

I think choosing [crystal](https://crystal-lang.org/) was a good decision. With crystal I could write elegant and compact codes. Programming with crystal was so funny, parsing the input strings was really easy and during solving puzzles I didn't make so much mistakes. (Except Day23.) Tooling is quite enough, it supports unit tests, packaging etc... 

I am very happy that I have learnt this fantastic language. 