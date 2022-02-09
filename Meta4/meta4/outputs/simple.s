	.text
	.file	"simple.ll"
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3               # -- Begin function main
.LCPI0_0:
	.quad	-4611686018427387904    # double -2
.LCPI0_1:
	.quad	4607632778762754458     # double 1.1000000000000001
.LCPI0_2:
	.quad	4611235658464650854     # double 1.8999999999999999
.LCPI0_3:
	.quad	0                       # double 0
	.text
	.globl	main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%r14
	.cfi_def_cfa_offset 16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -24
	.cfi_offset %r14, -16
	movb	11(%rsp), %al
	movb	%al, gb(%rip)
	movl	12(%rsp), %eax
	movl	%eax, gi(%rip)
	movsd	16(%rsp), %xmm0         # xmm0 = mem[0],zero
	movsd	%xmm0, gf(%rip)
	movl	$-2, 12(%rsp)
	movabsq	$-4611686018427387904, %rax # imm = 0xC000000000000000
	movq	%rax, gf(%rip)
	movsd	.LCPI0_0(%rip), %xmm0   # xmm0 = mem[0],zero
	movl	$.Lstr.0, %edi
	movb	$1, %al
	callq	printf
	xorpd	%xmm1, %xmm1
	movsd	gf(%rip), %xmm0         # xmm0 = mem[0],zero
	addsd	%xmm1, %xmm0
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	xorpd	%xmm0, %xmm0
	subsd	gf(%rip), %xmm0
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	movabsq	$4607632778762754458, %rax # imm = 0x3FF199999999999A
	movq	%rax, gf(%rip)
	movsd	.LCPI0_1(%rip), %xmm0   # xmm0 = mem[0],zero
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	movsd	gf(%rip), %xmm0         # xmm0 = mem[0],zero
	addsd	.LCPI0_3, %xmm0
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	xorpd	%xmm0, %xmm0
	subsd	gf(%rip), %xmm0
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	movl	12(%rsp), %esi
	movl	$.Lstr.2, %edi
	xorl	%eax, %eax
	callq	printf
	movl	12(%rsp), %esi
	movl	$.Lstr.2, %edi
	xorl	%eax, %eax
	callq	printf
	xorl	%esi, %esi
	subl	12(%rsp), %esi
	movl	$.Lstr.2, %edi
	xorl	%eax, %eax
	callq	printf
	movl	$.Lstr.2, %edi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf
	movl	gi(%rip), %esi
	movl	$.Lstr.2, %edi
	xorl	%eax, %eax
	callq	printf
	movl	12(%rsp), %esi
	movl	%esi, gi(%rip)
	movl	$.Lstr.2, %edi
	xorl	%eax, %eax
	callq	printf
	movq	$0, 16(%rsp)
	movl	$.Lstr.1, %edi
	xorpd	%xmm0, %xmm0
	movb	$1, %al
	callq	printf
	movsd	.LCPI0_2(%rip), %xmm0   # xmm0 = mem[0],zero
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	movsd	gf(%rip), %xmm0         # xmm0 = mem[0],zero
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	movsd	16(%rsp), %xmm0         # xmm0 = mem[0],zero
	movsd	%xmm0, gf(%rip)
	movl	$.Lstr.1, %edi
	movb	$1, %al
	callq	printf
	movl	$.Lstr.1, %edi
	xorps	%xmm0, %xmm0
	movb	$1, %al
	callq	printf
	movl	$.Ltrue, %r14d
	movl	$.Lfalse, %ebx
	cmpb	$0, gb(%rip)
	movl	$.Lfalse, %esi
	cmovneq	%r14, %rsi
	movl	$.Lstr.3, %edi
	xorl	%eax, %eax
	callq	printf
	movl	$.Lstr.2, %edi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf
	movl	$.Lstr.2, %edi
	xorl	%esi, %esi
	xorl	%eax, %eax
	callq	printf
	movl	$.Lstr.1, %edi
	xorps	%xmm0, %xmm0
	movb	$1, %al
	callq	printf
	xorl	%esi, %esi
	subl	12(%rsp), %esi
	movl	$.Lstr.2, %edi
	xorl	%eax, %eax
	callq	printf
	cmpb	$0, gb(%rip)
	movl	$.Lfalse, %esi
	cmovneq	%r14, %rsi
	movl	$.Lstr.3, %edi
	xorl	%eax, %eax
	callq	printf
	cmpb	$0, 11(%rsp)
	cmovneq	%r14, %rbx
	movl	$.Lstr.3, %edi
	xorl	%eax, %eax
	movq	%rbx, %rsi
	callq	printf
	movl	$.Lstr.4, %edi
	xorl	%eax, %eax
	callq	printf
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%r14
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end0:
	.size	main, .Lfunc_end0-main
	.cfi_endproc
                                        # -- End function
	.type	gi,@object              # @gi
	.comm	gi,4,4
	.type	gb,@object              # @gb
	.comm	gb,1,1
	.type	gs,@object              # @gs
	.comm	gs,8,8
	.type	gf,@object              # @gf
	.comm	gf,8,8
	.type	.Lstr.0,@object         # @str.0
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr.0:
	.asciz	"%.08f\n"
	.size	.Lstr.0, 7

	.type	.Lstr.1,@object         # @str.1
.Lstr.1:
	.asciz	"%.08f\n"
	.size	.Lstr.1, 7

	.type	.Lstr.2,@object         # @str.2
.Lstr.2:
	.asciz	"%d\n"
	.size	.Lstr.2, 4

	.type	.Lstr.3,@object         # @str.3
.Lstr.3:
	.asciz	"%s\n"
	.size	.Lstr.3, 4

	.type	.Lstr.4,@object         # @str.4
	.section	.rodata.str1.16,"aMS",@progbits,1
	.p2align	4
.Lstr.4:
	.asciz	"Print123%%d%%f%%.08fTesting%%s\n"
	.size	.Lstr.4, 32

	.type	.Ltrue,@object          # @true
	.section	.rodata.str1.1,"aMS",@progbits,1
.Ltrue:
	.asciz	"true"
	.size	.Ltrue, 5

	.type	.Lfalse,@object         # @false
.Lfalse:
	.asciz	"false"
	.size	.Lfalse, 6


	.section	".note.GNU-stack","",@progbits
