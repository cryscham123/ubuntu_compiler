#include <bits/stdc++.h>

using namespace std;

constexpr long long MAX=1'000'000;
vector<bool> is_prime(MAX + 1, true);
vector<long long> primes;
long long a, b;

long long cal_nono(int idx, long long n_min, long long n_max)
{
	long long zegop_num = 0;
	for (int i=0; i < idx; i++)
	{
		long long target = primes[i] * primes[i];
		if (target > n_max)
			break ;
		long long min_num = (n_min / target) - (n_min % target == 0);
		long long max_num = (n_max / target);
		zegop_num += (max_num - min_num) - cal_nono(i, min_num + 1, max_num);
	}
	return (zegop_num);
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

	
	is_prime[0] = is_prime[1] = false;
	for (long long i=2; i<=MAX; i++)
		if (is_prime[i])
		{
			primes.push_back(i);
			for (long long j=i*i; j<=MAX; j+=i)
				is_prime[j] = false;
		}
	cin >> a >> b;
	cout << b - a + 1 - cal_nono(primes.size(), a, b);
}
