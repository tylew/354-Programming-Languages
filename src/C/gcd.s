	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 12, 1
	.globl	_gcd                            ## -- Begin function gcd
	.p2align	4, 0x90
_gcd:                                   ## @gcd
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -8(%rbp)
	movl	%esi, -12(%rbp)
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jle	LBB0_2
## %bb.1:
	movl	-8(%rbp), %eax
	subl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
	movl	-8(%rbp), %edi
	movl	-12(%rbp), %esi
	callq	_gcd
	movl	%eax, -4(%rbp)
	jmp	LBB0_5
LBB0_2:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jge	LBB0_4
## %bb.3:
	movl	-12(%rbp), %eax
	subl	-8(%rbp), %eax
	movl	%eax, -12(%rbp)
	movl	-8(%rbp), %edi
	movl	-12(%rbp), %esi
	callq	_gcd
	movl	%eax, -4(%rbp)
	jmp	LBB0_5
LBB0_4:
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
LBB0_5:
	movl	-4(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                           ## -- Begin function main
	.p2align	4, 0x90
_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	$0, -4(%rbp)
	movl	$9, -8(%rbp)
	movl	$33, -12(%rbp)
	movl	-8(%rbp), %edi
	movl	-12(%rbp), %esi
	callq	_gcd
	movl	%eax, %esi
	leaq	L_.str(%rip), %rdi
	movb	$0, %al
	callq	_printf
	xorl	%eax, %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"%d\n"

.subsections_via_symbols
