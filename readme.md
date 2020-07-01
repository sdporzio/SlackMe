# Usage

```
log ./myscript.sh
```
in order to save the full log of a script

or

```
somecommand; sme
```
to execute an arbitrary command and be notified at the end of it.

---

# Installation

In order to configure it, create a `conf/slackMe.conf` file, using `conf/example_slackMe.conf` as an example and replacing the env variables there with your channel name, username, and slack webhook.

To use it, do`source setup.sh`, but you will have to do that each time you start a new session.
Otherwise you can head over to your `.bash_profile` and append at the end of it:
```
source PATHTOYOURSLACKMEDIR/setup.sh
```
This will ensure it is sourced with each new session.


After that you can head to `test/` and run:
```
log ./testMe.sh
```
to make sure everything's running properly.