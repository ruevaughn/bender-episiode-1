```
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