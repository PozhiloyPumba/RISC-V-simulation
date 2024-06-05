int main() {
    int n = 1231;
    int res = 0;
    for(int i = 1; i <= n; i++) {
        res = res + i;
    }
    // asm("ecall");
    return res;
}