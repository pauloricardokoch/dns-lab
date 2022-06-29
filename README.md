# DNS.
Domain Name Service is used for name resolution, returns IP addresses for FQDNs (Fully Qualified Domain Name). 

Isolates (minimize) the effects of changing IP addresses.

Reverse name resolution, returns the FQDNs for IP addresses.

# Top level domains.
gov, net, com, org, mil, edu, arpa, br ...

# Domain structure.
Root domain -> root servers

Top level domains -> org, com, net, br, us, arpa ...

Second level domains -> google, yahoo ... (www, mail, download)


# DNS namespace.
Generic top level domains (gTLs) -> edu, gov, org ...

Country code top level domains (ccTLDs) -> us, br, pt ...

arpa -> used for reverse resolution.

# DNS zone.
A DNS zone is a portion of the DNS namespace that is managed by a specific organization or administrator. A DNS zone is an administrative space, which allows for more granular control of DNS components, such as authoritative nameservers. The domain name space is a hierarchical tree, with the DNS root domain at the top.

# DNS server types.
- Master: get zone data from locally stored files. Usually one master server for a zone. All changes are made in master servers.

- Slave: get mirror zone data from master servers through zone transfer. They are read only. Checks periodically for updates in master servers (as specified in SOA record)

- Caching only: do not have any data in zone files. Simply accept request and forward them. Keep results in cache. 

# Types of queries. 
## Iterative query.
```
resolver -> local 

            <- contact root server 

resolver -> root

            <- contact top level

resolver -> top level

            <- contact second level

resolver -> second level
  
            <- return ip address
```
More load on the resolvers.


## Recursive query.
```
resolver <-> local NS

                 <-> root

                         <-> top level

                                 <-> second level
```
Adds load on top level domain servers.

## Hybrid query.
```
resolver <-> local NS

                 -> root

                        <- contact top level

                 -> top level

                        <-  contact second level

                 -> second level

                        <- return ip address
```

# Master configuration.

```bash
$ cat /etc/named.conf

acl "masterserver" { 172.24.0.0/16 };

options {
    listen-on port 53 { 127.0.0.1; 172.24.0.10 };
    listen-on-v6 port 53 { ::1; };
    // all paths defined in this file are relative to directory
    directory 	"/var/named";
    dump-file 	"/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    secroots-file	"/var/named/data/named.secroots";
    recursing-file	"/var/named/data/named.recursing";
    // hosts that can query the DNS server
    allow-query     { localhost; masterserver };
    // host that can get data from the DNS server, default is any host
    allow-transfer  { localhost; masterserver };
    recursion yes;
};


zone "example.com" IN {
    type master;
    file "forward";
};


zone "0.24.172.in-addr-arpa" IN {
    type master;
    file "reverse";
};

```

```bash
$ cat /var/named/forward

@       IN SOA  master.example.com. root.example.com. (
                                        2022062901      ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
                IN      NS              master
                IN      MX      10      master
master          IN      A               172.24.0.10
www             IN      CNAME           master
download        IN      CNAME           master
mail            IN      CNAME           master
smtp            IN      CNAME           master
imap            IN      CNAME           master
pop             IN      CNAME           master
```

```bash
$ cat /var/named/reverse

@       IN SOA  master.example.com. root.example.com. (
                                        2022062901      ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
                IN      NS              master.example.com.
10              IN      PTR             master.example.com.    
```

```bash
$ cat /etc/resolv.conf 

search example.com
nameserver 172.24.0.10
```

# Slave configuration.

# Client configuration.
