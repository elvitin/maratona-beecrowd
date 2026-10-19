#include <iostream>

int main()
{
    if (__cplusplus == 202600L)
        std::cout << "C++26\n"; // Approximate value for preview
    else if (__cplusplus == 202302L)
        std::cout << "C++23\n";
    else if (__cplusplus == 202002L)
        std::cout << "C++20\n";
    else if (__cplusplus == 201703L)
        std::cout << "C++17\n";
    else if (__cplusplus == 201402L)
        std::cout << "C++14\n";
    else if (__cplusplus == 201103L)
        std::cout << "C++11\n";
    else if (__cplusplus == 199711L)
        std::cout << "C++98\n";
    else
        std::cout << "Pre-standard C++ or custom configuration: " << __cplusplus << "\n";
    return 0;
}
