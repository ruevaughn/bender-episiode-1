# Chase Jensen

## Bender Episode 1 for AllyDVM

```txt
> (1) While Not At Booth < - - - - - - - - - - - - |
>          |                                       |
>          V                                       |
> (2) Get Current/next Direction <----------|      |
>          |                                |      |
>          V                                |      |
> (3) Check if can move in that direction   |      |
>          |                                |      |
> (3A) Yes |--> No - - - - - - - - - - - - -^      |
>          V                                       |
> (4)   Make Move                                  |
>          |                                       |
>          V                                       |
> (4A) Check if state needs changing               |
>          |                                       |
> (4A) YES<|--> No - - - - - - - > - - - -- - - - -^
>          V                      |
> (5)    Make Interaction         v
>          |                      |
>          V                      ^
> (6)   At Suicide Booth?         |
>       YES|--> No <- - - - - - - -
>          V
>        DONE
```

```txt
INIT) Bender was facing SOUTH
0) Bender is now facing SOUTH
0) Bender is at {:row_index=>1, :column_index=>1}
0) Current Location: {:row_index=>1, :column_index=>1}
0) Getting new loc from direction: SOUTH
0) Bender will be moving tio {:row_index=>2, :column_index=>1}
0) Benders object is facing object
Can move to object: true
0) About to interact with object:
0) Interacting with object:
0) About to Take Step
0) Freeing Ram
0) Bender was facing SOUTH
0) Bender is now facing SOUTH
0) Bender is at
0) Current Location:
0) Getting new loc from direction: SOUTH
```

### Map 1

```ruby
map = [
  ["#", "#", "#", "#", "#"],
  ["#", "@", " ", " ", "#"],
  ["#", " ", " ", " ", "#"],
  ["#", " ", " ", "$", "#"],
  ["#", "#", "#", "#", "#"]
]
```
