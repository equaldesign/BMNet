<!--- All methods in this helper will be available in all handlers,plugins,views & layouts --->
<cfscript>
/**
* Returns a string with words capitalized for a title.
* Modified by Ray Camden to include var statements.
*
* @param initText      String to be modified.
* @return Returns a string.
* @author Ed Hodder (ed.hodder@bowne.com)
* @version 2, July 27, 2001
*/
function stripOriginalMessage(s) {
  if (findNoCase("-----Original Message-----",s) gt 1) {
    return left(s,findNoCase("-----Original Message-----",s)-1);
  } else {
    return s;
  }
}
function dataTablesSorter(event,sortA) {
  var returnString = "";
  if (event.valueExists("iSortingCols")) {
    returnString = "order by ";
      for (i=0;i<event.getValue("iSortingCols");i++) {
      if (i gt 0) {
        returnString = "#returnString#, ";
      }
      returnString = "#returnString# #sortA[event.getValue('iSortCol_#i#')+1]# #event.getValue('sSortDir_#i#')#";
    }
  }
  return returnString;
}

function getEmails(str) {
    var email = "(['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|jobs|travel)))";
    var res = "";
    var marker = 1;
    var matches = "";

    matches = reFindNoCase(email,str,marker,marker);

    while(matches.len[1] gt 0) {
        res = listAppend(res,mid(str,matches.pos[1],matches.len[1]));
        marker = matches.pos[1] + matches.len[1];
        matches = reFindNoCase(email,str,marker,marker);
    }
    return res;
}
function leftWords(str,c) {
  strA = listToArray(str," ");
  output = "";
  if (ArrayLen(strA)<c) {
    limit = ArrayLen(strA);
    prependS = "";
  } else {
    limit = c;
    prependS = "...";
  }
  for (i=1;i<limit;i++) {
  	output = "#output##strA[i]#  ";
  }
  return "#output##prependS#";
}
function dateFormatOrdinal(d,mask) {
	dateStr = dateFormat(d,mask);
	dA1 = ListToArray(dateStr," ");
	for (i=1;i<ArrayLen(dA1);i++) {
	 if (isNumeric(dA1[i])) {
	   if (dA1[i] >= 1 AND dA1[i] <= 31) {

	     dA1[i] = "#dA1[i]##GetOrdinal(dA1[i])#";
	   }
	 }
	}
	dateStr = ArrayToList(dA1," ");
  dA1 = ListToArray(dateStr,"/");
  for (i=1;i<ArrayLen(dA1);i++) {
   if (isNumeric(dA1[i])) {
     if (dA1[i] >= 1 AND dA1[i] <= 31) {
       dA1[i] = "#dA1[i]##GetOrdinal(dA1[i])#";
     }
   }
  }
  dateStr = ArrayToList(dA1," ");
  return dateStr;
}
function getCalendarClass(invited,attending) {
	if (attending eq "true") {
		return  "attending";
	} else if (attending eq "false") {
		return "declined";
	} else {
		if (invited eq "false") {
			return "notinvited";
		} else {
			return "unconfirmed";
		}
	}
}
function canViewPSA(psaID,memberID,companyID) {
  if (memberID == 0 AND rc.sess.eGroup.isMemberContact) {
    return true;
  } else if (memberID == rc.sess.eGroup.companyID) {
      return true;
  } else if (companyID == rc.sess.eGroup.companyID) {
    return true;
  } else {
    return false;
  }

}
function numO(str) {
  return str;
//+  return ReReplace(str,"[^0-9]","","all");
}
function fixdot(str) {
  return replace(str,".","-","all");
}
function fixunder(str) {
  return replace(str,"-",".","all");
}
function paramVal(value,param) {
  if (isDefined(value)) {
    return Evaluate(value);
  } else {
    return param;
  }
}
function abbrNum(number, decPlaces) {

		m = createObject("java","java.lang.Math");
    decPlaces = m.pow(10,decPlaces);
    var abbrev = ["k","m","b","t"];
    for (var i=ArrayLen(abbrev); i gte 1; i--) {
        var size = m.pow(10,(i)*3);
        if(size <= number) {
             number = m.round(number*decPlaces/size)/decPlaces;
             number = "#number##abbrev[i]#";
             break;
        }
    }

    return number;
}

function  canEditContact(companyID,yourCompanyID) {
	if  (IsUserInRole("ebiz")) {
		return true;
	}
	if (isUserInRole("admin")) {
		return true;
	} else if (isUserInAnyRole("supplieradmin,memberadmin")) {
		if (companyID eq yourCompanyID) {
			return true;
		}
	} else {
		return false;
	}
}
function canSetPrivs(type) {
	if (isUserInRole("ebiz")) {
		return true;
	}
	switch(type) {
		case "cba": {
			if (isUserInRole("admin")) {
				return true;
			} else {
				return false;
			}
			break;
		}
		case "member": {
			if (isUserInRole("member_admin")) {
				return true;
			}
			break;
		}
		case "supplier": {
			if (IsUserInAnyRole("edit,supplieradmin")) {
				return true;
			} else {
				return false;
			}
			break;
		}
		default: {
			return false;
			break;
		}
	}
}
function canSeeEmail(contactID,companyID) {
	if (isUserInRole("ebiz")) {
		return true;
	} else if (contactID eq 0) {
		// it's a new user'
		return true;
	} else if (companyID eq rc.sess.eGroup.companyID AND isUserInAnyRole("memberadmin,supplieradmin")) {
		return true;
	} else if (contactID eq rc.sess.eGroup.contactID) {
		return true;
	} else {
				return false;
	}


}
function canSeeUserPassword(contactID) {
	if (isUserInRole("ebiz")) {
		return true;
	} else if (contactID eq rc.sess.eGroup.contactID){
		return true;
	} else {
		return false;
	}
}

function canEditCompany(id,type_id) {
	if (isUserInRole("ebiz")) {
		return true;
	} else if (type_id eq 1 AND id eq rc.sess.eGroup.companyID AND isUserInRole("memberadmin")) {
			return true;
	} else if (type_id eq 2 AND isUserInRole("edit")) {
			return true;
	} else if (type_id eq 2 AND id eq rc.sess.eGroup.companyID AND isUserInRole("supplieradmin")) {
			return true;
	} else {
		return false;
	}
}
function convertToColumnRef(row,column) {
	Letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","AA","AB","AC","AD","AE","AF","AG","AH","AI","AJ","AK","AL","AM","AN","AO","AP","AQ","AR","AS","AT","AU","AV","AW","AX","AY","AZ"];
	return "#Letters[column]##row#";
}
function getextension(thefile) {
      i = 1;
      l = Len(thefile);
      found = 0;
      ext = '';

      while (i LTE l){
         f = Find('.',thefile,i);
         if (f IS 0){
            // last one or none found
            if (found IS NOT 0){
               ext = Mid(thefile,found + 1,l - found);
               i = l + 1;
            } else {
          i = l + 1;
        }
         } else {
            found = f;
            i = f + 1;
         }
      }
      return ext;
    }
function fncFileSize(size) {
    if (size lt 1024) return "#size# b";
    if (size lt 1024^2) return "#round(size / 1024)# Kb";
    if (size lt 1024^3) return "#decimalFormat(size/1024^2)# Mb";
    return "#decimalFormat(size/1024^3)# Gb";
}
function stripAllNum(str) {
  return ReReplaceNoCase(str,"[^0-9-]","","ALL");
}
function cdt(dateString) {
    dA = ListToArray(dateString," ");
    dString = dA[1];
    tString = dA[2];
    dOb = ListToArray(dString,"/");
    tOb  = ListToArray(tString,":");
    return createDateTime(dOb[3],dOb[2],dOb[1],tOb[1],tOb[2],tOb[3]);
  }
  function cdt3(dateString) {
    dA = ListToArray(dateString," ");
    _month = dA[2];
    _themonth = ListFind("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",_month);
    _day = dA[1];
    _year = dA[3];
    _time = dA[4];
    tOb  = ListToArray(_time,":");
    return createDateTime(_year,_themonth,_day,tOb[1],tOb[2],tOb[3]);
  }
  function cdt2(dateString) {
    dA = ListToArray(dateString," ");
    _month = dA[1];
    _themonth = ListFind("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",_month);
    _day = dA[2];
    _year = dA[3];
    _time = dA[4];
    tOb  = ListToArray(_time,":");
    return createDateTime(_year,_themonth,_day,tOb[1],tOb[2],tOb[3]);
  }
  function cdAlf(dateString) {
    dA = ListToArray(dateString,",");
    dS = ListToArray(dA[1]," ");
    _month = dS[1];
    _themonth = ListFind("Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec",_month);
    _day = dS[2];
    _year = dA[2];
    return createDate(_year,_themonth,_day);
  }
  function alfDate(dateString) {
    dA = ListToArray(dateString," ");
    return "#dA[1]# #dA[2]#, #dA[3]#";
  }
  function alfDateTime(dateString) {
    dA = ListToArray(dateString," ");
    tA = ListToArray(dA[4],":");
    return "#dA[1]# #dA[2]#, #dA[3]# @ #tA[1]#:#tA[2]#";
  }
function capFirstTitle(initText){

    var Words = "";
    var j = 1; var m = 1;
    var doCap = "";
    var thisWord = "";
    var outputString = "";

    initText = LCASE(initText);

    //Words to never capitalize
    excludeWords = "an,the,at,by,for,of,in,up,on,to,and,as,but,if,or,nor,a,ltd,plc,eBiz";
    //Make each word in text an array variable
		uppercaseWords = "ltd,plc";

    Words = ListToArray(initText, " ");

    //Check words against exclude list
    for(j=1; j LTE (ArrayLen(Words)); j = j+1){
        doCap = true;

        //Word must be less that four characters to be in the list of excluded words
        if(LEN(Words[j]) LTE 4 ){
            if(ListFindNoCase(excludeWords,Words[j])){
            	Words[j] =ListGetAt(excludeWords,ListFindNoCase(excludeWords,Words[j]));
            	if (ListFind(uppercaseWords,Words[j])) {
            		Words[j] = UCASE(Words[j]);
            	}
               doCap = false;
            }
        }

        //Capitalize hyphenated words
        if(ListLen(Words[j],"-") GT 1){
            for(m=2; m LTE ListLen(Words[j], "-"); m=m+1){
                thisWord = ListGetAt(Words[j], m, "-");
                thisWord = UCase(Mid(thisWord,1, 1)) & Mid(thisWord,2, LEN(thisWord)-1);
                Words[j] = ListSetAt(Words[j], m, thisWord, "-");
            }
        }


        //Capitalize qualifying words
        if(doCap){
            Words[j] = UCase(Mid(Words[j],1, 1)) & Mid(Words[j],2, LEN(Words[j])-1);
        }
    }

    outputString = ArrayToList(Words, " ");

    return outputString;

}
</cfscript>
<cfscript>
    function NumberFormatIfNumber(string,format) {
    if (isNumeric(string)) {
      return NumberFormat(string,format);
    } else {
      return string;
    }
  }
function madcolor() {
r = RandRange(1,255);
g = RandRange(1,255);
b = RandRange(1,255);
hexarray= ArrayNew(1);
hexarray[1] = '01';
hexarray[2] = '02';
hexarray[3] = '03';
hexarray[4] = '04';
hexarray[5] = '05';
hexarray[6] = '06';
hexarray[7] = '07';
hexarray[8] = '08';
hexarray[9] = '09';
hexarray[10] = '0A';
hexarray[11] = '0B';
hexarray[12] = '0C';
hexarray[13] = '0D';
hexarray[14] = '0E';
hexarray[15] = '0F';
hexarray[16] = '10';
hexarray[17] = '11';
hexarray[18] = '12';
hexarray[19] = '13';
hexarray[20] = '14';
hexarray[21] = '15';
hexarray[22] = '16';
hexarray[23] = '17';
hexarray[24] = '18';
hexarray[25] = '19';
hexarray[26] = '1A';
hexarray[27] = '1B';
hexarray[28] = '1C';
hexarray[29] = '1D';
hexarray[30] = '1E';
hexarray[31] = '1F';
hexarray[32] = '20';
hexarray[33] = '21';
hexarray[34] = '22';
hexarray[35] = '23';
hexarray[36] = '24';
hexarray[37] = '25';
hexarray[38] = '26';
hexarray[39] = '27';
hexarray[40] = '28';
hexarray[41] = '29';
hexarray[42] = '2A';
hexarray[43] = '2B';
hexarray[44] = '2C';
hexarray[45] = '2D';
hexarray[46] = '2E';
hexarray[47] = '2F';
hexarray[48] = '30';
hexarray[49] = '31';
hexarray[50] = '32';
hexarray[51] = '33';
hexarray[52] = '34';
hexarray[53] = '35';
hexarray[54] = '36';
hexarray[55] = '37';
hexarray[56] = '38';
hexarray[57] = '39';
hexarray[58] = '3A';
hexarray[59] = '3B';
hexarray[60] = '3C';
hexarray[61] = '3D';
hexarray[62] = '3E';
hexarray[63] = '3F';
hexarray[64] = '40';
hexarray[65] = '41';
hexarray[66] = '42';
hexarray[67] = '43';
hexarray[68] = '44';
hexarray[69] = '45';
hexarray[70] = '46';
hexarray[71] = '47';
hexarray[72] = '48';
hexarray[73] = '49';
hexarray[74] = '4A';
hexarray[75] = '4B';
hexarray[76] = '4C';
hexarray[77] = '4D';
hexarray[78] = '4E';
hexarray[79] = '4F';
hexarray[80] = '50';
hexarray[81] = '51';
hexarray[82] = '52';
hexarray[83] = '53';
hexarray[84] = '54';
hexarray[85] = '55';
hexarray[86] = '56';
hexarray[87] = '57';
hexarray[88] = '58';
hexarray[89] = '59';
hexarray[90] = '5A';
hexarray[91] = '5B';
hexarray[92] = '5C';
hexarray[93] = '5D';
hexarray[94] = '5E';
hexarray[95] = '6F';
hexarray[96] = '60';
hexarray[97] = '61';
hexarray[98] = '62';
hexarray[99] = '63';
hexarray[100] = '64';
hexarray[101] = '65';
hexarray[102] = '66';
hexarray[103] = '67';
hexarray[104] = '68';
hexarray[105] = '69';
hexarray[106] = '6A';
hexarray[107] = '6B';
hexarray[108] = '6C';
hexarray[109] = '6D';
hexarray[110] = '6E';
hexarray[111] = '6F';
hexarray[112] = '70';
hexarray[113] = '71';
hexarray[114] = '72';
hexarray[115] = '73';
hexarray[116] = '74';
hexarray[117] = '75';
hexarray[118] = '76';
hexarray[119] = '77';
hexarray[120] = '78';
hexarray[121] = '79';
hexarray[122] = '7A';
hexarray[123] = '7B';
hexarray[124] = '7C';
hexarray[125] = '7D';
hexarray[126] = '7E';
hexarray[127] = '7F';
hexarray[128] = '80';
hexarray[129] = '81';
hexarray[130] = '82';
hexarray[131] = '83';
hexarray[132] = '84';
hexarray[133] = '85';
hexarray[134] = '86';
hexarray[135] = '87';
hexarray[136] = '88';
hexarray[137] = '89';
hexarray[138] = '8A';
hexarray[139] = '8B';
hexarray[140] = '8C';
hexarray[141] = '8D';
hexarray[142] = '8E';
hexarray[143] = '8F';
hexarray[144] = '90';
hexarray[145] = '91';
hexarray[146] = '92';
hexarray[147] = '93';
hexarray[148] = '94';
hexarray[149] = '95';
hexarray[150] = '96';
hexarray[151] = '97';
hexarray[152] = '98';
hexarray[153] = '99';
hexarray[154] = '9A';
hexarray[155] = '9B';
hexarray[156] = '9C';
hexarray[157] = '9D';
hexarray[158] = '9E';
hexarray[159] = '9F';
hexarray[160] = 'A0';
hexarray[161] = 'A1';
hexarray[162] = 'A2';
hexarray[163] = 'A3';
hexarray[164] = 'A4';
hexarray[165] = 'A5';
hexarray[166] = 'A6';
hexarray[167] = 'A7';
hexarray[168] = 'A8';
hexarray[169] = 'A9';
hexarray[170] = 'AA';
hexarray[171] = 'AB';
hexarray[172] = 'AC';
hexarray[173] = 'AD';
hexarray[174] = 'AE';
hexarray[175] = 'AF';
hexarray[176] = 'B0';
hexarray[177] = 'B1';
hexarray[178] = 'B2';
hexarray[179] = 'B3';
hexarray[180] = 'B4';
hexarray[181] = 'B5';
hexarray[182] = 'B6';
hexarray[183] = 'B7';
hexarray[184] = 'B8';
hexarray[185] = 'B9';
hexarray[186] = 'BA';
hexarray[187] = 'BB';
hexarray[188] = 'BC';
hexarray[189] = 'BD';
hexarray[190] = 'BE';
hexarray[191] = 'BF';
hexarray[192] = 'C0';
hexarray[193] = 'C1';
hexarray[194] = 'C2';
hexarray[195] = 'C3';
hexarray[196] = 'C4';
hexarray[197] = 'C5';
hexarray[198] = 'C6';
hexarray[199] = 'C7';
hexarray[200] = 'C8';
hexarray[201] = 'C9';
hexarray[202] = 'CA';
hexarray[203] = 'CB';
hexarray[204] = 'CC';
hexarray[205] = 'CD';
hexarray[206] = 'CE';
hexarray[207] = 'CF';
hexarray[208] = 'D0';
hexarray[209] = 'D1';
hexarray[210] = 'D2';
hexarray[211] = 'D3';
hexarray[212] = 'D4';
hexarray[213] = 'D5';
hexarray[214] = 'D6';
hexarray[215] = 'D7';
hexarray[216] = 'D8';
hexarray[217] = 'D9';
hexarray[218] = 'DA';
hexarray[219] = 'DB';
hexarray[220] = 'DC';
hexarray[221] = 'DD';
hexarray[222] = 'DE';
hexarray[223] = 'DF';
hexarray[224] = 'E0';
hexarray[225] = 'E1';
hexarray[226] = 'E2';
hexarray[227] = 'E3';
hexarray[228] = 'E4';
hexarray[229] = 'E5';
hexarray[230] = 'E6';
hexarray[231] = 'E7';
hexarray[232] = 'E8';
hexarray[233] = 'E9';
hexarray[234] = 'EA';
hexarray[235] = 'EB';
hexarray[236] = 'EC';
hexarray[237] = 'ED';
hexarray[238] = 'EE';
hexarray[239] = 'EF';
hexarray[240] = 'F0';
hexarray[241] = 'F1';
hexarray[242] = 'F2';
hexarray[243] = 'F3';
hexarray[244] = 'F4';
hexarray[245] = 'F5';
hexarray[246] = 'F6';
hexarray[247] = 'F7';
hexarray[248] = 'F8';
hexarray[249] = 'F9';
hexarray[250] = 'FA';
hexarray[251] = 'FB';
hexarray[252] = 'FC';
hexarray[253] = 'FD';
hexarray[254] = 'FE';
hexarray[255] = 'FF';
hexcode = hexarray[r] & hexarray[g] & hexarray[b];
return hexcode;
}
</cfscript>
<cfscript>
function IsFactor(a,b)
{
  if (Int(b/a) EQ b/a){
    Return True;
    }
  else {
    Return False;
  }
}
  function vm(ar1,ar2) {
	  if (NOT isDefined('ar2') OR NOT isDefined('ar1')) {
			return false;
		}
    var value = "selected";
    if (ArrayLen(arguments) GTE 3) {
      if(Arguments[3] eq "checkbox") {
        value = 'checked="checked"';
      } else {
        value = "selected='selected'";
      }
    } else {
      value = "selected='selected'";
    }
    if (ar1 eq ar2) {
      return value;
    }
  }

  function vmb(ar1,ar2) {
    if (NOT isDefined('ar2') OR NOT isDefined('ar1')) {
      return false;
    }
    var value = "selected";
    if (ArrayLen(arguments) GTE 3) {
      if(Arguments[3] eq "checkbox") {
		    if (ar1 eq ar2) {
		      return true;
		    } else {
		      return false;
		    }
      } else {
        if (ar1 eq ar2) {
          return "selected";
        } else {
          return "";
        }
      }
    }
    if (ar1 eq ar2) {
      return value;
    } else {
      return "";
    }
  }
 function stripHTML(str) {
  str = ReReplaceNoCase (str,'&nbsp;','',"all");
  return REReplaceNoCase (str, "(<|^)[^>]*(>|$)" , "", "ALL");
}
function readForm(name,def){
   requireNumeric = false;
   if (ArrayLen(Arguments) GTE 3){
      if (Arguments[3]){
         requireNumeric = true;
      }
   }
   requireValue = false;
   if (ArrayLen(Arguments) GTE 4){
      if (Arguments[4]){
         requireValue = true;
      }
   }

   if (isDefined('Form.#name#')){
      value = Form[name];
   } else if (isDefined('URL.#name#')){
      value = URL[name];
   } else {
      value = def;
   }

   if (requireNumeric){
      if (isNumeric(value)){
         return value;
      } else {
         return 0;
      }
   } else {
      return value;
   }
}

</cfscript>


<cfscript>
/**
 * Tests passed value to see if it is a valid e-mail address (supports subdomain nesting and new top-level domains).
 * Update by David Kearns to support '
 * SBrown@xacting.com pointing out regex still wasn't accepting ' correctly.
 * More TLDs
 * Version 4 by P Farrel, supports limits on u/h
 *
 * @param str    The string to check. (Required)
 * @return Returns a boolean.
 * @author Jeff Guillaume (SBrown@xacting.comjeff@kazoomis.com)
 * @version 4, December 30, 2005
 */
function isEmail(str) {
    return (REFindNoCase("^['_a-z0-9-]+(\.['_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.(([a-z]{2,3})|(aero|coop|info|museum|name|mobi|jobs|travel))$",
arguments.str) AND len(listGetAt(arguments.str, 1, "@")) LTE 64 AND
len(listGetAt(arguments.str, 2, "@")) LTE 255) IS 1;
}
function checkForURL(str) {
	if (left(str,7) eq "http://") {
		return '<a href="#str#" target="_blank">#str#</a>';
	} else {
		if (str eq "") {
			return str;
		} else {
			return '<a href="http://#str#" target="_blank">#str#</a>';
		}
	}
}
function makeURL(str) {
  if (left(str,7) eq "http://") {
    return str;
  } else {
    return "http://#str#";
  }
}
</cfscript>

<cfscript>
/**
 * An &quot;enhanced&quot; version of ParagraphFormat.
 * Added replacement of tab with nonbreaking space char, idea by Mark R Andrachek.
 * Rewrite and multiOS support by Nathan Dintenfas.
 *
 * @param string   The string to format. (Required)
 * @return Returns a string.
 * @author Ben Forta (ben@forta.com)
 * @version 3, June 26, 2002
 */
function ParagraphFormat2(str) {
  //first make Windows style into Unix style
  str = replace(str,chr(13)&chr(10),chr(10),"ALL");
  //now make Macintosh style into Unix style
  str = replace(str,chr(13),chr(10),"ALL");
  //now fix tabs
  str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
  //now return the text formatted in HTML
  return replace(str,chr(10),"<br />","ALL");
}
function ParagraphFormat3(str) {
  //first make Windows style into Unix style
  str = replace(str,chr(13)&chr(10),chr(10),"ALL");
  //now make Macintosh style into Unix style
  str = replace(str,chr(13),chr(10),"ALL");
  //now fix tabs
  str = replace(str,chr(9),"&nbsp;&nbsp;&nbsp;","ALL");
  //now return the text formatted in HTML
  return str;
}
</cfscript>

<cfscript>
/**
* Generates a password the length you specify.
*
* @param numberOfCharacters      Lengh for the generated password.
* @return Returns a string.
* @author Tony Blackmon (fluid@sc.rr.com)
* @version 1, April 25, 2002
*/
function generatePassword(numberofCharacters) {
var placeCharacter = "";
var currentPlace=0;
var group=0;
var subGroup=0;

for(currentPlace=1; currentPlace lte numberofCharacters; currentPlace = currentPlace+1) {
group = randRange(1,4);
switch(group) {
case "1":
subGroup = rand();
    switch(subGroup) {
case "0":
placeCharacter = placeCharacter & chr(randRange(33,46));
break;
case "1":
placeCharacter = placeCharacter & chr(randRange(58,64));
break;
}
case "2":
placeCharacter = placeCharacter & chr(randRange(97,122));
break;
case "3":
placeCharacter = placeCharacter & chr(randRange(65,90));
break;
case "4":
placeCharacter = placeCharacter & chr(randRange(48,57));
break;
}
}
return placeCharacter;
}

</cfscript>
<cfscript>
/**
* UDF that returns an SEO friendly string.
* Fix for - in front by B
*
* @param title      String to modify. (Required)
* @return Returns a string.
* @author Nick Maloney (nmaloney@prolucid.com)
* @version 2, November 29, 2008
*/
function friendlyUrl(title) {
    title = replaceNoCase(title,"&amp;","and","all"); //replace &amp;
    title = replaceNoCase(title,"&","and","all"); //replace &
    title = replaceNoCase(title,"'","","all"); //remove apostrophe
    title = reReplaceNoCase(trim(title),"[^a-zA-Z0-9]","-","ALL");
    title = reReplaceNoCase(title,"[\-\-]+","-","all");
    //Remove trailing dashes
    if(right(title,1) eq "-") {
        title = left(title,len(title) - 1);
    }
    if(left(title,1) eq "-") {
        title = right(title,len(title) - 1);
    }
    return lcase(title);
}
function bl (linkto,queryString,e) {
  var returnLink = "";
  if (NOT isDefined("event")) {
    var event = e;
  }
  if (event.getCurrentModule() neq "") {
    returnLink = "/#event.getCurrentModule()#";
  }
  returnLink = "#returnLink#/#replace(linkto,".","/","ALL")#";
  if (isDefined("arguments.queryString") AND arguments.queryString neq "") {
    returnLink = "#returnLink#?#arguments.queryString#";
  }
  return returnLink;
}

function urlEncrypt(queryString){
    // encode the string
    var key = "cockcheddar";
    var uue = cfusion_encrypt(queryString, key);

    // make a checksum of the endoed string
    var checksum = left(hash(uue & key),2);

    // assemble the URL
    queryString = uue & checksum ;

    return queryString;
}
function urlDecrypt(queryString){
    var key = "cockcheddar";
    var scope = "url";
    var stuff = "";
    var oldcheck = "";
    var newcheck = "";
    var i = 0;
    var thisPair = "";
    var thisName = "";
    var thisValue = "";





        // grab the old checksum
          if (len(querystring) GT 2) {
          oldcheck = right(querystring, 2);
          querystring = rereplace(querystring, "(.*)..", "\1");
          }

          // check the checksum
          newcheck = left(hash(querystring & key),2);
          if (newcheck NEQ oldcheck) {
          return querystring;
          }

        //decrypt the passed value
        queryString = cfusion_decrypt(queryString, key);


    return queryString;
}
</cfscript>
<cfscript>
function DownLoadTime56k(fileSize) {
    var totalSeconds = (fileSize * 10) / 57600;
    var tempstring = "";
    var tempstring2 = "";
    var hours = totalSeconds / 3600;
    var minutes = totalSeconds / 60;
    var seconds = totalSeconds MOD 60;
    var hourText = "";
    var minuteText = "";

    // if over 60 minutes...get just minutes left from hours
    if (minutes gte 60) minutes = minutes MOD 60;

    if (hours gte 1) {
        if (hours gt 2) hourText = " hours ";
        else hourText = " hour ";
        tempstring = Fix(hours) & hourText;
    }

    if (minutes gte 1) {
        if (minutes gt 2) minuteText = " minutes ";
        else minuteText = " min ";
        tempstring = tempstring & Fix(minutes) & minuteText;
    }

    if (seconds gt 0) {
    	if (seconds eq 1) {
    	tempstring = tempstring & seconds & " sec";
    	} else {
    	tempstring = tempstring & seconds & " secs";
    	}

    }

    return tempstring ;
}

function KBytes(bytes) {
    var b=0;

    if(arguments.bytes lt 1024) return trim(numberFormat(arguments.bytes,"9,999")) & " bytes";

    b=arguments.bytes / 1024;

    if (b lt 1024) {
        if(b eq int(b)) return trim(numberFormat(b,"9,999")) & " KB";
        return trim(numberFormat(b,"9,999.9")) & " KB";
    }
    b= b / 1024;
    if (b eq int(b)) return trim(numberFormat(b,"999,999,999")) & " MB";
    return trim(numberFormat(b,"999,999,999.9")) & " MB";
}
function vml(ar1,ar2) {
		var value = "selected";
		if (ArrayLen(arguments) GTE 3) {
			if(Arguments[3] eq "checkbox") {
				value = "checked";
			} else {
				value = "selected";
			}
		} else {
			value = "selected";
		}
    if (ListFind(ar1,ar2) gte 1) {
      return value;
    }
 }
function canView(elem) {
					if (isUserInRole("admin") OR IsUserInRole("figures")) {
						return true;
					} else {
						if (NOT isDefined('elem.XmlAttributes.PERMISSIONS')) {
								// no permissions - so assume view all
								return true;
							} else {
								if(elem.XmlAttributes.PERMISSIONS eq "none") {
									// permissions = none; again assume view all
									return true;
								} else {

									return isUserInRole(elem.XmlAttributes.PERMISSIONS);
								}
							}
						}
				}
</cfscript>
<cffunction name="getUType">
  <cfargument name="unitID" required="true">
  <cfargument name="rebateType" required="true">
  <cfif rebateType eq "groupgrowth" OR rebateType eq "groupgrowth">
    <cfset unitID = 6>
  </cfif>
  <cfreturn getUnitType2(unitID)>
</cffunction>
<cffunction name="getUnitType2">
					<cfargument name="unitID" required="no">
						<cfquery name="Utype" datasource="cbagroup">
							select * from unitType where id = '#arguments.unitID#';
						</cfquery>
						<cfset type = StructNew()>
						<cfif Utype.RecordCount IS 1>
							<cfscript>
							type.name = utype.display;
							type.showBefore = utype.showbefore;
							type.type = Utype.type;
							type.isPer = utype.isPer;
							type.isValid = true;
							</cfscript>
							<cfreturn type>
						<cfelse>
							<cfscript>
							type.name = "";
							type.isValid = false;
							</cfscript>
							<cfreturn type>
						</cfif>
				</cffunction>
	<cffunction name="getTypes" returntype="query">
	  <cfquery name="t" datasource="cbagroup">
				select * from unitType;
			</cfquery>
	  <cfreturn t>
	</cffunction>
  <cffunction name="isUserInARole" returntype="boolean">
  	<cfargument name="roles" required="true">
    <cfset userRole = false>
    <cfloop list="#roles#" index="i">
    	<cfif IsUserInRole(i)>
      	<cfset userRole = true>
      </cfif>
    </cfloop>
    <cfreturn userRole>
  </cffunction>

    <cffunction name="getRebateElement" returntype="any">
    	<cfargument name="xml" required="yes">
      <cfargument name="elementID" required="yes">
      <cfset xpathExp = "//parent::*//component[id='#ToString(elementID)#']">
      <cfset rebateNode = XMLSearch(xml,xpathExp)>
      <cfreturn rebateNode[1]>
    </cffunction>

		<cffunction name="periodFormat" returntype="String">
			<cfargument name="divison" required="true">
			<cfargument name="dateFrom" required="true">
			<cfargument name="dateTo" required="false">
			<cfset dateTo = DateAdd('d',-1,dateTo)>
			<cfswitch expression="#divison#">
				<cfcase value="QUARTERLY">
					<cfswitch expression="#Month(dateFrom)#">
						<cfcase value="1,2,3">
							<cfreturn "Q1 (#DateFormat(dFrom,'MMM YYYY')# - #DateFormat(dateTo,'MMM YYYY')#)">
						</cfcase>
						<cfcase value="4,5,6">
							<cfreturn "Q2 (#DateFormat(dFrom,'MMM YYYY')# - #DateFormat(dateTo,'MMM YYYY')#)">
						</cfcase>
						<cfcase value="7,8,9">
							<cfreturn "Q3 (#DateFormat(dFrom,'MMM YYYY')# - #DateFormat(dateTo,'MMM YYYY')#)">
						</cfcase>
						<cfcase value="10,11,12">
							<cfreturn "Q4 (#DateFormat(dFrom,'MMM YYYY')# - #DateFormat(dateTo,'MMM YYYY')#)">
						</cfcase>
					</cfswitch>
				</cfcase>
				<cfcase value="MONTHLY">
					<cfreturn "#DateFormat(dFrom,'MMMM YYYY')#">
				</cfcase>
				<cfdefaultcase>
					<cfreturn "#DateFormat(dFrom,'MMM YYYY')# - #DateFormat(dateTo,'MMM YYYY')#">
				</cfdefaultcase>
			</cfswitch>
		</cffunction>
<cffunction name="paramImage" returntype="string" output="false" >

  <cfargument name="path" hint="from /web root">
  <cfargument name="default" hint="from /web root">
  <cfif fileExists("/fs/sites/cba/new.cbagroup.co.uk/web/includes/images/#trim(path)#")>
    <cfreturn trim("/includes/images/#path#")>
  <cfelse>
    <cfreturn trim("/includes/images/#default#")>
  </cfif>

</cffunction>
<cfscript>
/**
* Converts a query object into an array of structures.
*
* @param query      The query to be transformed
* @return This function returns a structure.
* @author Nathan Dintenfass (nathan@changemedia.com)
* @version 1, September 27, 2001
*/
function QueryToArrayOfStructures(theQuery){
    var theArray = arraynew(1);
    var cols = ListtoArray(theQuery.columnlist);
    var row = 1;
    var thisRow = "";
    var col = 1;
    for(row = 1; row LTE theQuery.recordcount; row = row + 1){
        thisRow = structnew();
        for(col = 1; col LTE arraylen(cols); col = col + 1){
            thisRow[cols[col]] = theQuery[cols[col]][row];
        }
        arrayAppend(theArray,duplicate(thisRow));
    }
    return(theArray);
}
</cfscript>
<cfscript>
/**
* Returns the 2 character english text ordinal for numbers.
*
* @param num      Number you wish to return the ordinal for. (Required)
* @return Returns a string.
* @author Mark Andrachek (hallow@webmages.com)
* @version 1, November 5, 2003
*/
function GetOrdinal(num) {
// if the right 2 digits are 11, 12, or 13, set num to them.
// Otherwise we just want the digit in the one's place.
var two=Right(num,2);
var ordinal="";
switch(two) {
case "11":
case "12":
case "13": { num = two; break; }
default: { num = Right(num,1); break; }
}

// 1st, 2nd, 3rd, everything else is "th"
switch(num) {
case "1": { ordinal = "st"; break; }
case "2": { ordinal = "nd"; break; }
case "3": { ordinal = "rd"; break; }
default: { ordinal = "th"; break; }
}

// return the text.
return ordinal;
}
</cfscript>