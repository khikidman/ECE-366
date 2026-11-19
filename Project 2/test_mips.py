"""Check the project programs in MARS 4.5: python3 test_mips.py /path/to/Mars4_5.jar."""

import argparse
from pathlib import Path
import re
import subprocess
import tempfile


ROOT = Path(__file__).resolve().parent


def run_mars(jar, source, *options):
    run = subprocess.run(
        ["java", "-jar", str(jar), "nc", "me", "ae1", "se2", *options, str(source)],
        capture_output=True, text=True, timeout=60, check=True,
    )
    if "Error" in run.stderr or "maximum step limit" in run.stderr.lower():
        raise AssertionError(run.stderr)
    return run


def check_main(jar, temp, filename, label, value, expected, output):
    source = (ROOT / filename).read_text()
    source, count = re.subn(
        rf"(?m)^({label}:\s*\.word\s+)\d+", rf"\g<1>{value}", source, count=1
    )
    assert count == 1, f"Missing input label in {filename}"
    path = temp / filename
    path.write_text(source)
    run = run_mars(jar, path, "dec", "0x10010000-0x10010004")
    assert run.stdout.strip() == output, (filename, value, run.stdout)
    memory = re.search(r"Mem\[0x10010000\]\s+(-?\d+)\s+(-?\d+)", run.stderr)
    assert memory and tuple(map(int, memory.groups())) == (value, expected), run.stderr


def check_functions(jar, temp):
    source = (ROOT / "mips3.asm").read_text()
    routines = source[source.index("IsFibonacciOdd:"):]
    cases = []
    for n, expected in [(0, 0), (1, 1), (2, 1), (10, 55), (45, 1134903170), (46, 1836311903)]:
        cases.append(("fibonacci", n, 2, expected, None))
    for m in [0, 1, 2, 3, 12, 13, 100, 101]:
        cases.append(("IsOdd", m, 2, m % 2, None))
    for x, y in [(0, 2), (1, 2), (2, 2), (13, 2), (14, 2), (17, 5), (4, 9), (9, 1)]:
        cases.append(("division", x, y, x % y, x // y))
    for n in [0, 1, 2, 3, 4, 5, 6, 10, 13, 20, 25, 30]:
        # Fibonacci parity repeats 0, 1, 1, independently of the assembly algorithm.
        cases.append(("IsFibonacciOdd", n, 2, int(n % 3 != 0), None))

    main = [".data", 'nl: .asciiz "\\n"', ".text", ".globl main", "main:"]
    expected_lines = []

    def print_register(register, expected):
        main.extend([f"move $a0, {register}", "li $v0, 1", "syscall",
                     "la $a0, nl", "li $v0, 4", "syscall"])
        expected_lines.append(str(expected))

    for function, a0, a1, expected, quotient in cases:
        main.extend(["move $s0, $sp", "li $s1, 123456", f"li $a0, {a0}",
                     f"li $a1, {a1}", f"jal {function}"])
        print_register("$v0", expected)
        if quotient is not None:
            print_register("$v1", quotient)
        main.extend(["xor $t5, $sp, $s0", "sltiu $t5, $t5, 1"])
        print_register("$t5", 1)
        print_register("$s1", 123456)
    main.extend(["li $v0, 10", "syscall", routines])
    path = temp / "functions.asm"
    path.write_text("\n".join(main))
    run = run_mars(jar, path)
    assert run.stdout.splitlines() == expected_lines, run.stdout + run.stderr
    return len(cases)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("mars_jar", type=Path)
    args = parser.parse_args()
    jar = args.mars_jar.expanduser().resolve()
    if not jar.is_file():
        parser.error(f"MARS jar not found: {jar}")
    with tempfile.TemporaryDirectory(prefix="ece366-mips-") as directory:
        temp = Path(directory)
        check_main(jar, temp, "mips1.asm", "n", 45, 1134903170, "1134903170")
        check_main(jar, temp, "mips2.asm", "m", 13, 1, "IsOdd(m) = 1")
        for n, expected in [(0, 0), (1, 1), (2, 1), (3, 0), (6, 0), (10, 1), (13, 1), (20, 1)]:
            check_main(jar, temp, "mips3.asm", "n", n, expected,
                       f"IsFibonacciOdd(n) = {expected}")
        count = check_functions(jar, temp)
    print(f"PASS: 10 program runs and {count} function cases in MARS 4.5.")
    print("Verified printed results, input/result memory, remainders, quotients, and stack restoration.")


if __name__ == "__main__":
    main()
