#include <bits/stdc++.h>

using namespace std;

int k;
bool cmp[10];
char ans[10];

bool	solve_max(int idx, int prev, unsigned int flag)
{
	if (idx == k + 1)
		return (true);
	if (cmp[idx - 1])
		for (int c=9; c >= prev+1; c--)
		{
			if ((flag & (1 << c)) != 0)
				continue;
			ans[idx] = c + '0';
			if (solve_max(idx + 1, c, flag | (1 << c)))
				return (true);
		}
	else
		for (int c=prev-1; c >= 0; c--)
		{
			if ((flag & (1 << c)) != 0)
				continue;
			ans[idx] = c + '0';
			if (solve_max(idx + 1, c, flag | (1 << c)))
				return (true);
		}
	return (false);
}

bool	solve_min(int idx, int prev, unsigned int flag)
{
	if (idx == k + 1)
		return (true);
	if (cmp[idx - 1])
		for (int c=prev+1; c<=9; c++)
		{
			if ((flag & (1 << c)) != 0)
				continue;
			ans[idx] = c + '0';
			if (solve_min(idx + 1, c, flag | (1 << c)))
				return (true);
		}
	else
		for (int c=0; c<=prev-1; c++)
		{
			if ((flag & (1 << c)) != 0)
				continue;
			ans[idx] = c + '0';
			if (solve_min(idx + 1, c, flag | (1 << c)))
				return (true);
		}
	return (false);
}

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

	cin >> k;
	for (int i=0; i<k; i++)
	{
		char val; cin >> val;
		cmp[i] = (val == '<');
	}
	for (int c=9; c>=0; c--)
	{
		ans[0] = c + '0';
		if (solve_max(1, c, (1 << c)))
			break;
	}
	cout << ans << '\n';
	for (int c=0; c<=9; c++)
	{
		ans[0] = c + '0';
		if (solve_min(1, c, (1 << c)))
			break;
	}
	cout << ans << '\n';
}
