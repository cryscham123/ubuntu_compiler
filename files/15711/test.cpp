#include <bits/stdc++.h>

using namespace std;

constexpr long long MAX=2'000'000;
int T;
vector<bool> is_prime(MAX + 1, true);
vector<long long> primes;

bool check_prime(long long target)
{
	if (target <= MAX)
		return (is_prime[target]);
	for (auto e:primes)
	{
		if (e * e > target)
			break;
		if ((target % e) == 0)
			return (false);
	}
	return (true);
}

bool is_zzak(long long total)
{
	if (total <= 2)
		return (false);
	if (!(total & 1))
		return (true);
	return (check_prime(total - 2));
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

	is_prime[1] = false;
	for (long long i=3; i*i<=MAX; i+=2)
		if (is_prime[i])
		{
			primes.push_back(i);
			for (long long j=i*i; j<=MAX; j+=i)
				is_prime[j] = false;
		}
	cin >> T;
	while (T--)
	{
		long long a,b; cin >> a >> b;
		is_zzak(a + b) ? cout << "YES\n" : cout << "NO\n";
	}
}
