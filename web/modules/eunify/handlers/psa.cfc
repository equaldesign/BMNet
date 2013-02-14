<cfcomponent name="psaHandler" cache="true" output="false">
  <!------------------------------------------- PUBLIC EVENTS ------------------------------------------>
  <!--- Default Action --->
  <cfproperty name="psa" inject="id:eunify.PSAService" />
  <cfproperty name="groups" inject="id:eunify.GroupsService" />
  <cfproperty name="figures" inject="id:eunify.FiguresService" />
  <cfproperty name="blog" inject="id:eunify.BlogService" />
  <cfproperty name="company" inject="id:eunify.CompanyService" />
  <cfproperty name="dms" inject="id:eunify.DocumentService" />
  <cfproperty name="UserStorage" inject="coldbox:myPlugin:UserStorage" />
  <cfproperty name="BeanFactory" inject="coldbox:plugin:BeanFactory" />
  <cfproperty name="dsn" inject="coldbox:datasource:BMNet" />
  <cfproperty name="CookieStorage" inject="coldbox:plugin:CookieStorage" />
  <cfproperty name="feed" inject="id:eunify.FeedService" />


  <!--- Public Events --->

  <cffunction name="addChain" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue('psaid',0)>
    <cfset rc.chainDealID = arguments.event.getValue('chainDealID',0)>
    <Cfset rc.chains = psa.addDealChain(rc.psaID,rc.chainDealID)>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("psa/panel/edit/chainList")>
  </cffunction>

  <cffunction name="addStep" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
          var rc = arguments.event.getCollection();
          rc.psaID = arguments.event.getValue("psaID","");
          rc.id = fixunder(arguments.event.getValue("rebateID",""));
          rc.value_from = numO(arguments.event.getValue("from",0));
          rc.value_to = numO(arguments.event.getValue("to",0));
          rc.value_value = numO(arguments.event.getValue("value",0));
          rc.psa = psa.getPSA(rc.psaID);
          rc.psaXML = XMLParse(rc.psa.dealData);
          rc.element = psa.getElementByID(rc.id,rc.psaXML)[1];
          if (NOT isDefined('rc.element.step')) {
            rc.element.step = XmlElemNew(rc.psaXML, "step");
            rc.step  = rc.element.step;
          } else {
            rc.steps = ArrayLen(rc.element.step);
            ArrayAppend(rc.element.xmlChildren,XmlElemNew(rc.psaXML, "step"));
            rc.step = rc.element.step[rc.steps+1];
          }
          rc.step.from = XmlElemNew(rc.psaXML,"from");
          rc.step.from.xmlText = rc.value_from;
          rc.step.to = XmlElemNew(rc.psaXML,"to");
          rc.step.to.xmlText = rc.value_to;
          rc.step.value = XmlElemNew(rc.psaXML,"value");
          rc.step.value.xmlText = rc.value_value;
          rc.psaObject = BeanFactory.populateFromQuery("psa",rc.psa);
          rc.psaObject.setdealData(toString(rc.psaXML));
          rc.psaObject.save();

          </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('psa/element/edit/newstep')>
  </cffunction>

  <cffunction name="cloneDeal" returntype="void" output="false" hint="My main event">
    <cfargument name="event">
    <cfscript>
      var rc = arguments.event.getCollection();
      rc.oldID = arguments.event.getValue('psaid',0);
      rc.psaID = psa.cloneArrangement(rc.oldID);
      setNextEvent(uri="/psa/index/psaID/#rc.psaID#");
    </cfscript>
  </cffunction>

  <cffunction name="cloneElement" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset rc.elementID = fixunder(arguments.event.getValue("id",0))>
    <cfscript>
      rc.psa = psa.getPSA(rc.psaID);
      rc.xml = xmlParse(rc.psa.dealData);
      rc.e = psa.getElementByID(rc.elementID,rc.xml);
      rc.element = rc.e[1];
      rc.s = rc.element.xmlParent;
      try {
          rc.lastElementID = rc.s.xmlChildren[ArrayLen(rc.s.xmlChildren)].id.xmlText;
          rc.x = ListToArray(rc.lastElementID,".");
          rc.x[ArrayLen(rc.x)]++;
          rc.newID = ArrayToList(rc.x,".");
        } catch (Any e) {
          rc.newID = "";
        }
      ArrayAppend(rc.s.xmlChildren,rc.element);
      rc.s.xmlChildren[ArrayLen(rc.s.xmlChildren)].id.xmlText = rc.newID;
      rc.component =  rc.s.xmlChildren[ArrayLen(rc.s.xmlChildren)];
      rc.component.XmlAttributes.editable = "true";
      rc.psaObject = BeanFactory.populateFromQuery("psa",rc.psa);
      rc.psaObject.setdealData(toString(rc.xml));
      rc.psaObject.save();

    </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
   <cfset arguments.event.setView('psa/element/edit/component')>
  </cffunction>

  <cffunction name="createElement" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaID","");
        rc.index = arguments.event.getValue("index","9.99");
        rc.psa = psa.getPSA(rc.psaID);
        rc.type = arguments.event.getValue("type","");
        rc.cgroup = arguments.event.getValue("group","");
        rc.fe = psa.getFiguresEntryElements(rc.psaID);
        rc.xml = xmlparse(rc.psa.dealData);
        try {
          rc.lastElementID = rc.xml.arrangement[rc.cgroup].xmlChildren[ArrayLen(rc.xml.arrangement[rc.cgroup].xmlChildren)].id.xmlText;
          rc.x = ListToArray(rc.lastElementID,".");
          rc.x[ArrayLen(rc.x)]++;
          rc.newID = ArrayToList(rc.x,".");
        } catch (Any e) {
          rc.newID = "";
        }
        rc.element = XmlElemNew(rc.xml, "component");
        rc.element.xmlAttributes["type"] = "#rc.type#";
        rc.element.xmlAttributes["editable"] = "true";
        rc.element["id"] = XmlElemNew(rc.xml,"id");
        rc.element.id.xmlText = rc.newID;
        rc.funct = "add";
        rc.inputStreams ="";
        rc.outputStreams = "";
        rc.groups = groups;
        rc.deals = psa.GETARRANGEMENTBYSUPPLIER(rc.psa.company_id);
        rc.memberList = company.getMembers();
        </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('psa/element/edit/#rc.type#')>
  </cffunction>

  <cffunction name="createPSA" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = psa.getDealTemplate()>
    <cfset setNextEvent(uri="/psa/index/psaID/#rc.psaID#")>
  </cffunction>

  <cffunction name="dealnotification" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset arguments.event.setLayout('Layout.Main')>
    <cfset arguments.event.setView('psa/dealnotification')>
  </cffunction>

  <cffunction name="delete" returntype="void" output="false">
   <cfargument name="event">

   <cfset var rc = arguments.event.getCollection()>
   <cfset rc.psaID = arguments.event.getValue("psaID",0)>
   <cfset psa.deleteArrangement(rc.psaID)>
   <cfset setNextEvent(uri="/")>
  </cffunction>

  <cffunction name="deleteElement" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaID","");
        rc.psa = psa.getPSA(rc.psaID);
        rc.psaXML = XMLParse(rc.psa.dealData);
        rc.id = fixunder(arguments.event.getValue("rebateID",""));
        rc.element = psa.getElementByID(rc.id,rc.psaXML)[1];
        ArrayClear(rc.element);
        rc.psaObject = BeanFactory.populateFromQuery("psa",rc.psa);
        rc.psaObject.setdealData(toString(rc.psaXML));
        rc.psaObject.save();
        </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="deleteFiguresElement" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.inputStreamID = arguments.event.getValue('inputStreamID',0)>
    <Cfset rc.fe = psa.deleteFiguresEntry(rc.inputStreamID)>
    <cfset rc.json = StructNew()>
    <cfset rc.json = serializeJSON(rc.json)>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("renderJSON")>
  </cffunction>

  <cffunction name="deleteStep" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaID","");
        rc.psa = psa.getPSA(rc.psaID);
        rc.psaXML = XMLParse(rc.psa.dealData);
        rc.id = fixunder(arguments.event.getValue("rebateID",""));
        rc.stepA = arguments.event.getValue("step","");
        rc.element = psa.getElementByID(rc.id,rc.psaXML)[1];
        arrayDeleteAt(rc.element.step,rc.stepA);
        rc.psaObject = BeanFactory.populateFromQuery("psa",rc.psa);
        rc.psaObject.setdealData(toString(rc.psaXML));
        rc.psaObject.save();
        </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="edit" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.id = arguments.event.getValue('psaid',0);
        rc.memberID = arguments.event.getValue("memberID",0);
        rc.psa = BeanFactory.populateFromQuery("psa",psa.getPSA(rc.id));
        rc.psa = populateModel(rc.psa);
        rc.psa.save();
        arguments.event.setView("debug");
        subscriptions.add(rc.id,"arrangement",rc.sess.eGroup.contactID,arguments.event.getValue("notify",false));
        rc.tagService.add(tags=event.getValue("newTags",""),relationShip="arrangement",id=rc.id);
        setNextEvent(uri="/psa/index/psaID/#rc.id#");
    </cfscript>
  </cffunction>

  <cffunction name="editElement" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaID","");
        rc.index = fixunder(arguments.event.getValue("index",""));
        rc.psa = psa.getPSA(rc.psaID);
        rc.psaOb = psa;
        rc.fe = psa.getFiguresEntryElements(rc.psaID);
        rc.cgroup = arguments.event.getValue("group","");
        rc.xml = xmlParse(rc.psa.dealData);
        rc.e = psa.getElementByID(rc.index,rc.xml);
        rc.element = rc.e[1];
        rc.inputStreams ="";
        rc.funct = "edit";
        rc.outputStreams = "";
        if (isDefined('rc.elementToModify.inputSources')) {
         rc.inputStreams = rc.elementToModify.inputSources.xmlAttributes.id;
        }
        if (isDefined('rc.elementToModify.outputSources')) {
         rc.outputStreams = rc.elementToModify.outputSources.xmlAttributes.id;
        }
        rc.groups = groups;
        rc.deals = psa.GETARRANGEMENTBYSUPPLIER(rc.psa.company_id);
        rc.memberList = company.getMembers();
        </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
   <cfset arguments.event.setView('psa/element/edit/#rc.element.XmlAttributes.type#')>
  </cffunction>

  <cffunction name="editElementDo" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      var element = "";
    </cfscript>
      <cfscript>
        rc.psaID = arguments.event.getValue("psaID",0);
        rc.psa = psa.getPSA(rc.psaID);
        rc.funct = arguments.event.getValue("funct","add");
        rc.targetID = arguments.event.getValue("targetID",0);
        rc.targetElements = arguments.event.getValue("targetElements",0);
        rc.growthDateFrom = arguments.event.getValue("growthDateFrom","");
        rc.growthDateTo = arguments.event.getValue("growthDateTo","");
        rc.targetName = arguments.event.getValue("targetName","");
        rc.index = fixunder(arguments.event.getValue("index","9.99"));
        rc.calculate = arguments.event.getValue('calculate','false');
        rc.enterfigures = arguments.event.getValue('enterfigures','false');
        rc.cid = arguments.event.getValue('cid',0);
        rc.ctitle = arguments.event.getValue('ctitle','');
        rc.ftitle = arguments.event.getValue('ftitle','');
        rc.ctype = arguments.event.getValue('ctype','');
        rc.cgroup = arguments.event.getValue('cgroup','');
        rc.details = arguments.event.getValue('details','');
        rc.FUNCT = arguments.event.getValue('FUNCT','');
        rc.OUTPUTTYPE = arguments.event.getValue('OUTPUTTYPE','6');
        rc.inputtype = arguments.event.getValue('inputtype','');
        rc.PERIOD = arguments.event.getValue('paymentperiod','');
        rc.PERMISSIONS = arguments.event.getValue('PERMISSIONS','');
        rc.inputSources = arguments.event.getValue("inputSource","");
        rc.outputSources = arguments.event.getValue("outputSource","false");
        rc.catchup = arguments.event.getValue("catchup","");
        rc.PSAID = arguments.event.getValue('PSAID','');
        rc.rebatevalue = arguments.event.getValue('value','');
        rc.TOTALTURNOVER = arguments.event.getValue('TOTALTURNOVER','');
        rc.STEPS = arguments.event.getValue('STEPS','');
        rc.ARRAYINDEX = arguments.event.getValue('ARRAYINDEX','');
        rc.inheritFrom = arguments.event.getValue('inheritFrom',0);
        rc.payableTo = arguments.event.getValue("payableTo","group");
        rc.compoundAgainst = arguments.event.getValue('compoundAgainst',0);
        rc.compound = arguments.event.getValue('compound','');
        rc.strung = arguments.event.getValue('strung',"false");
        rc.strungAgainst = arguments.event.getValue('strungAgainst',"false");
        rc.nonretrospective = arguments.event.getValue('nonretrospective','false');
        rc.dateRange = arguments.event.getValue('dateRange','false');
        rc.memberRestrictions = arguments.event.getValue('memberRestrictions','false');
        rc.membersParticipating = arguments.event.getValue('membersParticipating','');
        rc.dateFrom = arguments.event.getValue('dateFrom','');
        rc.dateTo = arguments.event.getValue('dateTo','');

        // Reminders
        if (rc.cType eq "reminder") {
          rc.reminderDate = LSParseDateTime(arguments.event.getValue('reminderDate',DateAdd('m',1,now())));
          rc.emailreminder = arguments.event.getValue('emailreminder','false');
          rc.sendreminderto = arguments.event.getValue('sendreminderto','');
        }
        // End Reminders
        if (rc.dateFrom eq "") {
         rc.dateFrom = rc.psa.period_from;
        } else {
         rc.dateFrom = LSParseDateTime(rc.dateFrom);
        }
        if (rc.dateTo eq "") {
         rc.dateTo = rc.psa.period_to;
        } else {
         rc.dateTo = LSParseDateTime(rc.dateTo);
        }
        rc.IndividualGrowthSupplierList = arguments.event.getValue('IndividualGrowthSupplierList','');
        rc.TopHatSupplierList = arguments.event.getValue('TopHatSupplierList','');
        rc.GroupGrowthSupplierList = arguments.event.getValue('GroupGrowthSupplierList','');
        rc.rebateType = arguments.event.getValue('rebateType','');
        rc.selftarget = arguments.event.getValue('selftarget','true');
        rc.inheritTargetsFrom = arguments.event.getValue('inheritTargetsFrom',0);
        rc.xmlDoc = XMLParse(rc.psa.dealData);
        rc.e = psa.getElementByID(rc.index,rc.xmlDoc);

        if (rc.funct eq "add") {
          // we're inserting one!
          ArrayAppend(rc.xmlDoc.arrangement[rc.cgroup].xmlChildren,XmlElemNew(rc.xmlDoc, "component"));
          element = rc.xmlDoc.arrangement[rc.cgroup].xmlChildren[ArrayLen(rc.xmlDoc.arrangement[rc.cgroup].xmlChildren)];
          element.xmlAttributes.type = "#rc.cType#";

        } else {
           element = rc.e[1];
        }

         if (rc.funct eq "add") {
          element.id = XmlElemNew(rc.xmlDoc, "id");
         }
         element.id.xmlText = rc.cid;
        if (rc.funct eq "add") {
          element.title = XmlElemNew(rc.xmlDoc, "title");
         }
         element.title.xmlText = rc.ctitle;
          if (NOT isDefined('element.details')) {
              element.details = XmlElemNew(rc.xmlDoc,"details");
          }
          element.details.xmlText = rc.details;
          element.xmlAttributes.permissions = "#rc.permissions#";
          if (rc.cType eq "rebate") {
            if (NOT isDefined('element.inputSources')) {
              element.inputSources = XmlElemNew(rc.xmlDoc, "inputSources");
            }
            if (NOT isDefined('element.outputSources')) {
              element.outputSources = XmlElemNew(rc.xmlDoc, "outputSources");
            }
            element.inputSources.xmlAttributes["id"] = rc.inputSources;
            element.outputSources.xmlAttributes["id"] = rc.outputSources;
            if (NOT isDefined('element.payableTo')) {
              element.payableTo = XmlElemNew(rc.xmlDoc, "payableTo");
            }
            element.payableTo.xmlText = rc.payableTo;
            if (NOT isDefined('element.dateRange')) {
              element.dateRange = XmlElemNew(rc.xmlDoc, "dateRange");
            }
            element.dateRange.xmlText = rc.dateRange;
            element.dateRange.XmlAttributes.dateFrom = rc.dateFrom;
            element.dateRange.XmlAttributes.dateTo = rc.dateTo;
            if (NOT isDefined('element.memberRestrictions')) {
              element.memberRestrictions = XmlElemNew(rc.xmlDoc,"memberRestrictions");
            }
            element.memberRestrictions.xmlText = rc.memberRestrictions;
            element.memberRestrictions.XmlAttributes.membersParticipating = rc.membersParticipating;
            if (NOT isDefined('element.nonretrospective')) {
              element.nonretrospective = XmlElemNew(rc.xmlDoc,"nonretrospective");
            }
            element.nonretrospective.xmlText = rc.nonretrospective;

            if (NOT isDefined('element.catchup')) {
              element.catchup = XmlElemNew(rc.xmlDoc,"catchup");
            }
            element.catchup.xmlText = rc.catchup;

            if (NOT isDefined('element.compound')) {
              element.compound = XmlElemNew(rc.xmlDoc,"compound");
            }
            element.compound.xmlText = rc.compound;
            element.compound.XmlAttributes.compoundAgainst = rc.compoundAgainst;
            if (NOT isDefined('element.strung')) {
              element.strung = XmlElemNew(rc.xmlDoc,"strung");
            }
            element.strung.xmlText = rc.strung;
            element.strung.XmlAttributes.strungAgainst = rc.strungAgainst;
            if (NOT isDefined('element.selftarget')) {
              element.selftarget = XmlElemNew(rc.xmlDoc, "selftarget");
              WriteOutput("true - no title");
            }
            element.selftarget.XmlText = rc.selftarget; // not sure if we really need this anymore!?
            element.selftarget.XmlAttributes.inheritTargetsFrom = rc.inheritTargetsFrom;
            if (NOT isDefined('element.outputtype')) {
              element.outputtype = XmlElemNew(rc.xmlDoc, "outputtype");
            }
            element.outputtype.xmlText = rc.outputtype;
            if (NOT isDefined('element.inputtype')) {
              element.inputtype = XmlElemNew(rc.xmlDoc, "inputtype");
            }
            if (ListLen(rc.inputSources) gte 1) {
              element.inputtype.xmlText = psa.getFiguresEntryElement(ListGetAt(rc.inputSources,1)).inputTypeID;
            }
            if (NOT isDefined('element.value')) {
              element.value = XmlElemNew(rc.xmlDoc, "value");
            }
            element.value.xmlText = rc.rebatevalue;
            if (NOT isDefined('element.calculate')) {
              element.calculate = XmlElemNew(rc.xmlDoc, "calculate");
            }
            element.calculate.xmlText = rc.calculate;
            if (NOT isDefined('element.enterfigures')) {
              element.enterfigures = XmlElemNew(rc.xmlDoc, "enterfigures");
            }
            if (NOT isDefined('element.rebateType')) {
              element.rebateType = XmlElemNew(rc.xmlDoc, "rebateType");
            }
            element.rebateType.xmlAttributes.name = rc.rebateType;
            if (NOT isDefined('element.rebateType.target')) {
              element.rebateType.target = XmlElemNew(rc.xmlDoc, "target");
            }
            element.rebateType.target.xmlAttributes["id"] = rc.targetID;
            element.rebateType.target.xmlAttributes["name"] = rc.targetName;
            element.rebateType.target.xmlAttributes["figures"] = rc.targetElements;
            element.rebateType.target.xmlAttributes["dateFrom"] = rc.growthDateFrom;
            element.rebateType.target.xmlAttributes["dateTo"] = rc.growthDateTo;
            if (rc.rebateType eq "topHat") {
              element.rebateType.XmlAttributes.id = rc.TopHatSupplierList;
            } else if (rc.rebateType eq "individualGrowth") {
              element.rebateType.XmlAttributes.id = rc.IndividualGrowthSupplierList;
            } else if (rc.rebateType eq "groupGrowth") {
              element.rebateType.XmlAttributes.id = rc.GroupGrowthSupplierList;
            } else {
              element.rebateType.XmlAttributes.id = 0;
            }
            if (NOT isDefined('element.period')) {
              element.period = XmlElemNew(rc.xmlDoc, "period");
            }
            if (rc.period neq "") {
              element.period.xmlText = rc.period;
            }
            if (NOT isDefined('element.totalturnover')) {
              element.totalturnover = XmlElemNew(rc.xmlDoc, "totalturnover");
            }
            element.totalturnover.xmlText = rc.totalturnover;
          } else if (rc.cType eq "reminder") {
            if (NOT isDefined('element.reminder')) {
              element.reminder = XmlElemNew(rc.xmlDoc, "reminder");
            }
            element.reminder.xmlAttributes["reminderDate"] = rc.reminderDate;
            element.reminder.xmlAttributes["emailreminder"] = rc.emailreminder;
            element.reminder.xmlAttributes["sendreminderto"] = rc.sendreminderto;
          }
          rc.psaObject = BeanFactory.populateFromQuery("psa",rc.psa);
          rc.psaObject.setdealData(toString(rc.xmlDoc));
          rc.psaObject.save();
        </cfscript>

        <cfset rc.component = element>
        <cfset rc.componentType = rc.cType>
        <cfset rc.componentIndex = rc.cid>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('psa/element/edit/newElement')>
  </cffunction>

  <cffunction name="editMode" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        var e = arguments.event.getValue("e","");
        var eGroup = UserStorage.getVar("eGroup");
        if (e eq "on") {
          eGroup.editMode = false;
        } else {
          eGroup.editMode = true;
        }
        UserStorage.setVar("eGroup",eGroup);
    </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('blank')>
  </cffunction>

  <cffunction name="editStep" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaID","");
        rc.id = fixunder(arguments.event.getValue("rebateID",""));
        rc.value_from = numO(arguments.event.getValue("from",0));
        rc.value_to = numO(arguments.event.getValue("to",0));
        rc.value_value = numO(arguments.event.getValue("value",0));
        rc.stepA = arguments.event.getValue("step","");
        rc.psa = psa.getPSA(rc.psaID);
        rc.psaXML = XMLParse(rc.psa.dealData);
        rc.element = psa.getElementByID(rc.id,rc.psaXML)[1];
          rc.step = rc.element.step[rc.stepA];
          rc.step.from.xmlText = rc.value_from;
          rc.step.to.xmlText = rc.value_to;
          rc.step.value.xmlText = rc.value_value;
          rc.psaObject = BeanFactory.populateFromQuery("psa",rc.psa);
          rc.psaObject.setdealData(toString(rc.psaXML));
          rc.psaObject.save();

        rc.jsonObject = StructNew();
        rc.jsonObject["from"] = numberFormatIfNumber(rc.value_from,"999,999,999,999.99");
        rc.jsonObject["to"] = numberFormatIfNumber(rc.value_to,"999,999,999,999.99");
        rc.jsonObject["value"] = rc.value_value;
        rc.json = SerializeJSON(rc.jsonObject);
        </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('renderJSON')>
  </cffunction>

  <cffunction name="emailDeal" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
                var rc = arguments.event.getCollection();
                rc.psaID = arguments.event.getValue("psaid","");
                rc.panelData = psa.panelData("overview",rc.psaID);
                rc.data = StructNew();
                rc.data.psaname = "#rc.panelData.psa.name#";
                rc.data.psaID = "#rc.psaID#";
                rc.data.fromname = "#rc.panelData.contact.first_name# #rc.panelData.contact.surname#";
                rc.data.fromemail = "#rc.panelData.contact.email#";
                rc.data.recipient = "#rc.panelData.suppliercontact.email#";
                rc.data.membercontact = rc.data.fromname;
                rc.data.membercontactemail = rc.data.fromemail;
                rc.data.suppliername = "#rc.panelData.company.name#";
                rc.data.suppliercontact = "#rc.panelData.suppliercontact.first_name#  #rc.panelData.suppliercontact.surname#";
                rc.message = populate_fields(psa.getEmailTemplate(1),rc.data);
                rc.dealDocumentCategory = dms.getRelatedCategory("deal",rc.psaID);
                rc.dealDocuments = dms.getRecursiveDocuments(rc.dealDocumentCategory.id);
              </cfscript>
    <cfset arguments.event.setLayout('Layout.Main')>
    <cfset arguments.event.setView('psa/email2supplier')>
  </cffunction>
  <cffunction name="emailDealDo" returntype="void" output="true" hint="My main event">
    <cfargument name="event">

    <cfscript>
                  var rc = arguments.event.getCollection();
                  rc.useraction = "save";
                  rc.panel = arguments.event.getValue("panel","psa");
                  rc.layout = "PDF";
                  rc.psaID = arguments.event.getValue('psaid',0);
                  rc.panelData = psa.panelData(rc.panel,rc.psaID);

                  rc.inputStreamID = arguments.event.getValue("inputStreamID",0);
                  rc.fe = psa.getFiguresEntryElements(rc.psaID);
                  rc.ut = psa.getInputTypes();
                  rc.printMode = false;
                  rc.dmsattached = arguments.event.getValue("dmsattach","");
                  if (rc.dmsattached neq "") {
                    rc.documentList = dms.getDocumentsFromList(rc.dmsattached);
                  }
                  if (rc.layout eq "Print" OR rc.layout eq "PDF") {
                    rc.printMode = true;
                    rc.panelData.canEditPSA = false;
                  }
                  if (rc.panelData.psa.internalReference eq "") {
                    rc.pid = rc.psaID;
                  } else {
                    rc.pid = rc.panelData.psa.internalreference;
                  }
                  renderView("psa/panel/psa_pdf");

                  rc.psa = psa.getPSA(rc.psaID);
                  rc.psaOb = BeanFactory.populateFromQuery("psa",rc.psa);
                  rc.psaOb.setPSA_status("supplier");
                  rc.psaOb.save();
                  //maybe create a note?
              </cfscript>

    <cfmail failto="#rc.from_email#" cc="#rc.cc#" subject="#rc.subject#" to="#rc.recipient#" from="#rc.from_name# <#rc.from_email#>">
  #message#
              <cfif rc.panelData.psa.internalReference neq 0 AND rc.panelData.psa.internalReference neq rc.psaID>
      <cffile action="copy" destination="ram://PSA#rc.panelData.psa.internalReference#.pdf" source="ram://#Year(rc.panelData.psa.period_from)#-#rc.psaID#.pdf">
      <cfmailparam file="ram://PSA#rc.panelData.psa.internalReference#.pdf"  disposition="attachment" type="application/pdf" remove="true">
    <cfelse>
      <cfmailparam file="/ram/#Year(rc.panelData.psa.period_from)#-#rc.psaID#.pdf"  disposition="attachment" type="application/pdf" remove="true">
    </cfif>
    <cfif rc.dmsattached neq "">
      <cfloop query="rc.documentList">
        <!--- how fucking annoying - we have to move the file into ram first! --->
        <cffile action="copy" destination="ram://#name#.#fileType#" source="#rc.app.appRoot#dms/documents/#id#.#filetype#">
        <cfmailparam  file="ram://#name#.#fileType#" disposition="attachment" remove="false">
      </cfloop>
    </cfif>
    </cfmail>
    <cfset setNextEvent(uri="/psa/index/psaid/#rc.psaID#")>
  </cffunction>

  <cffunction name="fullList" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = 0>
    <cfset rc.topCat = arguments.event.getValue("root",getSetting("rootGroupCategory"))>
    <cfset rc.psaList = this.getRecursiveDeals(rc.topCat,event)>
    <cfset rc.dataSource = dsn.getName()>
    <cfset rc.groups = groups>
    <cfset arguments.event.setView(name="psa/fullList")>
  </cffunction>

  <cffunction name="index" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();

      rc.psaID = arguments.event.getValue('psaid',0);
      if (rc.psaID eq 0) {
        rc.psaID = arguments.event.getValue('arrangementID',0);
      }
      rc.revisionID = arguments.event.getValue('revisionID',0);
      rc.layout = arguments.event.getValue("layout","Main");
      rc.psa = psa.getPSA(rc.psaID);
      psa.logUser(rc.psaID);
      rc.company = company.getCompany(rc.psa.company_id);
    </cfscript>
    <cfif NOT isUserInAnyRole("view,Marketing Team")>
      <cfif Not isUserInRole("figures") and rc.sess.eGroup.companyID neq rc.psa.company_id>
        Not enough privildges
        <cfabort>
      </cfif>
    </cfif>

    <cfset arguments.event.setView('psa/view')>
  </cffunction>

  <cffunction name="viewXML" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfscript>
      var rc = arguments.event.getCollection();
      rc.psaID = arguments.event.getValue('psaid',0);
      rc.layout = arguments.event.getValue("layout","ajax");
      rc.psa = psa.getArrangement(rc.psaID);
      rc.xml = xmlParse(rc.psa.dealData);
    </cfscript>

    <cfset arguments.event.setView('psa/viewXML')>
  </cffunction>







  <cffunction name="tree" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.categoryID = arguments.event.getValue("id",getSetting("rootGroupCategory"))>
    <cfset rc.type = arguments.event.getValue("type","current")>
    <cfif rc.categoryID eq 0>
      <cfset rc.categoryID = getSetting("rootGroupCategory")>
    </cfif>
    <cfset rc.subCats = groups.getChildrenGroups(rc.categoryID)>
    <cfset rc.deals = psa.getArrangementByCategory(rc.categoryID,rc.type)>
    <cfset rc.ret = StructNew()>
    <cfset rc.children = ArrayNew(1)>
    <cfloop query="rc.subCats">
      <cfset rc.x = StructNew()>
      <cfset rc.x["data"]["title"] = "#name#">
      <cfset rc.x["data"]["icon"] = "folder">
      <cfset rc.x["attr"]["id"] = "#oID#">
      <cfset rc.x["attr"]["class"] = "category">
      <cfset rc.x["state"] = "closed">
      <cfset arrayAppend(rc.children,rc.x)>
    </cfloop>
    <cfloop query="rc.deals">
      <cfset rc.x = StructNew()>
      <cfset rc.x["data"]["title"] = left(known_as,30)>
      <cfset rc.x["attr"]["class"] = "agreement">
      <cfset rc.x["attr"]["id"] = "#id#">
      <cfset rc.x["data"]["icon"] = "https://d25ke41d0c64z1.cloudfront.net/images/icons/document-export.png">
      <cfset rc.x["data"]["attr"]["id"] = "#id#">
      <cfset rc.x["data"]["attr"]["title"] = "#name#">
      <cfset rc.x["data"]["attr"]["class"] = "ajax">
      <cfset rc.x["data"]["attr"]["rev"] = "maincontent">
      <cfset rc.x["data"]["attr"]["href"] = "#bl(linkto='psa.index',queryString='psaid=#id#',e=event)#">
      <cfset arrayAppend(rc.children,rc.x)>
    </cfloop>
    <cfset rc.json = SerializeJSON(rc.children)>
    <cfset arguments.event.setView("renderJSON",true)>
  </cffunction>

  <cffunction name="inputStreamList" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue('psaid',0)>
    <Cfset rc.fe = psa.getFiguresEntryElements(rc.psaID)>
    <cfset rc.inputStreamID = arguments.event.getValue("inputStreamID",0)>
    <cfset rc.ut = psa.getInputTypes()>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("psa/panel/edit/inputStreamList")>
  </cffunction>

  <cffunction name="hasfiguresEntry" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.inputStreamID = arguments.event.getValue('inputStreamID',0)>
    <Cfset rc.fe = psa.hasFiguresEntry(rc.inputStreamID)>
    <cfset rc.jsonOb = StructNew()>
    <cfset rc.jsonOb["result"] = rc.fe>
    <cfset rc.json = serializeJSON(rc.jsonOb)>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("renderJSON")>
  </cffunction>



  <cffunction name="menu" returntype="void" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.logEvent = false>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset arguments.event.setView("admin/panels/dealTools")>
  </cffunction>

  <cffunction name="figuresEntry" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue('psaid',0)>
    <cfset rc.figuresEntryID = arguments.event.getValue("figuresEntryID",0)>
    <cfset rc.inputTypeID = arguments.event.getValue("inputTypeID",0)>
    <cfset rc.description = arguments.event.getValue("description",0)>
    <cfset rc.name = arguments.event.getValue("name","")>
    <cfif rc.figuresEntryID eq 0>
      <cfset psa.createFiguresEntry(rc.psaID,rc.inputTypeID,rc.description,rc.name)>
    <cfelse>
      <cfset psa.editFiguresEntry(rc.figuresEntryID,rc.psaID,rc.inputTypeID,rc.description,rc.name)>
    </cfif>
    <cfset rc.ut = psa.getInputTypes()>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("psa/panel/edit/inputStreamNew")>
  </cffunction>

  <cffunction name="removeChain" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.chainID = arguments.event.getValue('chainID',0)>
    <Cfset psa.removeDealChain(rc.chainID)>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("blank")>
  </cffunction>


  <cffunction name="inputStreamEdit" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue('psaid',0)>
    <cfset rc.ut = psa.getInputTypes()>
    <cfset rc.inputStreamID = arguments.event.getValue("inputStreamID",0)>
    <Cfset rc.inputStreams = psa.getFiguresEntryElement(rc.inputStreamID)>
    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("psa/panel/edit/inputStreamEdit")>
  </cffunction>
  <cffunction name="inputStreamNew" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>

    <cfset arguments.event.setLayout("Layout.ajax")>
    <cfset arguments.event.setView("psa/panel/edit/inputStreamNew")>
  </cffunction>
  <cffunction name="list" returntype="void" output="false" hint="My main event" cache="true">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.layout = arguments.event.getValue("layout","Main");
        rc.category = arguments.event.getValue('btid',0);
        rc.psaList = psa.getArrangementByTeam(rc.category);
        rc.orderby = arguments.event.getValue("orderBy","");
        rc.orderDir = arguments.event.getValue("orderDir","");
        if (rc.orderBy neq "") {
          getPlugin("CookieStorage").setVar("psaOrderBy","#rc.orderBy#");
        } else {
          rc.orderBy = getPlugin("CookieStorage").getVar("psaOrderBy","psaID");
        }
        if (rc.orderDir eq "desc") {
          rc.otherOrderDir = "asc";
        } else {
          rc.otherOrderDir = "desc";
        }
        rc.entireList = QueryNew('psaID,name,suppliername,status','varChar,varChar,varChar,varChar');

      </cfscript>
    <cfloop query="rc.psaList">
      <cfscript>
          QueryAddRow(rc.entireList);
          QuerySetCell(rc.entireList,"psaID","#id#");
          QuerySetCell(rc.entireList,"suppliername","#cname#");
          QuerySetCell(rc.entireList,"name","#name#");
        </cfscript>
    </cfloop>
    <cfquery name="rc.aggList" dbtype="query">
          select * from rc.entireList order by #rc.orderBy# #rc.orderDir#;
      </cfquery>

    <cfset arguments.event.setView('psa/list')>
  </cffunction>

  <cffunction name="view" returntype="void" output="false" cache="true">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.panel = arguments.event.getValue("panel","");
        rc.psaID = arguments.event.getValue('psaid',0);
        rc.revisionID = arguments.event.getValue('revisionID',0);
        rc.useraction = arguments.event.getValue("useraction","view");
        rc.layout = arguments.event.getValue("layout","ajax");
        rc.panelData = psa.panelData(rc.panel,rc.psaID,rc.revisionID);
        rc.permissions = dms.getDMSSecurity("arrangement",rc.psaid);
        rc.em = rc.sess.eGroup.editMode;
        rc.inputStreamID = arguments.event.getValue("inputStreamID",0);
        rc.fe = psa.getFiguresEntryElements(rc.psaID,false);
        rc.chains = psa.getChainedDeals(rc.psaID);
        rc.ut = psa.getInputTypes();
        rc.printMode = false;
        if (rc.layout eq "Print" OR rc.layout eq "PDF") {
          rc.printMode = true;
          rc.panelData.canEditPSA = false;
        }
    </cfscript>
    <!---<cfset rc.panelData = psa.getPanelData("#rc.panel#")> --->

    <cfif rc.panel neq "feed">
      <cfif isUserInRole("edit")>
      <cfset arguments.event.setView(name='psa/panel/#rc.panel#',cache="false")>
      <cfelse>
      <cfset arguments.event.setView(name='psa/panel/#rc.panel#',cache="true",cacheSuffix="#rc.psaID#_#rc.sess.eGroup.contactID#")>
      </cfif>
    <cfelse>
      <cfset rc.feed = rc.panelData.feed>
      <cfset arguments.event.setView('feed/general')>
    </cfif>
  </cffunction>







  <cffunction name="notifymembersDo" returntype="void" output="false">
    <cfargument name="event">

    <cfset var rc = arguments.event.getCollection()>
    <cfset rc.psaID = arguments.event.getValue("psaID",0)>
    <cfset rc.title = arguments.event.getValue("title","")>
    <cfset rc.importance = arguments.event.getValue("importance","")>
    <cfset rc.message = arguments.event.getValue("message","")>
    <cfset psa.notifyMembers(rc.psaID,rc.title,rc.importance,rc.message)>
    <cfset rc.blog = blog>
    <cfset rc.blog.settitle(rc.title)>
    <cfset rc.blog.setbody(rc.message)>
    <cfset rc.blog.setdate(now())>
    <cfset rc.blog.setrelatedID(rc.psaID)>
    <cfset rc.blog.setrelatedto("arrangement")>
    <cfset rc.blog.save()>
    <cfset rc.blogID = rc.blog.getid()>
    <!---<cfset feed.createFeedItem(so="contact",soID=rc.sess.egroup.contactID,tO="arrangement",tOID=psaID,action="postNews",ro="blog",roID=rc.blogID)>--->
    <cfset setNextEvent(uri="/psa/index/psaid/#rc.psaID#")>
  </cffunction>

  <cffunction name="moveElement" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaID","");
        rc.option = fixunder(arguments.event.getValue("option",""));
        rc.nodeName = arguments.event.getValue("nodeName","");
        psa.moveElement(rc.option,rc.psaID,rc.nodeName);
        </cfscript>
    <cfset arguments.event.setLayout('Layout.ajax')>
    <cfset arguments.event.setView('blank')>
  </cffunction>













  <cffunction name="repair" returntype="void" output="false" hint="My main event">
    <cfargument name="event">

    <cfscript>
        var rc = arguments.event.getCollection();
        rc.psaID = arguments.event.getValue("psaid","");
        rc.message = figures.repairPSA(rc.psaID);

    </cfscript>
    <cfset arguments.event.setLayout('Layout.Main')>
    <cfset arguments.event.setView('turnover/repair')>
  </cffunction>



  <cffunction name="moveAgreement" returntype="void">
    <cfargument name="event">
    <cfset var rc = event.getCollection()>
    <cfset rc.psaID = event.getValue("sourceID")>
    <cfset rc.categoryID = event.getValue("targetID")>
    <cfset rc.psa = psa.getPSA(rc.psaID)>
    <cfset rc.psa.setbuyingTeamID(rc.categoryID)>
    <cfset rc.psa.save()>
    <cfset event.setView("blank")>
  </cffunction>

<cfscript>
function populate_fields(str, values){

    l = Len(str);
    i = 1;
    output = '';

    while (i LT l){

        f = REFindNoCase("\[([a-z])+\]",str,i,"TRUE");
        if (f.pos[1] IS 0){
            output = output & Mid(str,i,l-i+1);
            i = l;
        } else {
            output = output & Mid(str,i,f.pos[1]-i);
            name = Mid(str,f.pos[1]+1,f.len[1] - 2);
            output = output & values[name];
            i = f.pos[1] + f.len[1];
        }

    }

    return output;

}

</cfscript>

<cffunction name="getRecursiveDeals" returnType="string" output="true">
    <cfargument name="catID" required="true" default="0">
    <cfargument name="event">
    <cfset var deals = "">
    <cfset rc = event.getCollection()>
    <!--- get child categories --->
    <cfset var children = groups.getChildrenGroups(catID)>
    <cfset var thisTree = "">
      <cfsavecontent variable="thisTree">
        <cfoutput>
        <ul>
          <cfif children.recordCount gte 1>
            <cfloop query="children">
            <li class="categoryHeader"><h3>#name#</h3>
              #getRecursiveDeals(oid,event)#
            </li>
            </cfloop>
          </cfif>
          <cfquery name="deals" datasource="#dsn.getName(true)#">
            select
              psa.id,
              psa.name,
              psa.dealData,
              psa.company_id,
              psa.contact_id,
              psa.PSA_status,
              company.known_as,
              company.name as companyName,
              company.id as companyID,
              psa.period_from,
              psa.period_to
              from
              arrangement as psa LEFT JOIN dmsSecurity on (psa.id = dmsSecurity.relatedID AND dmsSecurity.securityAgainst = 'arrangement'),
              company,
              dealCategory
              where
              (dmsSecurity.groupID IN (<cfqueryparam cfsqltype="cf_sql_varchar" list="true" value="#request.eGroup.rolesids#">) OR dmsSecurity.priviledge is NULL)
              AND
              (
               period_from < <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
                AND
               period_to > <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
              )
              AND
              company.id = psa.company_id
              AND
              dealCategory.categoryID = <cfqueryparam cfsqltype="cf_sql_integer" value="#catID#">
              AND
              psa.id = dealCategory.psaID
              group by psa.id order by known_as
          </cfquery>
          <cfloop query="deals">
          <li class="agreement">
            <a href="#bl('psa.index','psaID=#id#',event)#">
              <img width="25" class="gravatar" src="#paramImage('company/#companyID#_square.jpg','website/unknown.jpg')#" alt="#known_as#" border="0" />
              <b>#companyName#</b>
              <p>#name# (#DateFormat(period_from,"MMM YY")# - #DateFormat(period_to,"MMM YY")#)</p></a>
          </li>
          </cfloop>
        </ul>
        </cfoutput>
      </cfsavecontent>
    <cfreturn thisTree>
  </cffunction>
</cfcomponent>

