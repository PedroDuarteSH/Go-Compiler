; ModuleID = 'tree.c'
source_filename = "tree.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.Node = type { i8*, i8*, i8*, i32, i32, i32, %struct.Node*, %struct.Node* }

@.str = private unnamed_addr constant [3 x i8] c"..\00", align 1
@.str.1 = private unnamed_addr constant [8 x i8] c"%s(%s)\0A\00", align 1
@.str.2 = private unnamed_addr constant [4 x i8] c"%s\0A\00", align 1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local %struct.Node* @new_node(i8*, i8*, %struct.Node*) #0 {
  %4 = alloca i8*, align 8
  %5 = alloca i8*, align 8
  %6 = alloca %struct.Node*, align 8
  %7 = alloca %struct.Node*, align 8
  store i8* %0, i8** %4, align 8
  store i8* %1, i8** %5, align 8
  store %struct.Node* %2, %struct.Node** %6, align 8
  %8 = call noalias i8* @malloc(i64 56) #3
  %9 = bitcast i8* %8 to %struct.Node*
  store %struct.Node* %9, %struct.Node** %7, align 8
  %10 = load i8*, i8** %4, align 8
  %11 = load %struct.Node*, %struct.Node** %7, align 8
  %12 = getelementptr inbounds %struct.Node, %struct.Node* %11, i32 0, i32 0
  store i8* %10, i8** %12, align 8
  %13 = load i8*, i8** %5, align 8
  %14 = load %struct.Node*, %struct.Node** %7, align 8
  %15 = getelementptr inbounds %struct.Node, %struct.Node* %14, i32 0, i32 1
  store i8* %13, i8** %15, align 8
  %16 = load %struct.Node*, %struct.Node** %7, align 8
  %17 = getelementptr inbounds %struct.Node, %struct.Node* %16, i32 0, i32 2
  store i8* null, i8** %17, align 8
  %18 = load %struct.Node*, %struct.Node** %7, align 8
  %19 = getelementptr inbounds %struct.Node, %struct.Node* %18, i32 0, i32 3
  store i32 0, i32* %19, align 8
  %20 = load %struct.Node*, %struct.Node** %7, align 8
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 4
  store i32 0, i32* %21, align 4
  %22 = load %struct.Node*, %struct.Node** %6, align 8
  %23 = load %struct.Node*, %struct.Node** %7, align 8
  %24 = getelementptr inbounds %struct.Node, %struct.Node* %23, i32 0, i32 6
  store %struct.Node* %22, %struct.Node** %24, align 8
  %25 = load %struct.Node*, %struct.Node** %7, align 8
  %26 = getelementptr inbounds %struct.Node, %struct.Node* %25, i32 0, i32 7
  store %struct.Node* null, %struct.Node** %26, align 8
  %27 = load %struct.Node*, %struct.Node** %7, align 8
  ret %struct.Node* %27
}

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64) #1

; Function Attrs: noinline nounwind optnone uwtable
define dso_local %struct.Node* @new_node_CL(i8*, i8*, %struct.Node*, i32, i32) #0 {
  %6 = alloca i8*, align 8
  %7 = alloca i8*, align 8
  %8 = alloca %struct.Node*, align 8
  %9 = alloca i32, align 4
  %10 = alloca i32, align 4
  %11 = alloca %struct.Node*, align 8
  store i8* %0, i8** %6, align 8
  store i8* %1, i8** %7, align 8
  store %struct.Node* %2, %struct.Node** %8, align 8
  store i32 %3, i32* %9, align 4
  store i32 %4, i32* %10, align 4
  %12 = call noalias i8* @malloc(i64 56) #3
  %13 = bitcast i8* %12 to %struct.Node*
  store %struct.Node* %13, %struct.Node** %11, align 8
  %14 = load i8*, i8** %6, align 8
  %15 = load %struct.Node*, %struct.Node** %11, align 8
  %16 = getelementptr inbounds %struct.Node, %struct.Node* %15, i32 0, i32 0
  store i8* %14, i8** %16, align 8
  %17 = load i8*, i8** %7, align 8
  %18 = load %struct.Node*, %struct.Node** %11, align 8
  %19 = getelementptr inbounds %struct.Node, %struct.Node* %18, i32 0, i32 1
  store i8* %17, i8** %19, align 8
  %20 = load %struct.Node*, %struct.Node** %11, align 8
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 2
  store i8* null, i8** %21, align 8
  %22 = load i32, i32* %10, align 4
  %23 = load %struct.Node*, %struct.Node** %11, align 8
  %24 = getelementptr inbounds %struct.Node, %struct.Node* %23, i32 0, i32 4
  store i32 %22, i32* %24, align 4
  %25 = load i32, i32* %9, align 4
  %26 = load %struct.Node*, %struct.Node** %11, align 8
  %27 = getelementptr inbounds %struct.Node, %struct.Node* %26, i32 0, i32 3
  store i32 %25, i32* %27, align 8
  %28 = load %struct.Node*, %struct.Node** %8, align 8
  %29 = load %struct.Node*, %struct.Node** %11, align 8
  %30 = getelementptr inbounds %struct.Node, %struct.Node* %29, i32 0, i32 6
  store %struct.Node* %28, %struct.Node** %30, align 8
  %31 = load %struct.Node*, %struct.Node** %11, align 8
  %32 = getelementptr inbounds %struct.Node, %struct.Node* %31, i32 0, i32 7
  store %struct.Node* null, %struct.Node** %32, align 8
  %33 = load %struct.Node*, %struct.Node** %11, align 8
  ret %struct.Node* %33
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local %struct.Node* @new_brother(%struct.Node*, %struct.Node*) #0 {
  %3 = alloca %struct.Node*, align 8
  %4 = alloca %struct.Node*, align 8
  %5 = alloca %struct.Node*, align 8
  %6 = alloca %struct.Node*, align 8
  store %struct.Node* %0, %struct.Node** %4, align 8
  store %struct.Node* %1, %struct.Node** %5, align 8
  %7 = load %struct.Node*, %struct.Node** %4, align 8
  %8 = icmp eq %struct.Node* %7, null
  br i1 %8, label %9, label %10

; <label>:9:                                      ; preds = %2
  store %struct.Node* null, %struct.Node** %3, align 8
  br label %26

; <label>:10:                                     ; preds = %2
  %11 = load %struct.Node*, %struct.Node** %4, align 8
  store %struct.Node* %11, %struct.Node** %6, align 8
  br label %12

; <label>:12:                                     ; preds = %17, %10
  %13 = load %struct.Node*, %struct.Node** %4, align 8
  %14 = getelementptr inbounds %struct.Node, %struct.Node* %13, i32 0, i32 7
  %15 = load %struct.Node*, %struct.Node** %14, align 8
  %16 = icmp ne %struct.Node* %15, null
  br i1 %16, label %17, label %21

; <label>:17:                                     ; preds = %12
  %18 = load %struct.Node*, %struct.Node** %4, align 8
  %19 = getelementptr inbounds %struct.Node, %struct.Node* %18, i32 0, i32 7
  %20 = load %struct.Node*, %struct.Node** %19, align 8
  store %struct.Node* %20, %struct.Node** %4, align 8
  br label %12

; <label>:21:                                     ; preds = %12
  %22 = load %struct.Node*, %struct.Node** %5, align 8
  %23 = load %struct.Node*, %struct.Node** %4, align 8
  %24 = getelementptr inbounds %struct.Node, %struct.Node* %23, i32 0, i32 7
  store %struct.Node* %22, %struct.Node** %24, align 8
  %25 = load %struct.Node*, %struct.Node** %6, align 8
  store %struct.Node* %25, %struct.Node** %3, align 8
  br label %26

; <label>:26:                                     ; preds = %21, %9
  %27 = load %struct.Node*, %struct.Node** %3, align 8
  ret %struct.Node* %27
}

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @print_tree(%struct.Node*, i32) #0 {
  %3 = alloca %struct.Node*, align 8
  %4 = alloca i32, align 4
  %5 = alloca i32, align 4
  store %struct.Node* %0, %struct.Node** %3, align 8
  store i32 %1, i32* %4, align 4
  %6 = load %struct.Node*, %struct.Node** %3, align 8
  %7 = icmp eq %struct.Node* %6, null
  br i1 %7, label %8, label %9

; <label>:8:                                      ; preds = %2
  br label %47

; <label>:9:                                      ; preds = %2
  store i32 0, i32* %5, align 4
  br label %10

; <label>:10:                                     ; preds = %16, %9
  %11 = load i32, i32* %5, align 4
  %12 = load i32, i32* %4, align 4
  %13 = icmp slt i32 %11, %12
  br i1 %13, label %14, label %19

; <label>:14:                                     ; preds = %10
  %15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str, i32 0, i32 0))
  br label %16

; <label>:16:                                     ; preds = %14
  %17 = load i32, i32* %5, align 4
  %18 = add nsw i32 %17, 1
  store i32 %18, i32* %5, align 4
  br label %10

; <label>:19:                                     ; preds = %10
  %20 = load %struct.Node*, %struct.Node** %3, align 8
  %21 = getelementptr inbounds %struct.Node, %struct.Node* %20, i32 0, i32 1
  %22 = load i8*, i8** %21, align 8
  %23 = icmp ne i8* %22, null
  br i1 %23, label %24, label %32

; <label>:24:                                     ; preds = %19
  %25 = load %struct.Node*, %struct.Node** %3, align 8
  %26 = getelementptr inbounds %struct.Node, %struct.Node* %25, i32 0, i32 0
  %27 = load i8*, i8** %26, align 8
  %28 = load %struct.Node*, %struct.Node** %3, align 8
  %29 = getelementptr inbounds %struct.Node, %struct.Node* %28, i32 0, i32 1
  %30 = load i8*, i8** %29, align 8
  %31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @.str.1, i32 0, i32 0), i8* %27, i8* %30)
  br label %37

; <label>:32:                                     ; preds = %19
  %33 = load %struct.Node*, %struct.Node** %3, align 8
  %34 = getelementptr inbounds %struct.Node, %struct.Node* %33, i32 0, i32 0
  %35 = load i8*, i8** %34, align 8
  %36 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @.str.2, i32 0, i32 0), i8* %35)
  br label %37

; <label>:37:                                     ; preds = %32, %24
  %38 = load %struct.Node*, %struct.Node** %3, align 8
  %39 = getelementptr inbounds %struct.Node, %struct.Node* %38, i32 0, i32 6
  %40 = load %struct.Node*, %struct.Node** %39, align 8
  %41 = load i32, i32* %4, align 4
  %42 = add nsw i32 %41, 1
  call void @print_tree(%struct.Node* %40, i32 %42)
  %43 = load %struct.Node*, %struct.Node** %3, align 8
  %44 = getelementptr inbounds %struct.Node, %struct.Node* %43, i32 0, i32 7
  %45 = load %struct.Node*, %struct.Node** %44, align 8
  %46 = load i32, i32* %4, align 4
  call void @print_tree(%struct.Node* %45, i32 %46)
  br label %47

; <label>:47:                                     ; preds = %37, %8
  ret void
}

declare dso_local i32 @printf(i8*, ...) #2

; Function Attrs: noinline nounwind optnone uwtable
define dso_local void @cleanTree(%struct.Node*) #0 {
  %2 = alloca %struct.Node*, align 8
  store %struct.Node* %0, %struct.Node** %2, align 8
  %3 = load %struct.Node*, %struct.Node** %2, align 8
  %4 = icmp eq %struct.Node* %3, null
  br i1 %4, label %5, label %6

; <label>:5:                                      ; preds = %1
  br label %15

; <label>:6:                                      ; preds = %1
  %7 = load %struct.Node*, %struct.Node** %2, align 8
  %8 = getelementptr inbounds %struct.Node, %struct.Node* %7, i32 0, i32 7
  %9 = load %struct.Node*, %struct.Node** %8, align 8
  call void @cleanTree(%struct.Node* %9)
  %10 = load %struct.Node*, %struct.Node** %2, align 8
  %11 = getelementptr inbounds %struct.Node, %struct.Node* %10, i32 0, i32 6
  %12 = load %struct.Node*, %struct.Node** %11, align 8
  call void @cleanTree(%struct.Node* %12)
  %13 = load %struct.Node*, %struct.Node** %2, align 8
  %14 = bitcast %struct.Node* %13 to i8*
  call void @free(i8* %14) #3
  br label %15

; <label>:15:                                     ; preds = %6, %5
  ret void
}

; Function Attrs: nounwind
declare dso_local void @free(i8*) #1

attributes #0 = { noinline nounwind optnone uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { nounwind }

!llvm.module.flags = !{!0}
!llvm.ident = !{!1}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{!"clang version 7.0.1-12 (tags/RELEASE_701/final)"}
