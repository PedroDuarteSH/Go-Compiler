define i32 @factorial (i32) {
	%2 = alloca i32, align 4
	store i32 %0, i32* %2
	%3 = load i32, i32* %2, align 4
	%4 = load i32, i32* %2, align 4
	%5 = add i32 1, 0
	%6 = sub i32 %4, %5
	%7 = call i32 @factorial(i32 %6)
	%8 = mul i32 %3, %7
	ret i32 %8
}
define i32 @main () {
	%1 = alloca i32, align 4
	store i32 0, i32* %1, align 4
	%2 = add i32 5, 0
	store i32 %2, i32* %1, align 4
	%3 = load i32, i32* %1, align 4
	%4 = call i32 @factorial(i32 %3)
	%5 = call i32 (i8*, ...) @printf(i8* getelementptr ([4 x i8], [4 x i8]* @str.0, i32 0, i32 0), i32 %4)
	ret i32 0
}
declare i32 @printf(i8*, ...)
@str.0 = constant [4 x i8] c"%d\0A\00", align 1
