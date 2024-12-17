# Introduction

Cruml (_**Cr**ystal and **UML**_) is a library that provides a UML class diagram generator.
This is useful when you work on a big Crystal projects and you want to represent your project
structure.

``` mermaid
classDiagram 

direction LR

Person --|> Employee

class Person {
    -name : String
    +name() String
}

class Employee {
    -wage : Int32
    +wage() Int32
    +wage=() Nil
}
```

!!! note

    Cruml uses [mermaid.js](https://mermaid.js.org/) library to display the UML class diagram.