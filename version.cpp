
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>
using namespace std;

int main()
{
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int n;
    cin >> n;

    vector<int> numeros(n);

    for (int i = 0; i < n; i++)
    {
        cin >> numeros[i];
    }

    sort(numeros.begin(), numeros.end());

    for (int x : numeros)
    {
        cout << x << '\n';
    }

    return 0;
}
