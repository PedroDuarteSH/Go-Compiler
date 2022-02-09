define void @oneFunc () {
	ret void
}
define void @twoFunc (i32) {
	%2 = alloca i32, align 4
	store i32 %0, i32* %2
	ret void
}
define void @treeFunc (i32, double) {
	%3 = alloca i32, align 4
	store i32 %0, i32* %3
	%4 = alloca double, align 8
	store double %1, double* %4
	%5 = alloca double, align 8
	store double 0.0000000e+0, double* %5, align 8
	ret void
}
define void @fourFunc (i32, double, i8*) {
	%4 = alloca i32, align 4
	store i32 %0, i32* %4
	%5 = alloca double, align 8
	store double %1, double* %5
	%6 = alloca i8*, align 2
	store i8* %2, i8** %6
	ret void
}
define void @fiveFunc (i32, double, i8*, i1) {
	%5 = alloca i32, align 4
	store i32 %0, i32* %5
	%6 = alloca double, align 8
	store double %1, double* %6
	%7 = alloca i8*, align 2
	store i8* %2, i8** %7
	%8 = alloca i1, align 1
	store i1 %3, i1* %8
	ret void
}
define i32 @sixFunc (i32) {
	%2 = alloca i32, align 4
	store i32 %0, i32* %2
	%3 = alloca i32, align 4
	store i32 0, i32* %3, align 4
	%4 = load i32, i32* %2, align 4
	store i32 %4, i32* %3, align 4
	%5 = load i32, i32* %3, align 4
	ret i32 %5
}
define double @sevenFunc (i32, double) {
	%3 = alloca i32, align 4
	store i32 %0, i32* %3
	%4 = alloca double, align 8
	store double %1, double* %4
	%5 = alloca double, align 8
	store double 0.0000000e+0, double* %5, align 8
	%6 = alloca double, align 8
	store double 0.0000000e+0, double* %6, align 8
	%7 = fadd double 0.52e4, 0.000000e+00
	store double %7, double* %5, align 8
	%8 = load double, double* %4, align 8
	%9 = load double, double* %5, align 8
	%10 = fadd double %8, %9
	store double %10, double* %6, align 8
	%11 = load double, double* %5, align 8
	ret double %11
}
define i8* @eightFunc (i32, double, i8*) {
	%4 = alloca i32, align 4
	store i32 %0, i32* %4
	%5 = alloca double, align 8
	store double %1, double* %5
	%6 = alloca i8*, align 2
	store i8* %2, i8** %6
	%7 = load i8*, i8** %6, align 2
	ret i8* %7
}
define i1 @nineFunc (i32, double, i8*, i1) {
	%5 = alloca i32, align 4
	store i32 %0, i32* %5
	%6 = alloca double, align 8
	store double %1, double* %6
	%7 = alloca i8*, align 2
	store i8* %2, i8** %7
	%8 = alloca i1, align 1
	store i1 %3, i1* %8
	%9 = alloca i1, align 1
	store i1 0, i1* %9, align 1
	%10 = load i1, i1* %9, align 1
	ret i1 %10
}
define i32 @tenFunc (i32) {
	%2 = alloca i32, align 4
	store i32 %0, i32* %2
	%3 = alloca double, align 8
	store double 0.0000000e+0, double* %3, align 8
	%4 = alloca double, align 8
	store double 0.0000000e+0, double* %4, align 8
	%5 = alloca double, align 8
	store double 0.0000000e+0, double* %5, align 8
	%6 = alloca double, align 8
	store double 0.0000000e+0, double* %6, align 8
	%7 = alloca i32, align 4
	store i32 0, i32* %7, align 4
	%8 = add i32 6, 0
	%9 = load i32, i32* %2, align 4
	%10 = add i32 %8, %9
	store i32 %10, i32* %7, align 4
	%11 = fadd double 0.01, 0.000000e+00
	store double %11, double* %3, align 8
	%12 = fadd double 0.123, 0.000000e+00
	%13 = load double, double* %3, align 8
	%14 = fadd double %12, %13
	store double %14, double* %4, align 8
	%15 = load double, double* %4, align 8
	%16 = load double, double* %3, align 8
	%17 = fadd double %15, %16
	store double %17, double* %5, align 8
	%18 = load double, double* %5, align 8
	store double %18, double* %3, align 8
	%19 = load double, double* %3, align 8
	%20 = load double, double* %4, align 8
	%21 = fadd double %19, %20
	store double %21, double* %6, align 8
	%22 = load double, double* %6, align 8
	store double %22, double* %3, align 8
	%23 = load double, double* %3, align 8
	%24 = load i32, i32* %7, align 4
	%25 = load double, double* %3, align 8
	%26 = call double @sevenFunc(i32 %24, double %25)
	%27 = fadd double %23, %26
	store double %27, double* %6, align 8
	%28 = load i32, i32* %7, align 4
	call void @twoFunc(i32 %28)
	%29 = load i32, i32* %7, align 4
	%30 = load double, double* %3, align 8
	call void @treeFunc(i32 %29, double %30)
	%31 = load i32, i32* %7, align 4
	ret i32 %31
}
define void @variable_func_declarations () {
	%1 = alloca i8*, align 2
	call void @oneFunc()
	%2 = add i32 1, 0
	%3 = call i32 @sixFunc(i32 %2)
	call void @twoFunc(i32 %3)
	%4 = fadd double 0.123, 0.000000e+00
	call void @treeFunc(i32 %2, double %4)
	%5 = call i32 @sixFunc(i32 %2)
	%6 = fadd double 0.321, 0.000000e+00
	%7 = load i8*, i8** %1, align 2
	call void @fourFunc(i32 %5, double %6, i8* %7)
	%8 = fadd double 0.2, 0.000000e+00
	%9 = load i8*, i8** %1, align 2
	%10 = add i32 2, 0
	%11 = icmp sgt i32 %2, %10
	call void @fiveFunc(i32 %2, double %8, i8* %9, i1 %11)
	%12 = call i32 @sixFunc(i32 %2)
	%13 = fadd double 0.1, 0.000000e+00
	%14 = load i8*, i8** %1, align 2
	%15 = call i8* @eightFunc(i32 %2, double %13, i8* %14)
	%16 = call double @sevenFunc(i32 %2, double %8)
	%17 = call i32 @tenFunc(i32 %2)
	ret void
}
define i32 @main () {
	call void @variable_func_declarations()
	ret i32 0
}
