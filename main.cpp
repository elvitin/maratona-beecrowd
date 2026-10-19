#include <iostream>
using namespace std;

int main()
{
  ios::sync_with_stdio(false);
  cin.tie(nullptr);

  int primeiroNumero, segundoNumero;

  while (cin >> primeiroNumero >> segundoNumero)
  {
    cout << primeiroNumero + segundoNumero << '\n';
  }

  return 0;
}
