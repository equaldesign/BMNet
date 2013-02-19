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
        <whitelist>flo.item.detail,bv.profile.reset,eunify.api.*,eunify.login.*,eunify.email.fastFile,eunify.company.doEdit,signup.*,eunify.calendar.register,unify.calendar.doRegister,eunify.comment.add,bugs.bugs.index,bugs.bugs.detail</whitelist>
        <securelist>eunify.*,eGroup.*,mxtra.account.*,flo.*,bv.profile.*,bugs.bugs.*</securelist>
        <roles>staff,member,view,figures,edit,admin,ebiz,viewrebate</roles>
        <permissions></permissions>
        <redirect>login.index</redirect>
    </rule>

</rules>
