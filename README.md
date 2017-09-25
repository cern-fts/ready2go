```bash
iptables -A INPUT -p tcp -m tcp --dport 2811 -j ACCEPT
iptables -A INPUT -p tcp --dport 50000:50200 -j ACCEPT
```
