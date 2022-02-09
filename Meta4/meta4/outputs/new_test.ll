define void @f (i32) {
	%2 = alloca i32, align 4
	store i32 %0, i32* %2
	%3 = load i32, i32* %2, align 4
	%4 = call i32 (i8*, ...) @printf(i8* getelementptr ([4 x i8], [4 x i8]* @str.0, i32 0, i32 0), i32 %3)
	ret void
}
define i32 @main () {
	%1 = alloca i32, align 4
	store i32 0, i32* %1, align 4
	%2 = load i32, i32* %1, align 4
	%3 = call i32 (i8*, ...) @printf(i8* getelementptr ([4 x i8], [4 x i8]* @str.1, i32 0, i32 0), i32 %2)
	%4 = load i32, i32* %1, align 4
	call void @f(i32 %4)
	ret i32 0
}
declare i32 @printf(i8*, ...)
@str.0 = constant [4 x i8] c"%d\0A\00", align 1
@str.1 = constant [4 x i8] c"%d\0A\00", align 1
