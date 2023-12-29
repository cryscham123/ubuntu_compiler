#include <bits/stdc++.h>

using namespace std;

typedef pair<int,int> pii;
int N,M,ans;
priority_queue<pii, vector<pii>, greater<pii>>	priority[202];
bool vis[202];

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

	cin >> N >> M;

	priority_queue<pii> pq;
	for (int i=0; i<N; i++)
	{
		int s; cin >> s;
		for (int j=0; j<s; j++)
		{
			int val; cin >> val;
			priority[val].push({s, i});
		}
	}
	for (int i=1; i<=M; i++)
		pq.push({priority[i].size(), i});
	while (!pq.empty())
	{
		auto [size, house] = pq.top(); pq.pop();
		while (!priority[house].empty())
		{
			auto [len, cow] = priority[house].top(); priority[house].pop();
			if (vis[cow])
				continue;
			vis[cow] = true;
			ans++;
			break;
		}
	}
	cout << ans;
}
