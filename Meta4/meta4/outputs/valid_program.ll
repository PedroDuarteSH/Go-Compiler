@ia = global i32 0, align 4
@ib = global i32 0, align 4
@ic = global i32 0, align 4
@id = global i32 0, align 4
@ie = global i32 0, align 4
@fa = global double 0.0000000e+0, align 8
@fb = global double 0.0000000e+0, align 8
@fc = global double 0.0000000e+0, align 8
@fd = global double 0.0000000e+0, align 8
@fe = global double 0.0000000e+0, align 8
@ba = global i1 0, align 4
@bb = global i1 0, align 4
@bc = global i1 0, align 4
@bd = global i1 0, align 4
@sa = global i8* null, align 2
@sb = global i8* null, align 2
@sc = global i8* null, align 2
define void @fca () {
	ret void
}
define i32 @fcb () {
	%1 = alloca i32, align 4
	store i32 0, i32* %1, align 4
	%2 = add i32 132, 0
	store i32 %2, i32* %1, align 4
	%3 = load i32, i32* %1, align 4
	ret i32 %3
}
define double @fcd () {
	%1 = fadd double 0.1e1, 0.000000e+00
	%2 = fadd double 0.007, 0.000000e+00
	%3 = fadd double %1, %2
	ret double %3
}
define i8* @fce () {
	%1 = alloca i8*, align 2
	%2 = load i8*, i8** %1, align 2
	ret i8* %2
}
define i1 @fcf () {
	%1 = alloca i1, align 1
	store i1 0, i1* %1, align 1
	%2 = load i1, i1* %1, align 1
	ret i1 %2
}
define i32 @fcg (i32, double) {
	%3 = alloca i32, align 4
	store i32 %0, i32* %3
	%4 = alloca double, align 8
	store double %1, double* %4
	%5 = call i32 @fcb()
	ret i32 %5
}
define double @fch (i32, double, i8*) {
	%4 = alloca i32, align 4
	store i32 %0, i32* %4
	%5 = alloca double, align 8
	store double %1, double* %5
	%6 = alloca i8*, align 2
	store i8* %2, i8** %6
	%7 = call i32 @fcb()
	%8 = call double @fcd()
	%9 = call i32 @fcg(i32 %7, double %8)
	%10 = load i8*, i8** %6, align 2
	%11 = call i32 (i8*, ...) @printf(i8* getelementptr ([2 x i8], [2 x i8]* @str.0, i32 0, i32 0), i8* %10)
	%12 = fadd double 0.01, 0.000000e+00
	ret double %12
}
define double @fci (i32, i32, double, double, i8*) {
	%6 = alloca i32, align 4
	store i32 %0, i32* %6
	%7 = alloca i32, align 4
	store i32 %1, i32* %7
	%8 = alloca double, align 8
	store double %2, double* %8
	%9 = alloca double, align 8
	store double %3, double* %9
	%10 = alloca i8*, align 2
	store i8* %4, i8** %10
	%11 = call i32 @fcb()
	%12 = call double @fcd()
	%13 = call i32 @fcg(i32 %11, double %12)
	%14 = call double @fcd()
	%15 = call i8* @fce()
	%16 = call double @fch(i32 %13, double %14, i8* %15)
	%17 = load i32, i32* %7, align 4
	%18 = add i32 12, 0
	%19 = add i32 %17, %18
	%20 = load i32, i32* @ic, align 4
	%21 = add i32 %19, %20
	%22 = call i32 @fcb()
	%23 = add i32 %21, %22
	store i32 %23, i32* %6, align 4
	ret void
}
define i32 @fcj (i32, i32, double, double, i1) {
	%6 = alloca i32, align 4
	store i32 %0, i32* %6
	%7 = alloca i32, align 4
	store i32 %1, i32* %7
	%8 = alloca double, align 8
	store double %2, double* %8
	%9 = alloca double, align 8
	store double %3, double* %9
	%10 = alloca i1, align 1
	store i1 %4, i1* %10
	%11 = alloca i32, align 4
	store i32 0, i32* %11, align 4
	%12 = alloca i32, align 4
	store i32 0, i32* %12, align 4
	%13 = load i32, i32* @ia, align 4
	%14 = load i32, i32* @ib, align 4
	%15 = add i32 %13, %14
	%16 = load i32, i32* @ic, align 4
	%17 = load i32, i32* @id, align 4
	%18 = mul i32 %16, %17
	%19 = load i32, i32* @ie, align 4
	%20 = srem i32 %18, %19
	%21 = sub i32 %15, %20
	store i32 %21, i32* %11, align 4
	%22 = add i32 101, 0
	%23 = mul i32 -1, %22
	ret i32 %23
}
define i32 @main () {
	%1 = add i32 1, 0
	store i32 %1, i32* @ia, align 4
	store i32 %1, i32* @ib, align 4
	store i32 %1, i32* @ic, align 4
	store i32 %1, i32* @id, align 4
	store i32 %1, i32* @ie, align 4
	%2 = fadd double 0.1, 0.000000e+00
	store double %2, double* @fa, align 8
	store double %2, double* @fb, align 8
	store double %2, double* @fc, align 8
	store double %2, double* @fd, align 8
	store double %2, double* @fe, align 8
	%3 = alloca i32, align 4
	store i32 0, i32* %3, align 4
	%4 = alloca i32, align 4
	store i32 0, i32* %4, align 4
	%5 = load i32, i32* %4, align 4
	%6 = add i32 123, 0
	%7 = add i32 456, 0
	%8 = call i32 @fcb()
	%9 = add i32 %7, %8
	%10 = call double @fcd()
	%11 = fadd double 123.321, 0.000000e+00
	%12 = fadd double %10, %11
	%13 = call i32 @fcg(i32 %9, double %12)
	%14 = add i32 %6, %13
	%15 = load i32, i32* @ia, align 4
	%16 = load i32, i32* @ib, align 4
	%17 = add i32 %15, %16
	%18 = load i32, i32* @ic, align 4
	%19 = add i32 12, 0
	%20 = sdiv i32 %18, %19
	%21 = sub i32 %17, %20
	%22 = load i32, i32* @id, align 4
	%23 = load i32, i32* @ie, align 4
	%24 = mul i32 %22, %23
	%25 = call i32 @fcb()
	%26 = load double, double* @fa, align 8
	%27 = call i32 @fcg(i32 %25, double %26)
	%28 = srem i32 %24, %27
	%29 = add i32 %21, %28
	%30 = load i32, i32* @ia, align 4
	%31 = load i32, i32* @ib, align 4
	%32 = add i32 %30, %31
	%33 = load double, double* @fa, align 8
	%34 = call double @fcd()
	%35 = fadd double 0.1e12, 0.000000e+00
	%36 = fdiv double %34, %35
	%37 = fsub double %33, %36
	%38 = call double @fcd()
	%39 = call i8* @fce()
	%40 = call double @fci(i32 %32, i32 %6, double %37, double %38, i8* %39)
	%41 = add i32 312, 0
	%42 = add i32 %41, %19
	%43 = call double @fcd()
	%44 = fadd double 0.1e23, 0.000000e+00
	%45 = fadd double %43, %44
	%46 = call i8* @fce()
	%47 = call double @fch(i32 %42, double %45, i8* %46)
	%48 = call i1 @fcf()
	%49 = load i1, i1* @ba, align 1
	%50 = and i1 %48, %49
	%51 = load i1, i1* @bb, align 1
	%52 = or i1 %50, %51
	%53 = call i32 @fcj(i32 %14, i32 %29, double %40, double %47, i1 %52)
	%54 = add i32 %5, %53
	store i32 %54, i32* %3, align 4
	ret i32 0
}
declare i32 @printf(i8*, ...)
@str.0 = constant [2 x i8] c"\0A\00", align 1
