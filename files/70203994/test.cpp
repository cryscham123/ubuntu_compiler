#include <bits/stdc++.h>

using namespace std;

int priority[255];

int main()
{
    ios::sync_with_stdio(0);
    cin.tie(0);

    stack<char> st;
    string s, result = "";
    cin >> s;
    priority['('] = priority[')'] = 0;
    priority['+'] = priority['-'] = 1;
    priority['*'] = priority['/'] = 2;
    for (char e:s)
        switch (e)
        {
			case ')':
				while (st.top() != '(')
					result += st.top(), st.pop();
				st.pop();
				break;
			case '+':
			case '-':
			case '*':
			case '/':
                while (!st.empty() && priority[st.top()] >= priority[e])
                    result += st.top(), st.pop();
				[[fallthrough]];
			case '(':
                st.push(e);
				break;
			default:
				result += e;
        }
    while (!st.empty())
        result += st.top(), st.pop();
    cout << result;
}
