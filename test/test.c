int summ(int n) {
    int res = 1;
    for(int i = 2; i <= n; i++) {
        res = res + i;
    }
    return res;
}

int main() {
    int n = 0xFFF;
    int res = summ(n);

    asm("ecall");
    return res;
}