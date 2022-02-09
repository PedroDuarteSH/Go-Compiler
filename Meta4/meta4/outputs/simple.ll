define i32 @main () {
	%1 = alloca i32, align 4
	store i32 0, i32* %1, align 4
	%2 = alloca i32, align 4
	store i32 0, i32* %2, align 4
	%3 = alloca i32, align 4
	store i32 0, i32* %3, align 4
	%4 = alloca double, align 8
	store double 0.0000000e+0, double* %4, align 8
	%5 = alloca double, align 8
	store double 0.0000000e+0, double* %5, align 8
	%6 = alloca i32, align 4
	store i32 0, i32* %6, align 4
	%7 = alloca i32, align 4
	store i32 0, i32* %7, align 4
	%8 = alloca i32, align 4
	store i32 0, i32* %8, align 4
	%9 = alloca double, align 8
	store double 0.0000000e+0, double* %9, align 8
	%10 = alloca double, align 8
	store double 0.0000000e+0, double* %10, align 8
	%11 = add i32 50, 0
	store i32 %11, i32* %1, align 4
	%12 = add i32 20, 0
	store i32 %12, i32* %2, align 4
	%13 = add i32 34, 0
	store i32 %13, i32* %3, align 4
	%14 = fadd double 0.7, 0.000000e+00
	store double %14, double* %4, align 8
	%15 = fadd double 8.9, 0.000000e+00
	store double %15, double* %5, align 8
	%16 = add i32 64, 0
	store i32 %16, i32* %6, align 4
	%17 = add i32 42, 0
	store i32 %17, i32* %7, align 4
	%18 = add i32 55, 0
	store i32 %18, i32* %8, align 4
	%19 = fadd double 1.0e+25, 0.000000e+00
	store double %19, double* %9, align 8
	%20 = fadd double 0.5, 0.000000e+00
	store double %20, double* %10, align 8
	%21 = load double, double* %10, align 8
	%22 = fadd double 37.0, 0.000000e+00
	%23 = fmul double %21, %22
	%24 = fadd double 9.0, 0.000000e+00
	%25 = load double, double* %9, align 8
	%26 = fmul double %24, %25
	%27 = fsub double %23, %26
	%28 = call i32 (i8*, ...) @printf(i8* getelementptr ([7 x i8], [7 x i8]* @str.0, i32 0, i32 0), double %27)
	%29 = load double, double* %5, align 8
	%30 = load double, double* %10, align 8
	%31 = fmul double %29, %30
	%32 = load double, double* %4, align 8
	%33 = fadd double 0.0, 0.000000e+00
	%34 = fmul double %32, %33
	%35 = fsub double %31, %34
	%36 = call i32 (i8*, ...) @printf(i8* getelementptr ([7 x i8], [7 x i8]* @str.1, i32 0, i32 0), double %35)
	%37 = load double, double* %5, align 8
	%38 = load double, double* %5, align 8
	%39 = fmul double %37, %38
	%40 = load double, double* %9, align 8
	%41 = fsub double %39, %40
	%42 = call i32 (i8*, ...) @printf(i8* getelementptr ([7 x i8], [7 x i8]* @str.1, i32 0, i32 0), double %41)
	%43 = load i32, i32* %2, align 4
	%44 = add i32 600, 0
	%45 = mul i32 %43, %44
	%46 = load i32, i32* %8, align 4
	%47 = add i32 4, 0
	%48 = sdiv i32 %46, %47
	%49 = add i32 %45, %48
	%50 = call i32 (i8*, ...) @printf(i8* getelementptr ([4 x i8], [4 x i8]* @str.2, i32 0, i32 0), i32 %49)
	%51 = load double, double* %10, align 8
	%52 = fadd double 37.8, 0.000000e+00
	%53 = fmul double %51, %52
	%54 = fadd double 9.1, 0.000000e+00
	%55 = fdiv double %53, %54
	%56 = load double, double* %10, align 8
	%57 = fmul double %55, %56
	%58 = call i32 (i8*, ...) @printf(i8* getelementptr ([7 x i8], [7 x i8]* @str.1, i32 0, i32 0), double %57)
	ret i32 0
}
declare i32 @printf(i8*, ...)
@str.0 = constant [7 x i8] c"%.08f\0A\00", align 1
@str.1 = constant [7 x i8] c"%.08f\0A\00", align 1
@str.2 = constant [4 x i8] c"%d\0A\00", align 1
