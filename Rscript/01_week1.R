# WEEK1
# operands
<<<<<<< HEAD
y = 2
x = 1
z = x+y
z

mean(x,y)
sum(x,y)

#replicate
rep(1,10)
seq(1, 100,2)


# help
?seq

# environment
working directory 
getwd()
setwd("/data/Rpackage/Rtutorial")
ls()
rm(list=ls())



# data type

=======
y<- 2
x<- 1
z<-x+y
z
mean(x,y)
sum(x,y)
rep(1,4)
seq(1, 100,2)

#help
?

#environment
getwd()
setwd()
ls()
rm(list=ls())

### data type
>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049
#1.vectors
a <- c(1,2,5.3,6,-2,4) # numeric vector
b <- c("one","two","three") # character vector
c <- c(TRUE,TRUE,TRUE,FALSE,TRUE,FALSE) #logical vector
d <- c(1,2,3,4)
e <- c("red", "white", "red", NA)
f <- c(TRUE,TRUE,TRUE,FALSE)

#2. matrix
<<<<<<< HEAD
x <- matrix(1:20, nrow=5,ncol=4)
class(x)
class(a)
class(f)
=======
x<-matrix(1:20, nrow=5,ncol=4)
>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049

# another example
cells <- c(1,26,24,68)
rnames <- c("R1", "R2")
cnames <- c("C1", "C2")
<<<<<<< HEAD

mymatrix <- matrix(cells, nrow=2, ncol=2, byrow=TRUE,
                   dimnames=list(rnames, cnames))
colnames(mymatrix)
rownames(mymatrix)
=======
mymatrix <- matrix(cells, nrow=2, ncol=2, byrow=TRUE,
                   dimnames=list(rnames, cnames))

>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049

#Identify rows, columns or elements using subscripts.

x[,4] # 4th column of matrix
x[3,] # 3rd row of matrix
<<<<<<< HEAD
x2=x[2:4,1:3] # rows 2,3,4 of columns 1,2,3
x2

=======
x[2:4,1:3] # rows 2,3,4 of columns 1,2,3
>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049

#3. data frame
mydata <- data.frame(d,e,f)
names(mydata) <- c("ID","Color","Passed") # variable names

<<<<<<< HEAD
sum(as.matrix(mydata)[,1])
sum(mydata[,1])
x[,3]

class(mydata[3]) # columns 3,4,5 of data frame
class(mydata$f) # variable x1 in the data frame


# 4. list
# example of a list with 4 components -
# a string, a numeric vector, a matrix, and a scaler
w1 <- list(name="Fred",df=mydata, mynumbers=a, mymatrix=x, age=5.3)
class(w)
w2 <- list(aaaa=x, age=5.3)

# example of a list containing two lists
v <- c(w1,w2)
length(v)

# 5. factor
=======
mydata

myframe[3:5] # columns 3,4,5 of data frame
myframe[c("ID","Age")] # columns ID and Age from data frame
myframe$X1 # variable x1 in the data frame

#4. list
# example of a list with 4 components -
# a string, a numeric vector, a matrix, and a scaler
w <- list(name="Fred", mynumbers=a, mymatrix=y, age=5.3)

# example of a list containing two lists
v <- c(list1,list2)


#5. factor
>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049
# variable gender with 20 "male" entries and
# 30 "female" entries
gender <- c(rep("male",20), rep("female", 30))
gender <- factor(gender)
<<<<<<< HEAD
gender=factor(gender, levels=c("male","female","gay"))

=======
>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049
# stores gender as 20 1s and 30 2s and associates
# 1=female, 2=male internally (alphabetically)
# R now treats gender as a nominal variable
summary(gender)

<<<<<<< HEAD
getwd()
=======

>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049


# Read/Write
# first row contains variable names, comma is separator
# assign the variable id to row names
# note the / instead of \ on mswindows systems

<<<<<<< HEAD
write.table(mydata, "mydata.txt", sep="\t")

mydata <- read.table("mydata.txt", header=TRUE,
                     sep="\t")

mydata


# function

hello <- function(x="xxx") {
  print(c("Hello, world! ",x))
}

hello

hello(x="yyy")


=======
write.table(mydata, "c:/mydata.txt", sep="\t")

mydata <- read.table("c:/mydata.csv", header=TRUE,
                     sep=",", row.names="id")




# function
hello <- function() {
  print("Hello, world!")
}

hello()
>>>>>>> 91a7168412c0e861ef4733ff8098292f7a37e049

# expressionSet
# Granges
