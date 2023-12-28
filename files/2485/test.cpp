#include <bits/stdc++.h>

using namespace std;

int N, ans;

int ft_gcd(int a, int b)
{
	if (b == 0)
		return (a);
	return (ft_gcd(b, a % b));
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

	cin >> N;
	int prev, gcd = 0;
	vector<int> diff;
	cin >> prev;
	for (int i=1; i<N; i++)
	{
		int val; cin >> val;
		diff.push_back(val - prev);
		gcd = ft_gcd(diff.back(), gcd);
		prev = val;
	}
	for (auto e:diff)
		ans += (e / gcd) - 1;
	cout << ans;
}
