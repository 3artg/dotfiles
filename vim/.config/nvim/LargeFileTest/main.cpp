#include <bits/stdc++.h>
using namespace std;

int main() {
    ios::sync_with_stdio(false); cin.tie(0); cout.tie(0);
    int x;
    cin >> x;
    for (int i=0;i<2'000'000;++i) {
        cout << "hello this is " << i << " th result.\n";
        cout << x+i << ' ' << i*(i+1)/2 << ' ' << i*(i+1)*(2*i+1)/6 << ' ' << i*i*(i+1)*(i*1)/4 << '\n';
    }
}
