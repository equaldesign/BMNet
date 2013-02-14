<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
Declare as many rule elements as you want, order is important
Remember that the securelist can contain a list of regular
expression if you want

ex: All events in the user handler
 user\..*
ex: All events
 .*
ex: All events that start with admin
 ^admin

If you are not using regular expression, just write the text
that can be found in an event.
-->
<rules>
    <rule>
        <whitelist>general\.index,login\.*</whitelist>
        <securelist>.*</securelist>
        <roles>view,figures,edit,admin,ebiz,viewrebate</roles>
        <permissions></permissions>
        <redirect>login.index</redirect>
    </rule>
</rules>
