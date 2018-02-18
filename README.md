# langstats
An implementation of the Skroutz software engineering assignment.

Note: this is my first time writing Ruby

## Usage
The simplest usage of the `langstats` app would be:

```sh
$ ruby bin/langstats_cli.rb -o skroutz
```

This produces an unauthenticated request to GitHub and, as a result, could suffer from GitHub's [limit in API calls](https://developer.github.com/v3/#rate-limiting).

Alternatively, the authenticated version using one's GitHub credentials would be:

```sh
$ ruby bin/langstats_cli.rb -o skroutz -u papiomytoglou:totallymypassword
```

The help is produced using the `-h` switch:

```sh
$ ruby bin/langstats_cli.rb -h
Usage: langstats_cli.rb -o ORGANIZATION [-u USER[:PASSWORD]]
    -o, --organization ORGANIZATION  The name of the organization
    -u, --user USER[:PASSWORD]       Data source user and password
    -h, --help                       Print this help
```

## Output Example

```sh
$ ruby bin/langstats_cli.rb -o google -u papiomytoglou:thistimeitsreal
{
  "organization": google,
  "languages": {
    "Ruby": 56.09,
    "C++": 18.8,
    "JavaScript": 18.28,
    "Java": 2.9,
    "C": 1.82,
    "CSS": 0.89,
    "Python": 0.69,
    "HTML": 0.15,
    "Ragel": 0.07,
    "Shell": 0.06,
    "Protocol Buffer": 0.06,
    "Dart": 0.06,
    "Lua": 0.04,
    "Makefile": 0.04,
    "Go": 0.02,
    "PHP": 0.01,
    "LiveScript": 0.01,
    "M4": 0.0,
    "Batchfile": 0.0,
    "XSLT": 0.0
  }
}
```

