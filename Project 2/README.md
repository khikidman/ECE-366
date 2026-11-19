**Project 2:**

**Final Report**

**GitHub Link:** https://github.com/khikidman/ECE-366

**Team Contributions:**

Chris Amankwah (caman2): Worked on the Fibonacci function and base case implementation, debugging the code, and verifying the IsOdd outputs.

Khi Kidman (mkidma2): Worked on the loop logic, division-by-repeated-subtraction loop, and register operations.

Bhumi Pandhare (bpand5): Worked on the MIPS code implementation, stack handling, and testing.

Sara Shujath (sshuj): Worked on debugging and verifying the Fibonacci outputs, the IsOdd(m) function, and its return logic (True/False).

**How the program works:**

For the final part, the Fibonacci and IsOdd functions from the first two reports are combined in mips3.asm. IsFibonacciOdd(n) first finds the nth Fibonacci number, then passes that number to IsOdd to check whether it is odd.

IsOdd uses the same repeated-subtraction loop as before. It keeps subtracting 2 until the remainder is less than 2. A remainder of 1 means the number is odd, so the function returns 1. Otherwise, it returns 0. The program does not use the MIPS DIV instruction.

The functions that make other function calls save $ra on the stack and restore it before returning. main stores the final answer at result and prints it.

**How we can run the MIPS program to find if the nth Fibonacci number is odd:**

1) Open the MARS MIPS simulator and the mips3.asm file.
2) Change the value of n in the .data section to the desired integer. The default is 10.
3) Leave Delayed branching off and extended (pseudo) instructions on in MARS Settings.
4) Click Assemble and then Run to execute the program.
5) The result (1 if the Fibonacci number is odd, 0 if it is even) will appear in the Run I/O window. It is also stored in memory at the label result. The input n stays in its own memory location.
6) To try a different n, change it and assemble again before running.

For the default input n = 10, Fibonacci(10) = 55, so the output is IsFibonacciOdd(n) = 1. For n = 6, Fibonacci(6) = 8, so the output is 0. The base cases are Fibonacci(0) = 0 and Fibonacci(1) = 1.

**Testing:**

Testing was done in MARS 4.5. All 10 full program runs and 34 function tests passed. These included n = 0 and n = 1, several odd and even Fibonacci numbers, and checks that the stack was restored after function calls. The printed answers and the results in memory were also checked.

The combined function was tested through n = 30. The Fibonacci function alone was also checked at n = 45 and n = 46; those larger values were not run through IsOdd because repeated subtraction takes much longer.

The tests can be run again from the project folder with:

```sh
python3 test_mips.py /path/to/Mars4_5.jar
```

Replace the path with wherever the MARS file is saved on your machine.

**Note:**

Keep n between 0 and 46. Fibonacci(47) is too large for a signed 32-bit register and causes an overflow. Our code assumes n is in range and does not check it. Even within that range, larger inputs take a long time because IsOdd subtracts 2 over and over. Values from 0 through 20 are good for a quick run.

**Submission:**

Project_2_Final.tar contains mips3.asm and this README. All the functions needed for the final program are in mips3.asm. Open that file by itself in MARS, since the earlier files use some of the same labels.

To update the tar file after making changes:

```sh
tar -cf Project_2_Final.tar mips3.asm README.md
```
